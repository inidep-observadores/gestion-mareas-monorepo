import { Injectable, Logger } from '@nestjs/common';
import { ConfigService } from '@nestjs/config';
import { GoogleGenAI } from '@google/genai';
import { PrismaService } from '../prisma/prisma.service';

let pdfParse: any;
try {
    pdfParse = require('pdf-parse');
} catch (e) {
    console.warn('Advertencia: pdf-parse no está disponible.');
}

// 1. Esquema para Pasajes / Traslados
const schemaPasajes = {
    type: 'object',
    properties: {
        observador: { type: 'string', description: 'Nombre completo del pasajero/observador' },
        dni: { type: 'string', description: 'DNI del pasajero si figura. Si no lo encuentras, devuelve un string vacío ""' },
        origen: { type: 'string', description: 'Ciudad de origen del viaje. ATENCIÓN: Busca explícitamente el campo "ORIGEN" o similar. Ignora textos como "SE ANUNCIA A" u otras ciudades mezcladas en el OCR.' },
        destino: { type: 'string', description: 'Ciudad de destino del viaje' },
        fechaSalida: { type: 'string', description: 'Fecha de salida o inicio del viaje en formato YYYY-MM-DD. Si es un viaje con origen Mar del Plata, busca específicamente la fecha de salida desde Mar del Plata.' },
        fechaLlegada: { type: 'string', description: 'Fecha de llegada o arribo al destino en formato YYYY-MM-DD. Si el destino es Mar del Plata, busca explícitamente la fecha estimada de arribo o llegada a Mar del Plata como fecha de finalización. Si no figura una fecha de llegada explícita, usa la misma que la fecha de salida.' },
        empresa: { type: 'string', description: 'Empresa de transporte (ej: Via Tac, Aerolineas, etc.)' }
    },
    required: ['observador', 'fechaSalida', 'fechaLlegada', 'dni', 'origen', 'destino']
};

// 2. Esquema para Novedades Oficiales GDE
const schemaNovedadesGDE = {
    type: 'object',
    properties: {
        observador: { type: 'string', description: 'Nombre completo del observador' },
        cuil: { type: 'string', description: 'CUIL o DNI del observador si figura. Si no lo encuentras, devuelve un string vacío ""' },
        numeroGde: { type: 'string', description: 'Número completo de la nota GDE (ej: NO-2026-67719277-APN-DIOYT#INIDEP). Si no lo encuentras, devuelve un string vacío ""' },
        periodos: {
            type: 'array',
            description: 'Lista de períodos solicitados. IMPORTANTE: Si los días mencionados no son consecutivos (ej. 20, 22, 23 y 24), genera un elemento independiente dentro del array para cada bloque o grupo de días consecutivos (ej. un período para el 20 y otro del 22 al 24).',
            items: {
                type: 'object',
                properties: {
                    tipoNovedad: { 
                        type: 'string', 
                        enum: ['LICEN', 'FC', 'RP', 'ENFERMEDAD'],
                        description: 'Código de novedad. LICEN para licencia o vacaciones, FC para franco compensatorio, RP para razones particulares, ENFERMEDAD para parte de enfermo.'
                    },
                    fechaInicio: { type: 'string', description: 'Fecha de inicio del período en formato YYYY-MM-DD. Si es un único día aislado, fechaInicio y fechaFin deben ser iguales.' },
                    fechaFin: { type: 'string', description: 'Fecha de fin del período en formato YYYY-MM-DD. Si es un único día aislado, fechaInicio y fechaFin deben ser iguales.' },
                    motivo: { type: 'string', description: 'Breve motivo o descripción' }
                },
                required: ['tipoNovedad', 'fechaInicio', 'fechaFin']
            }
        }
    },
    required: ['observador', 'periodos', 'cuil', 'numeroGde']
};

// 3. Esquema para Emails de Disponibilidad / Texto Libre
const schemaDisponibilidadEmail = {
    type: 'object',
    properties: {
        observador: { type: 'string', description: 'Nombre completo del observador' },
        periodos: {
            type: 'array',
            description: 'Lista de períodos informados. IMPORTANTE: Si los días mencionados no son consecutivos, genera un elemento independiente en el array para cada bloque o grupo de días consecutivos.',
            items: {
                type: 'object',
                properties: {
                    tipoNovedad: { 
                        type: 'string', 
                        enum: ['DISPONIBLE', 'NO_DISPONIBLE', 'LICEN', 'FC', 'ENFERMEDAD', 'VIAJE_INICIO', 'VIAJE_FIN'],
                        description: 'Estado o novedad reportada. ATENCION: Si se detecta que se trata de un boleto o pasaje de viaje desde Mar del Plata hacia otro destino, usar VIAJE_INICIO. Si es un pasaje desde otro destino hacia Mar del Plata, usar VIAJE_FIN.'
                    },
                    fechaInicio: { type: 'string', description: 'Fecha de inicio del período en formato YYYY-MM-DD. Si es un único día aislado, fechaInicio y fechaFin deben ser iguales.' },
                    fechaFin: { type: 'string', description: 'Fecha de fin del período en formato YYYY-MM-DD. Dejar nulo o no incluir si no se especifica explícitamente.' },
                    motivo: { type: 'string', description: 'Breve motivo o descripción' }
                },
                required: ['tipoNovedad', 'fechaInicio']
            }
        }
    },
    required: ['observador', 'periodos']
};

// 4. Esquema para Cédula de Embarque (NIDO / Prefectura)
const schemaCedulaEmbarque = {
    type: 'object',
    properties: {
        observador: { type: 'string', description: 'Nombre y apellido completos del titular de la cédula' },
        apellido: { type: 'string', description: 'Apellido que figura en la cédula (ej: DI TULLIO)' },
        nombre: { type: 'string', description: 'Nombres que figuran en la cédula (ej: DANIEL ALEJANDRO)' },
        dni: { type: 'string', description: 'Número de DNI del observador (solo dígitos numéricos, sin puntos)' },
        numeroRegistro: { type: 'integer', description: 'Número de registro / cédula que figura como "N° Registro" (ej: 500228). Extraer como entero numérico.' },
        vencimientoCedula: { type: 'string', description: 'Fecha en el recuadro "VENCIMIENTO CÉDULA DE EMBARCO" en formato YYYY-MM-DD' },
        vencimientoAptoMedico: { type: 'string', description: 'Fecha en el recuadro "VENCIMIENTO RECONOCIMIENTO MÉDICO" en formato YYYY-MM-DD' },
        nuevoVencimientoAptoMedico: { type: 'string', description: 'Fecha en el recuadro "NUEVO VENCIMIENTO RECONOCIMIENTO MÉDICO" si está completada con una fecha válida (YYYY-MM-DD). Si está vacía o contiene puntos (".... / .... / ...."), devolver string vacío ""' },
        fechaEmision: { type: 'string', description: 'Fecha de emisión que figura en "Lugar y Fecha" en formato YYYY-MM-DD' }
    },
    required: ['observador', 'dni', 'numeroRegistro', 'vencimientoCedula', 'vencimientoAptoMedico']
};

// 5. Esquema para Triage (Fase 1)
const schemaTriage = {
    type: 'object',
    properties: {
        candidatos: {
            type: 'array',
            description: 'Lista de posibles novedades encontradas en el correo o sus adjuntos.',
            items: {
                type: 'object',
                properties: {
                    tipoDocumento: { 
                        type: 'string', 
                        enum: ['PASAJES', 'GDE', 'CEDULA_EMBARQUE', 'TEXTO_LIBRE', 'IRRELEVANTE'],
                        description: 'Tipo de documento o novedad. Usar CEDULA_EMBARQUE para cédulas o libretas de embarco (NIDO / Prefectura). Usar IRRELEVANTE si es spam, firmas de correo, o no contiene novedades.'
                    },
                    fuente: { 
                        type: 'string', 
                        enum: ['CUERPO_EMAIL', 'ADJUNTO'],
                        description: 'Indica si la información está en el cuerpo del correo o en un archivo adjunto.'
                    },
                    nombreArchivo: { type: 'string', description: 'Obligatorio si la fuente es ADJUNTO. El nombre exacto del archivo adjunto.' }
                },
                required: ['tipoDocumento', 'fuente']
            }
        }
    },
    required: ['candidatos']
};

@Injectable()
export class NovedadesAiService {
    private readonly logger = new Logger(NovedadesAiService.name);
    private ai: GoogleGenAI;
    private readonly modelName: string;
    private readonly fallbackModelName: string;

    constructor(
        private readonly configService: ConfigService,
        private readonly prisma: PrismaService
    ) {
        const apiKey = this.configService.get<string>('GEMINI_API_KEY') || 'dummy-key';
        this.modelName = this.configService.get<string>('LLM_MODEL') || 'gemini-3.1-flash-lite';
        this.fallbackModelName = this.configService.get<string>('LLM_FALLBACK_MODEL') || 'gemma-4-31b-it';
        
        this.ai = new GoogleGenAI({ apiKey });
    }

    private cleanJsonResponse(rawText: string): string {
        if (!rawText) return '';
        return rawText.replace(/<thought>[\s\S]*?<\/thought>/g, '').replace(/```json/gi, '').replace(/```/g, '').trim();
    }

    async clasificarEmail(asunto: string, cuerpoTexto: string, attachments: { buffer: Buffer, mimetype: string, filename: string }[]): Promise<any> {
        const promptSystem = 'Eres un asistente clasificador de correos (Triage). Analiza el Asunto, el Cuerpo y el contenido de los Archivos Adjuntos para determinar qué partes contienen novedades (Licencias, Francos, Pasajes, Cédula de Embarque, etc.). Ahora puedes ver el contenido extraído de los adjuntos. Clasifícalos basándote en su CONTENIDO real: PASAJES para pasajes/boletos de micro o avión; GDE para notas de licencias o francos; CEDULA_EMBARQUE para cédulas o libretas de embarco de Prefectura/INIDEP (con títulos como "CÉDULA DE EMBARCO PERSONAL NO INTEGRANTE DOTACIÓN", "NIDO", "N° Registro", etc.). Genera un candidato ADJUNTO por CADA archivo que contenga información válida. IMPORTANTE: Si la única información relevante se encuentra en los adjuntos, clasifica el CUERPO_EMAIL como IRRELEVANTE. Solo genera un candidato CUERPO_EMAIL si el cuerpo menciona información útil distinta.';

        const parts: any[] = [{ text: `${promptSystem}\n\nDatos:\nAsunto: ${asunto || ''}\n\nCuerpo:\n${cuerpoTexto || ''}\n` }];

        if (attachments && attachments.length > 0) {
            for (const att of attachments) {
                parts.push({ text: `\n--- Archivo Adjunto: ${att.filename} ---\n` });
                const attParts = await this.prepareAttachmentParts(att);
                parts.push(...attParts);
            }
        }

        const requestPayload = {
            contents: [{ role: 'user', parts: parts }],
            config: {
                responseMimeType: 'application/json',
                responseSchema: schemaTriage,
            }
        };

        try {
            const response = await this.ai.models.generateContent({
                model: this.modelName,
                ...requestPayload
            });
            const cleanText = this.cleanJsonResponse(response.text);
            return JSON.parse(cleanText || '{"candidatos": []}');
        } catch (error: any) {
            this.logger.error(`Error en Triage AI: ${error.message}`);
            throw new Error(`Error clasificando correo: ${error.message}`);
        }
    }

    private async prepareAttachmentParts(attachment: { buffer: Buffer, mimetype: string, filename: string }): Promise<any[]> {
        let textContent = '';
        let isScanOrImage = false;
        let mimeType = 'text/plain';
        let base64Data = '';
        const parts: any[] = [];

        const ext = attachment.filename.split('.').pop()?.toLowerCase();
        const lowerMime = attachment.mimetype.toLowerCase();
        
        if (lowerMime.includes('pdf') || ext === 'pdf') {
            try {
                const pdfData = await pdfParse(attachment.buffer);
                textContent = pdfData.text;
                if (textContent.trim().length < 50) {
                    isScanOrImage = true;
                }
            } catch (e) {
                this.logger.warn(`Error al parsear PDF localmente. Tratando como escaneo.`);
                isScanOrImage = true;
            }
            mimeType = 'application/pdf';
        } else if (lowerMime.startsWith('image/') || ['png','jpg','jpeg'].includes(ext || '')) {
            isScanOrImage = true;
            mimeType = lowerMime.startsWith('image/') ? lowerMime : `image/${ext}`;
        } else if (ext === 'txt' || lowerMime.includes('text/plain')) {
            textContent += '\n' + attachment.buffer.toString('utf-8');
        } else {
            return [{ text: `(Archivo no soportado para análisis automático: ${attachment.filename})` }];
        }
        
        if (isScanOrImage || mimeType === 'application/pdf') {
            base64Data = attachment.buffer.toString('base64');
            parts.push({ inlineData: { data: base64Data, mimeType: mimeType } });
        }
        if (textContent) {
            parts.push({ text: `Texto extraído:\n${textContent}` });
        }
        
        return parts;
    }

    async procesarElemento(texto: string, attachment?: { buffer: Buffer, mimetype: string, filename: string }, explicitDocType?: 'PASAJES' | 'GDE' | 'CEDULA_EMBARQUE' | 'TEXTO_LIBRE'): Promise<any> {
        let docType: 'PASAJES' | 'GDE' | 'CEDULA_EMBARQUE' | 'TEXTO_LIBRE' = explicitDocType || 'TEXTO_LIBRE';
        let configSchema: any;
        let promptSystem = '';

        const fechaActualStr = new Date().toLocaleDateString('es-AR', { day: '2-digit', month: 'long', year: 'numeric' });
        const contextAdicional = `\nLa fecha actual es: ${fechaActualStr}. Si el texto no especifica el año, utiliza o deduce el año basándote en esta fecha actual. Extrae SIEMPRE formato YYYY-MM-DD.` + 
            (attachment ? `\n\nDATO CLAVE: El nombre del archivo adjunto es "${attachment.filename}". A menudo, el nombre del archivo contiene el número de GDE o cédula. Úsalo si es relevante.` : '');

        if (docType === 'GDE') {
            configSchema = schemaNovedadesGDE;
            promptSystem = 'Extrae los datos de la nota administrativa oficial de GDE (Licencias, Francos Compensatorios, etc.). Asegúrate de extraer EXPRESAMENTE el "Número de GDE" (ej: NO-2026-67720716-APN-DIOYT#INIDEP). También extrae el "CUIL" o "DNI" del observador. ' +
                'ATENCIÓN A DÍAS DISCONTINUOS O SALTEADOS: Cuando la nota enumere días discontinuos o salteados (ej: "días 20, 22, 23 y 24"), NUNCA crees un único rango continuo que incluya los días intermedios ausentes. Debes dividir la solicitud en múltiples elementos dentro del array "periodos", agrupando solo días consecutivos (ej: Período 1: 2026-07-20 a 2026-07-20; Período 2: 2026-07-22 a 2026-07-24). ' +
                'IMPORTANTE PARA LICENCIAS ANUALES ORDINARIAS (Vacaciones): Presta especial atención a la tabla de fechas. Debido al formato OCR, a veces las columnas aparecen pegadas, por ejemplo: "202420/07/202629/07/202610". Esto significa: Año 2024, Fecha Desde 20/07/2026, Fecha Hasta 29/07/2026, y 10 días. Extrae las fechas de inicio y fin basándote en esta lógica de descompresión de texto pegado. Ignora el "Año" de devengamiento de la licencia (ej. 2024), solo nos importan las fechas reales (F/ DESDE y F/ HASTA) para el período.' + contextAdicional;
        } else if (docType === 'PASAJES') {
            configSchema = schemaPasajes;
            promptSystem = 'Extrae los datos del viaje del boleto o e-ticket. Asegúrate de extraer el DNI del pasajero si figura. PRECAUCIÓN CON EL FORMATO: Al extraerse el texto de un PDF con columnas, es posible que los datos se mezclen línea por línea. Busca expresamente la etiqueta "ORIGEN" para determinar la ciudad de origen y la etiqueta "DESTINO" para el destino. No confundas el origen con campos como "SE ANUNCIA A". ATENCIÓN A LAS FECHAS: SIEMPRE debes intentar extraer tanto la fechaSalida como la fechaLlegada. Si es un inicio de viaje (salida desde Mar del Plata), asegúrate de que fechaSalida sea exactamente la fecha de partida desde Mar del Plata. Si es un fin de viaje (destino Mar del Plata), asegúrate de buscar la fecha de arribo o llegada a Mar del Plata para usarla como fechaLlegada.' + contextAdicional;
        } else if (docType === 'CEDULA_EMBARQUE') {
            configSchema = schemaCedulaEmbarque;
            promptSystem = 'Extrae con máxima precisión los datos de la Cédula de Embarco de Personal No Integrante Dotación (NIDO) emitida por Prefectura Naval Argentina para el INIDEP. ' +
                'CAMPOS OBLIGATORIOS Y REGLAS DE EXTRACCIÓN: ' +
                '1) "numeroRegistro": Extrae el número numérico que figura como "N° Registro" (ej: 500228). Devuélvelo como número entero. ' +
                '2) "dni": Extrae el número de DNI del observador (ej: 18054157), solo dígitos sin puntos. ' +
                '3) "apellido" y "nombre": Extrae el apellido (ej: DI TULLIO) y nombres (ej: DANIEL ALEJANDRO) de la sección INFORMACIÓN DE LA PERSONA. ' +
                '4) "observador": Nombre completo concatenado "APELLIDO, NOMBRE" o como figure en el documento. ' +
                '5) "vencimientoCedula": Extrae la fecha exacta que figura en el recuadro "VENCIMIENTO CÉDULA DE EMBARCO" en formato YYYY-MM-DD (ej: 19/02/2027 -> 2027-02-19). ' +
                '6) "vencimientoAptoMedico": Extrae la fecha que figura en el recuadro "VENCIMIENTO RECONOCIMIENTO MÉDICO" en formato YYYY-MM-DD (ej: 19/02/2027 -> 2027-02-19). ' +
                '7) "nuevoVencimientoAptoMedico": Inspecciona con cuidado el recuadro "NUEVO VENCIMIENTO RECONOCIMIENTO MÉDICO". Si contiene una fecha estampada o escrita (con día, mes y año), extráela en formato YYYY-MM-DD. Si está en blanco o solo contiene líneas/puntos (".... / .... / ...."), devuelve un string vacío "". ' +
                '8) "fechaEmision": Extrae la fecha que figura en el encabezado "Lugar y Fecha" (ej: 19 de FEBRERO de 2025 -> 2025-02-19).' + contextAdicional;
        } else {
            configSchema = schemaDisponibilidadEmail;
            promptSystem = 'Extrae los datos del mensaje informal de disponibilidad u otras novedades. ATENCIÓN: Solo extrae datos que estén EXPLÍCITAMENTE ESCRITOS en el texto. NO INVENTES NI DEDUZCAS viajes, ciudades o fechas basándote únicamente en el Asunto del correo. Si el texto es breve y solo dice "Adjunto pasaje" o similar, devuelve un array "periodos" VACÍO para evitar duplicaciones con el archivo adjunto. ATENCIÓN A DÍAS DISCONTINUOS O SALTEADOS: Cuando se informen días no consecutivos, genera un elemento independiente en el array "periodos". Mapea todos los rangos o días mencionados al array de periodos.' + 
                ' REGLAS DE FECHAS PARA DISPONIBILIDAD: 1) Si se indica fecha de inicio y fin, registra ambas. 2) Si se indica SÓLO fecha de inicio (ej: "disponible a partir del 10"), registra solo fechaInicio y omite fechaFin. 3) CASO ESPECIAL: Si se informa una "no disponibilidad" HASTA cierta fecha sin indicar fecha de inicio (ej: "no estaré disponible hasta el 6 de octubre"), asume que es un aviso de DISPONIBILIDAD a partir de esa fecha, por lo que debes clasificarlo como "DISPONIBLE" con fechaInicio igual a esa fecha indicada y omitir fechaFin.' + contextAdicional;
        }

        const parts: any[] = [{ text: promptSystem }];
        if (texto) {
            parts.push({ text: `\n\nTexto a analizar:\n"""\n${texto}\n"""` });
        }
        
        if (attachment) {
            const attParts = await this.prepareAttachmentParts(attachment);
            parts.push(...attParts);
        }

        const requestPayload = {
            contents: [{ role: 'user', parts: parts }],
            config: {
                responseMimeType: 'application/json',
                responseSchema: configSchema,
            }
        };

        let response;
        try {
            response = await this.ai.models.generateContent({
                model: this.modelName,
                ...requestPayload
            });
        } catch (error: any) {
            this.logger.warn(`Error con el modelo principal (${this.modelName}): ${error.message}. Intentando con fallback (${this.fallbackModelName})...`);
            try {
                response = await this.ai.models.generateContent({
                    model: this.fallbackModelName,
                    ...requestPayload
                });
            } catch (fallbackError: any) {
                this.logger.error(`Error procesando novedad con IA (incluso con fallback): ${fallbackError.message}`);
                throw new Error(`Error de IA (Fallback fallido): ${fallbackError.message}`);
            }
        }

            const cleanText = this.cleanJsonResponse(response.text);
            const parsedJson = JSON.parse(cleanText || '{}');
            parsedJson.tipoDocumentoClasificado = docType;
            parsedJson._metadata = {
                tipoDocumentoClasificado: docType
            };

            // Regla de negocio para Cédula de Embarque -> ACTUALIZACION_CEDULA
            if (docType === 'CEDULA_EMBARQUE') {
                const fechaEmision = parsedJson.fechaEmision || new Date().toISOString().split('T')[0];
                const vtoCedula = parsedJson.vencimientoCedula || fechaEmision;

                // Si nuevoVencimientoAptoMedico es una fecha válida, prevalece sobre vencimientoAptoMedico
                const tieneNuevoMedico = parsedJson.nuevoVencimientoAptoMedico && 
                    /^\d{4}-\d{2}-\d{2}$/.test(parsedJson.nuevoVencimientoAptoMedico);
                const aptoMedicoEfectivo = tieneNuevoMedico 
                    ? parsedJson.nuevoVencimientoAptoMedico 
                    : parsedJson.vencimientoAptoMedico;

                const numCedula = parsedJson.numeroRegistro || parsedJson.numeroCedula;

                parsedJson.datosCedula = {
                    numeroCedula: numCedula ? Number(numCedula) : null,
                    vencimientoCedula: vtoCedula,
                    vencimientoAptoMedico: aptoMedicoEfectivo,
                    vencimientoAptoMedicoOriginal: parsedJson.vencimientoAptoMedico,
                    nuevoVencimientoAptoMedico: tieneNuevoMedico ? parsedJson.nuevoVencimientoAptoMedico : null,
                    fechaEmision: fechaEmision,
                    dni: parsedJson.dni,
                    nombre: parsedJson.nombre,
                    apellido: parsedJson.apellido
                };

                const formatFechaAR = (fechaStr: string) => {
                    if (!fechaStr) return 'S/D';
                    const match = fechaStr.match(/^(\d{4})-(\d{2})-(\d{2})$/);
                    if (match) return `${match[3]}/${match[2]}/${match[1]}`;
                    return fechaStr;
                };

                const vtoCedulaAR = formatFechaAR(vtoCedula);
                const aptoMedicoAR = formatFechaAR(aptoMedicoEfectivo);

                const hoyISO = new Date().toISOString().split('T')[0];
                parsedJson.periodos = [{
                    tipoNovedad: 'ACTUALIZACION_CEDULA',
                    fechaInicio: hoyISO,
                    fechaFin: hoyISO,
                    motivo: `Actualización de Cédula de Embarque Nº ${numCedula || 'S/N'} (Vto: ${vtoCedulaAR}, Apto Médico: ${aptoMedicoAR})`
                }];
            }

            // Regla de negocio para Pasajes -> VIAJE_INICIO o VIAJE_FIN
            if (docType === 'PASAJES') {
                const origen = (parsedJson.origen || '').toLowerCase();
                const destino = (parsedJson.destino || '').toLowerCase();
                let tipoViaje = null;

                // Mar del Plata puede estar escrito de varias formas
                const esMdq = (str: string) => str.includes('mar del plata') || str.includes('mdp') || str.includes('mdq');

                if (esMdq(origen)) {
                    tipoViaje = 'VIAJE_INICIO';
                } else if (esMdq(destino)) {
                    tipoViaje = 'VIAJE_FIN';
                }

                if (tipoViaje && parsedJson.fechaSalida) {
                    parsedJson.periodos = [{
                        tipoNovedad: tipoViaje,
                        fechaInicio: parsedJson.fechaSalida,
                        fechaFin: parsedJson.fechaLlegada || parsedJson.fechaSalida, // Si no tiene llegada, autocierre
                        motivo: `Viaje: ${parsedJson.origen || '?'} -> ${parsedJson.destino || '?'} (${parsedJson.empresa || 'Empresa de transporte'})`
                    }];
                } else {
                    // Si no incluye Mar del Plata en origen o destino, o falta la fecha, lo ignoramos dejando periodos vacío
                    parsedJson.periodos = [];
                    parsedJson._metadata.motivoDescarte = 'VIAJE_SIN_MDQ';
                }
            }

            // Regla de negocio para Francos Compensatorios -> Quitar fines de semana
            if (parsedJson.periodos && Array.isArray(parsedJson.periodos)) {
                const nuevosPeriodos = [];
                for (const periodo of parsedJson.periodos) {
                    if (periodo.tipoNovedad === 'FC' && periodo.fechaInicio && periodo.fechaFin) {
                        // Forzamos la hora a mediodía UTC para evitar desplazamientos por zona horaria al instanciar Date
                        const start = new Date(periodo.fechaInicio + 'T12:00:00Z');
                        const end = new Date(periodo.fechaFin + 'T12:00:00Z');

                        // Obtener feriados en el rango
                        const feriados = await this.prisma.feriado.findMany({
                            where: {
                                fecha: {
                                    gte: new Date(periodo.fechaInicio + 'T00:00:00Z'),
                                    lte: new Date(periodo.fechaFin + 'T23:59:59Z')
                                }
                            }
                        });
                        const feriadosSet = new Set(feriados.map(f => f.fecha.toISOString().split('T')[0]));

                        let currentStart = null;
                        let currentEnd = null;

                        const d = new Date(start);
                        while (d <= end) {
                            const dateStr = d.toISOString().split('T')[0];
                            const dayOfWeek = d.getUTCDay();
                            const isWeekend = dayOfWeek === 0 || dayOfWeek === 6; // 0=Domingo, 6=Sábado
                            const isFeriado = feriadosSet.has(dateStr);

                            if (!isWeekend && !isFeriado) {
                                if (!currentStart) currentStart = new Date(d);
                                currentEnd = new Date(d);
                            } else {
                                if (currentStart && currentEnd) {
                                    nuevosPeriodos.push({
                                        ...periodo,
                                        fechaInicio: currentStart.toISOString().split('T')[0],
                                        fechaFin: currentEnd.toISOString().split('T')[0]
                                    });
                                    currentStart = null;
                                    currentEnd = null;
                                }
                            }
                            d.setUTCDate(d.getUTCDate() + 1);
                        }
                        if (currentStart && currentEnd) {
                            nuevosPeriodos.push({
                                ...periodo,
                                fechaInicio: currentStart.toISOString().split('T')[0],
                                fechaFin: currentEnd.toISOString().split('T')[0]
                            });
                        }
                    } else {
                        nuevosPeriodos.push(periodo);
                    }
                }
                parsedJson.periodos = nuevosPeriodos;
            }

            return parsedJson;
    }
}
