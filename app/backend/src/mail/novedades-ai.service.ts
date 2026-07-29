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
        fechaViaje: { type: 'string', description: 'Fecha del viaje en formato YYYY-MM-DD' },
        empresa: { type: 'string', description: 'Empresa de transporte (ej: Via Tac, Aerolineas, etc.)' }
    },
    required: ['observador', 'fechaViaje', 'dni', 'origen', 'destino']
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
                    fechaFin: { type: 'string', description: 'Fecha de fin del período en formato YYYY-MM-DD. Si es un único día aislado, fechaInicio y fechaFin deben ser iguales.' },
                    motivo: { type: 'string', description: 'Breve motivo o descripción' }
                },
                required: ['tipoNovedad', 'fechaInicio', 'fechaFin']
            }
        }
    },
    required: ['observador', 'periodos']
};

// 4. Esquema para Triage (Fase 1)
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
                        enum: ['PASAJES', 'GDE', 'TEXTO_LIBRE', 'IRRELEVANTE'],
                        description: 'Tipo de documento o novedad. Usar IRRELEVANTE si es spam, firmas de correo, o no contiene novedades.'
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
        this.fallbackModelName = this.configService.get<string>('LLM_FALLBACK_MODEL') || 'gemma-4-31b';
        
        this.ai = new GoogleGenAI({ apiKey });
    }


    async clasificarEmail(asunto: string, cuerpoTexto: string, nombresAdjuntos: string[]): Promise<any> {
        const promptSystem = 'Eres un asistente clasificador de correos (Triage). Analiza el Asunto, el Cuerpo y la lista de Archivos Adjuntos para determinar qué partes contienen información sobre "Novedades de Observadores Pesqueros" (Licencias, Francos, Pasajes, Descansos, etc.). Ignora imágenes de firmas o correos que no tengan relevancia devolviendo tipoDocumento IRRELEVANTE. IMPORTANTE: Si la única información relevante se encuentra en un adjunto y el cuerpo del correo solo dice cosas como "Adjunto pasaje" o es una firma, clasifica el CUERPO_EMAIL como IRRELEVANTE para evitar duplicaciones. Solo genera un candidato CUERPO_EMAIL si el cuerpo menciona información útil distinta o complementaria. Si hay un adjunto con un pasaje o nota GDE, devuelve un candidato ADJUNTO con el nombre exacto del archivo. Puede haber múltiples candidatos (ej. un texto sustancial en el cuerpo y un pasaje en un adjunto).';

        const content = `Asunto: ${asunto || ''}\n\nCuerpo:\n${cuerpoTexto || ''}\n\nArchivos Adjuntos:\n${nombresAdjuntos.join(', ')}`;

        const requestPayload = {
            contents: [{ role: 'user', parts: [{ text: `${promptSystem}\n\nDatos:\n"""\n${content}\n"""` }] }],
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
            return JSON.parse(response.text || '{"candidatos": []}');
        } catch (error: any) {
            this.logger.error(`Error en Triage AI: ${error.message}`);
            throw new Error(`Error clasificando correo: ${error.message}`);
        }
    }

    async procesarElemento(texto: string, attachment?: { buffer: Buffer, mimetype: string, filename: string }, explicitDocType?: 'PASAJES' | 'GDE' | 'TEXTO_LIBRE'): Promise<any> {
        let textContent = texto || '';
        let isScanOrImage = false;
        let mimeType = 'text/plain';
        let base64Data = '';

        if (attachment) {
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
                throw new Error('Tipo de archivo no soportado para análisis: ' + attachment.mimetype);
            }
            
            if (isScanOrImage || mimeType === 'application/pdf') {
                base64Data = attachment.buffer.toString('base64');
            }
        }

        let docType: 'PASAJES' | 'GDE' | 'TEXTO_LIBRE' = explicitDocType || 'TEXTO_LIBRE';
        let configSchema: any;
        let promptSystem = '';

        const fechaActualStr = new Date().toLocaleDateString('es-AR', { day: '2-digit', month: 'long', year: 'numeric' });
        const contextAdicional = `\nLa fecha actual es: ${fechaActualStr}. Si el texto no especifica el año, utiliza o deduce el año basándote en esta fecha actual. Extrae SIEMPRE formato YYYY-MM-DD.` + 
            (attachment ? `\n\nDATO CLAVE: El nombre del archivo adjunto es "${attachment.filename}". A menudo, el nombre del archivo contiene el número de GDE exacto (con guiones y letras, ej: NO-2026-67719830-APN-DIOYT...). Úsalo para extraer el "numeroGde" si no se lee bien en el texto.` : '');

        if (docType === 'GDE') {
            configSchema = schemaNovedadesGDE;
            promptSystem = 'Extrae los datos de la nota administrativa oficial de GDE (Licencias, Francos Compensatorios, etc.). Asegúrate de extraer EXPRESAMENTE el "Número de GDE" (ej: NO-2026-67720716-APN-DIOYT#INIDEP). También extrae el "CUIL" o "DNI" del observador. ' +
                'ATENCIÓN A DÍAS DISCONTINUOS O SALTEADOS: Cuando la nota enumere días discontinuos o salteados (ej: "días 20, 22, 23 y 24"), NUNCA crees un único rango continuo que incluya los días intermedios ausentes. Debes dividir la solicitud en múltiples elementos dentro del array "periodos", agrupando solo días consecutivos (ej: Período 1: 2026-07-20 a 2026-07-20; Período 2: 2026-07-22 a 2026-07-24). ' +
                'IMPORTANTE PARA LICENCIAS ANUALES ORDINARIAS (Vacaciones): Presta especial atención a la tabla de fechas. Debido al formato OCR, a veces las columnas aparecen pegadas, por ejemplo: "202420/07/202629/07/202610". Esto significa: Año 2024, Fecha Desde 20/07/2026, Fecha Hasta 29/07/2026, y 10 días. Extrae las fechas de inicio y fin basándote en esta lógica de descompresión de texto pegado. Ignora el "Año" de devengamiento de la licencia (ej. 2024), solo nos importan las fechas reales (F/ DESDE y F/ HASTA) para el período.' + contextAdicional;
        } else if (docType === 'PASAJES') {
            configSchema = schemaPasajes;
            promptSystem = 'Extrae los datos del viaje del boleto o e-ticket. Asegúrate de extraer el DNI del pasajero si figura. PRECAUCIÓN CON EL FORMATO: Al extraerse el texto de un PDF con columnas, es posible que los datos se mezclen línea por línea. Busca expresamente la etiqueta "ORIGEN" para determinar la ciudad de origen y la etiqueta "DESTINO" para el destino. No confundas el origen con campos como "SE ANUNCIA A".' + contextAdicional;
        } else {
            configSchema = schemaDisponibilidadEmail;
            promptSystem = 'Extrae los datos del mensaje informal de disponibilidad u otras novedades. ATENCIÓN: Solo extrae datos que estén EXPLÍCITAMENTE ESCRITOS en el texto. NO INVENTES NI DEDUZCAS viajes, ciudades o fechas basándote únicamente en el Asunto del correo. Si el texto es breve y solo dice "Adjunto pasaje" o similar, devuelve un array "periodos" VACÍO para evitar duplicaciones con el archivo adjunto. ATENCIÓN A DÍAS DISCONTINUOS O SALTEADOS: Cuando se informen días no consecutivos, genera un elemento independiente en el array "periodos". Mapea todos los rangos o días mencionados al array de periodos.' + contextAdicional;
        }

        const requestPayload = {
            contents: (isScanOrImage || mimeType === 'application/pdf') ? [
                {
                    role: 'user',
                    parts: [
                        { inlineData: { data: base64Data, mimeType: mimeType } },
                        { text: promptSystem + (textContent ? `\n\nTexto extraído previamente (como referencia):\n${textContent}` : '') }
                    ]
                }
            ] : [
                {
                    role: 'user',
                    parts: [
                        { text: `${promptSystem}\n\nTexto a analizar:\n"""\n${textContent}\n"""` }
                    ]
                }
            ],
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

            const parsedJson = JSON.parse(response.text || '{}');
            parsedJson._metadata = {
                tipoDocumentoClasificado: docType
            };

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

                if (tipoViaje && parsedJson.fechaViaje) {
                    parsedJson.periodos = [{
                        tipoNovedad: tipoViaje,
                        fechaInicio: parsedJson.fechaViaje,
                        fechaFin: parsedJson.fechaViaje, // Autocierre
                        motivo: `Viaje: ${parsedJson.origen} -> ${parsedJson.destino} (${parsedJson.empresa || 'Empresa de transporte'})`
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
