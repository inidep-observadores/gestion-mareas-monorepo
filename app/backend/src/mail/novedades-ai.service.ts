import { Injectable, Logger } from '@nestjs/common';
import { ConfigService } from '@nestjs/config';
import { GoogleGenAI } from '@google/genai';

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
        origen: { type: 'string', description: 'Ciudad de origen del viaje' },
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
            description: 'Lista de períodos solicitados.',
            items: {
                type: 'object',
                properties: {
                    tipoNovedad: { 
                        type: 'string', 
                        enum: ['LICEN', 'FC', 'RP', 'ENFERMEDAD'],
                        description: 'Código de novedad. LICEN para licencia o vacaciones, FC para franco compensatorio, RP para razones particulares, ENFERMEDAD para parte de enfermo.'
                    },
                    fechaInicio: { type: 'string', description: 'Fecha de inicio del período en formato YYYY-MM-DD' },
                    fechaFin: { type: 'string', description: 'Fecha de fin del período en formato YYYY-MM-DD' },
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
            description: 'Lista de períodos informados.',
            items: {
                type: 'object',
                properties: {
                    tipoNovedad: { 
                        type: 'string', 
                        enum: ['DISPONIBLE', 'NO_DISPONIBLE', 'LICEN', 'FC', 'ENFERMEDAD'],
                        description: 'Estado o novedad reportada'
                    },
                    fechaInicio: { type: 'string', description: 'Fecha de inicio del período en formato YYYY-MM-DD' },
                    fechaFin: { type: 'string', description: 'Fecha de fin del período en formato YYYY-MM-DD' },
                    motivo: { type: 'string', description: 'Breve motivo o descripción' }
                },
                required: ['tipoNovedad', 'fechaInicio', 'fechaFin']
            }
        }
    },
    required: ['observador', 'periodos']
};

@Injectable()
export class NovedadesAiService {
    private readonly logger = new Logger(NovedadesAiService.name);
    private ai: GoogleGenAI;
    private readonly modelName: string;

    constructor(private readonly configService: ConfigService) {
        const apiKey = this.configService.get<string>('GEMINI_API_KEY') || 'dummy-key';
        this.modelName = this.configService.get<string>('LLM_MODEL') || 'gemini-3.1-flash-lite';
        
        this.ai = new GoogleGenAI({ apiKey });
    }

    private async runWithBackoff(fn: () => Promise<any>, maxRetries = 5) {
        let retries = 0;
        while (retries < maxRetries) {
            try {
                return await fn();
            } catch (error: any) {
                const isQuotaError = error.status === 429 || error.status === 503 || 
                                     (error.message && (error.message.includes('429') || error.message.includes('quota') || error.message.includes('exhausted')));
                if (isQuotaError) {
                    retries++;
                    const waitTime = Math.pow(2, retries) * 1000;
                    this.logger.warn(`Error temporal de cuota (HTTP 429). Reintentando en ${waitTime / 1000}s... (Intento ${retries}/${maxRetries})`);
                    await new Promise(resolve => setTimeout(resolve, waitTime));
                } else {
                    throw error;
                }
            }
        }
        throw new Error('Se excedió el número máximo de reintentos tras errores de cuota.');
    }

    async procesarElemento(texto: string, attachment?: { buffer: Buffer, mimetype: string, filename: string }): Promise<any> {
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

        let docType: 'PASAJES' | 'GDE' | 'TEXTO_LIBRE' = 'TEXTO_LIBRE';
        let configSchema: any;
        let promptSystem = '';

        const fechaActualStr = new Date().toLocaleDateString('es-AR', { day: '2-digit', month: 'long', year: 'numeric' });
        const contextAdicional = `\nLa fecha actual es: ${fechaActualStr}. Si el texto no especifica el año, utiliza o deduce el año basándote en esta fecha actual. Extrae SIEMPRE formato YYYY-MM-DD.` + 
            (attachment ? `\n\nDATO CLAVE: El nombre del archivo adjunto es "${attachment.filename}". A menudo, el nombre del archivo contiene el número de GDE exacto (con guiones y letras, ej: NO-2026-67719830-APN-DIOYT...). Úsalo para extraer el "numeroGde" si no se lee bien en el texto.` : '');

        if (isScanOrImage && !textContent) {
            docType = 'PASAJES';
            configSchema = schemaPasajes;
            promptSystem = 'Extrae la información del boleto/pasaje de viaje. Asegúrate de extraer el DNI si figura. Si es otro tipo de documento, intenta mapearlo a este esquema.' + contextAdicional;
        } else {
            const cleanText = textContent.toLowerCase();
            if (cleanText.includes('poder ejecutivo nacional') || cleanText.includes('referencia:')) {
                docType = 'GDE';
                configSchema = schemaNovedadesGDE;
                promptSystem = 'Extrae los datos de la nota administrativa oficial de GDE (Licencias, Francos Compensatorios, etc.). Asegúrate de extraer EXPRESAMENTE el "Número de GDE". El formato típico suele ser similar a "NO-2026-67720716-APN-DIOYT#INIDEP" o "IF-2026-12345678-APN-DIR#INIDEP" (busca prefijos como NO-, IF-, ME- seguidos de año, número y repartición). También extrae el "CUIL" o "DNI" del observador buscándolos detalladamente en el texto. Mapea los períodos solicitados al array de períodos.' + contextAdicional;
            } else if (cleanText.includes('boleto') || cleanText.includes('pasaje') || cleanText.includes('butaca') || cleanText.includes('voucher') || cleanText.includes('origen:')) {
                docType = 'PASAJES';
                configSchema = schemaPasajes;
                promptSystem = 'Extrae los datos del viaje del boleto o e-ticket. Asegúrate de extraer el DNI del pasajero si figura.' + contextAdicional;
            } else {
                docType = 'TEXTO_LIBRE';
                configSchema = schemaDisponibilidadEmail;
                promptSystem = 'Extrae los datos del mensaje informal de disponibilidad u otras novedades. Mapea todos los rangos o días mencionados al array de periodos.' + contextAdicional;
            }
        }

        try {
            const response = await this.runWithBackoff(async () => {
                return await this.ai.models.generateContent({
                    model: this.modelName,
                    contents: isScanOrImage ? [
                        {
                            role: 'user',
                            parts: [
                                { inlineData: { data: base64Data, mimeType: mimeType } },
                                { text: promptSystem + (textContent ? `\n\nTexto OCR previo:\n${textContent}` : '') }
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
                });
            }, 5);

            const parsedJson = JSON.parse(response.text || '{}');
            parsedJson._metadata = {
                tipoDocumentoClasificado: docType
            };
            return parsedJson;

        } catch (error: any) {
            this.logger.error(`Error procesando novedad con IA: ${error.message}`);
            throw new Error(`Error de IA: ${error.message}`);
        }
    }
}
