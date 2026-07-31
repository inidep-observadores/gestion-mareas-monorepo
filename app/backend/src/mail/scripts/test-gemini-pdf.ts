import { GoogleGenAI } from '@google/genai';
import * as dotenv from 'dotenv';
import * as fs from 'fs';
import * as path from 'path';
const pdfParse = require('pdf-parse');

// Cargar variables de entorno
dotenv.config({ path: path.join(process.cwd(), '.env') });

const apiKey = process.env.GEMINI_API_KEY;
if (!apiKey) {
    console.error('❌ ERROR: No se encontró GEMINI_API_KEY en el archivo .env');
    process.exit(1);
}

const ai = new GoogleGenAI({ apiKey: apiKey });

// --- ESQUEMAS DE RESPUESTA JSON ---

// 1. Esquema para Pasajes / Traslados
const schemaPasajes = {
    type: 'object',
    properties: {
        observador: { type: 'string', description: 'Nombre completo del pasajero/observador' },
        dni: { type: 'string', description: 'DNI del pasajero' },
        origen: { type: 'string', description: 'Ciudad de origen del viaje' },
        destino: { type: 'string', description: 'Ciudad de destino del viaje' },
        fechaViaje: { type: 'string', description: 'Fecha del viaje en formato YYYY-MM-DD' },
        empresa: { type: 'string', description: 'Empresa de transporte (ej: Via Tac, Aerolineas, etc.)' }
    },
    required: ['observador', 'fechaViaje']
};

// 2. Esquema para Novedades Oficiales GDE (Licencias, Francos, etc.)
const schemaNovedadesGDE = {
    type: 'object',
    properties: {
        observador: { type: 'string', description: 'Nombre completo del observador' },
        cuil: { type: 'string', description: 'CUIL o DNI del observador si figura' },
        periodos: {
            type: 'array',
            description: 'Lista de períodos solicitados.',
            items: {
                type: 'object',
                properties: {
                    tipoNovedad: { 
                        type: 'string', 
                        enum: ['LICEN', 'FC', 'RP', 'ENFERMEDAD'],
                        description: 'Código de novedad. LICEN para licencia, FC para franco compensatorio, RP para razones particulares, ENFERMEDAD para parte de enfermo.'
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

// 3. Esquema exclusivo para Emails de Disponibilidad / Texto Libre
const schemaDisponibilidadEmail = {
    type: 'object',
    properties: {
        observador: { type: 'string', description: 'Nombre completo del observador' },
        periodos: {
            type: 'array',
            description: 'Lista de períodos informados de disponibilidad o indisponibilidad.',
            items: {
                type: 'object',
                properties: {
                    tipoNovedad: { 
                        type: 'string', 
                        enum: ['DISPONIBLE', 'NO_DISPONIBLE'],
                        description: 'DISPONIBLE si avisa que puede embarcar/viajar, NO_DISPONIBLE si avisa que no estará disponible (vacaciones, viajes personales, etc.).'
                    },
                    fechaInicio: { type: 'string', description: 'Fecha de inicio del período en formato YYYY-MM-DD' },
                    fechaFin: { type: 'string', description: 'Fecha de fin del período en formato YYYY-MM-DD' },
                    motivo: { type: 'string', description: 'Breve motivo o descripción del aviso' }
                },
                required: ['tipoNovedad', 'fechaInicio', 'fechaFin']
            }
        }
    },
    required: ['observador', 'periodos']
};

async function runWithBackoff(fn: () => Promise<any>, maxRetries = 5) {
    let retries = 0;
    while (retries < maxRetries) {
        try {
            return await fn();
        } catch (error: any) {
            if (error.status === 429 || error.status === 503) {
                retries++;
                const waitTime = Math.pow(2, retries) * 1000;
                console.warn(`⚠️ Error temporal detectado (HTTP ${error.status}). Reintentando en ${waitTime / 1000}s... (Intento ${retries}/${maxRetries})`);
                await new Promise(resolve => setTimeout(resolve, waitTime));
            } else {
                throw error;
            }
        }
    }
    throw new Error('Se excedió el número máximo de reintentos tras errores de cuota.');
}

async function testGeminiOCR() {
    const args = process.argv.slice(2);
    const filePath = args[0] || '.\\old_data\\Pasajes\\eticket_DIEGO_JAVIER_GOROSITO.pdf';

    console.log(`\n==================================================`);
    console.log(`🧪 INICIANDO TEST DINÁMICO CON GEMINI`);
    console.log(`📄 Documento: ${path.basename(filePath)}`);
    console.log(`==================================================\n`);

    try {
        const fileBuffer = fs.readFileSync(filePath);
        const ext = path.extname(filePath).toLowerCase();
        let textContent = '';
        let isScanOrImage = false;

        // 1. Intento de extracción de texto local
        if (ext === '.pdf') {
            console.log('📄 Extrayendo texto básico del PDF...');
            try {
                const parsedPdf = await pdfParse(fileBuffer);
                textContent = parsedPdf.text;
                if (textContent.trim().length < 50) {
                    console.log('⚠️ PDF vacío o escaneado detectado.');
                    isScanOrImage = true;
                }
            } catch (e) {
                console.log('⚠️ Error al parsear PDF localmente. Tratando como escaneo.');
                isScanOrImage = true;
            }
        } else if (ext === '.jpg' || ext === '.jpeg' || ext === '.png' || ext === '.txt') {
            if (ext === '.txt') {
                textContent = fileBuffer.toString('utf-8');
            } else {
                isScanOrImage = true;
            }
        }

        // 2. Determinar tipo de documento
        let docType: 'PASAJES' | 'GDE' | 'TEXTO_LIBRE' = 'TEXTO_LIBRE';
        let configSchema: any;
        let promptSystem = '';

        const fechaActualStr = new Date().toLocaleDateString('es-AR', { day: '2-digit', month: 'long', year: 'numeric' });
        const contextFecha = `\nLa fecha actual del servidor es: ${fechaActualStr}. Si el texto no especifica el año, calcula las fechas y años basándote en esta fecha actual (por ejemplo, si hoy es junio de 2026 y dice "5 de julio", el año es 2026).`;

        if (isScanOrImage) {
            // Si es imagen pura, por defecto asumimos PASAJES como fallback general de escaneo
            docType = 'PASAJES';
            configSchema = schemaPasajes;
            promptSystem = 'Extrae la información del boleto/pasaje de viaje. Si es otro tipo de documento, intenta mapearlo a este esquema.' + contextFecha;
        } else {
            const cleanText = textContent.toLowerCase();
            if (cleanText.includes('poder ejecutivo nacional') || cleanText.includes('referencia:')) {
                docType = 'GDE';
                configSchema = schemaNovedadesGDE;
                promptSystem = 'Extrae los datos de la nota administrativa oficial de GDE (Licencias, Francos Compensatorios, etc.). Mapea los períodos solicitados al array de períodos.' + contextFecha;
            } else if (cleanText.includes('boleto') || cleanText.includes('pasaje') || cleanText.includes('butaca') || cleanText.includes('voucher') || cleanText.includes('origen:')) {
                docType = 'PASAJES';
                configSchema = schemaPasajes;
                promptSystem = 'Extrae los datos del viaje del boleto o e-ticket.' + contextFecha;
            } else {
                docType = 'TEXTO_LIBRE';
                configSchema = schemaDisponibilidadEmail;
                promptSystem = 'Extrae los datos del mensaje informal de disponibilidad u otras novedades. Mapea todos los rangos o días mencionados al array de periodos de disponibilidad o indisponibilidad.' + contextFecha;
            }
        }

        console.log(`🔍 Clasificación local realizada: [${docType}]`);
        console.log(`🚀 Enviando a Gemini 3.1 Flash-Lite con JSON Schema estructurado...`);

        const base64Data = fileBuffer.toString('base64');
        const mimeType = ext === '.png' ? 'image/png' : ext === '.pdf' ? 'application/pdf' : 'image/jpeg';

        const startTime = Date.now();

        const response = await runWithBackoff(async () => {
            return await ai.models.generateContent({
                model: 'gemini-3.1-flash-lite',
                contents: isScanOrImage ? [
                    {
                        role: 'user',
                        parts: [
                            { inlineData: { data: base64Data, mimeType: mimeType } },
                            { text: promptSystem }
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

        const endTime = Date.now();
        const durationMs = endTime - startTime;

        console.log(`\n✅ Procesado en ${(durationMs / 1000).toFixed(2)}s`);
        console.log(`📦 JSON RETORNADO POR GEMINI:`);
        
        try {
            const parsedJson = JSON.parse(response.text || '{}');
            console.log(JSON.stringify(parsedJson, null, 2));
        } catch (jsonErr) {
            console.error('❌ Error al parsear JSON devuelto:', response.text);
        }

        if (response.usageMetadata) {
            console.log(`\n📊 USO DE TOKENS:`);
            console.log(` - Tokens de entrada: ${response.usageMetadata.promptTokenCount}`);
            console.log(` - Tokens de salida: ${response.usageMetadata.candidatesTokenCount}`);
            console.log(` - Total de Tokens: ${response.usageMetadata.totalTokenCount}`);
        }

    } catch (error: any) {
        console.error(`\n❌ ERROR FATAL:`, error);
    }
}

testGeminiOCR().catch(console.error);

