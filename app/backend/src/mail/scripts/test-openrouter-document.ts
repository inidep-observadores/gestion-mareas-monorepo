import OpenAI from 'openai';
import * as dotenv from 'dotenv';
import * as fs from 'fs';
import * as path from 'path';

let pdfParse: any;
try {
    pdfParse = require('pdf-parse');
} catch (e) {
    console.warn('Advertencia: pdf-parse no está disponible.');
}

dotenv.config({ path: path.join(process.cwd(), '.env') });

const promptBase = `
Eres un asistente experto en recursos humanos y logística pesquera. Tu tarea es extraer datos de notificaciones de novedades (licencias, francos, disponibilidades) de observadores pesqueros a partir del documento o texto.

FORMATO DE RESPUESTA:
Debes responder ÚNICAMENTE con un objeto JSON válido.
PROHIBIDO incluir comentarios como "//" dentro del JSON.
PROHIBIDO incluir texto antes o después del JSON.

REGLAS DE FECHAS:
- Si el texto menciona varios días seguidos (ej: "16, 17 y 18 de junio"), extrae el primero como "fechaInicio" y el último como "fechaFin".
- PRECAUCIÓN CON EL AÑO: Usa EXACTAMENTE el año indicado en la fecha de inicio/fin (ej. 09/06/2026 -> 2026). NUNCA reemplaces este año con el "Año de la Licencia" (es común que en 2026 se tomen licencias correspondientes al año 2025).

REGLAS PARA PASAJES Y TRASLADOS:
- Si el documento es un pasaje de transporte o traslado, interesa ÚNICAMENTE la fecha en que el viaje SALE desde "Mar del Plata" o LLEGA a "Mar del Plata". Usa esa fecha como "fechaInicio".
- Ignora por completo cualquier fecha de otros tramos u otras ciudades que no involucren a Mar del Plata.

Ejemplo de salida esperada:
{
  "observador": "JUAN PEREZ",
  "cuil": "20-12345678-9",
  "estadoDisponibilidad": "LICEN",
  "fechaInicio": "2023-06-16",
  "fechaFin": "2023-06-18",
  "motivo": "Licencia Anual Ordinaria"
}

Estructura requerida:
- "observador": string (Nombre completo del observador)
- "cuil": string (Opcional)
- "estadoDisponibilidad": string (Debe ser uno de estos códigos: 'LICEN', 'FC', 'RP', 'ENFERMEDAD', 'DISPONIBLE'. Si es 'Licencia Anual Ordinaria', usa 'LICEN')
- "fechaInicio": string (Formato 'YYYY-MM-DD')
- "fechaFin": string (Formato 'YYYY-MM-DD', Opcional)
- "motivo": string (Opcional)
Importante: NO incluyas markdown, explicaciones, ni texto adicional. Solo el objeto JSON válido.
`;

async function runDocumentTest() {
    const args = process.argv.slice(2);
    const filePath = args[0];
    const model = args[1] || process.env.LLM_MODEL || 'openrouter/free';
    
    // Forzamos la configuración a OpenRouter
    const baseURL = process.env.LLM_BASE_URL || process.env.OPENAI_BASE_URL || 'https://openrouter.ai/api/v1';
    const apiKey = process.env.LLM_API_KEY || process.env.OLLAMA_API_KEY || process.env.GEMINI_API_KEY || process.env.OPENROUTER_API_KEY;

    if (!filePath) {
        console.error('❌ ERROR: Debes proporcionar la ruta al archivo.');
        console.error('Uso: pnpm test:or-doc <ruta-al-archivo> [modelo]');
        process.exit(1);
    }

    if (!apiKey) {
        console.error('❌ ERROR: No se encontró LLM_API_KEY en el archivo .env');
        process.exit(1);
    }

    console.log(`\n==================================================`);
    console.log(`🧪 INICIANDO TEST CON OPENROUTER`);
    console.log(`📄 Documento: ${path.basename(filePath)}`);
    console.log(`🤖 Modelo: ${model}`);
    console.log(`==================================================\n`);

    const openai = new OpenAI({
        baseURL,
        apiKey,
        timeout: 30000, // 30 segundos máximo para evitar cuelgues
    });

    let contentToAnalyze = '';

    try {
        const fileBuffer = fs.readFileSync(filePath);
        const ext = path.extname(filePath).toLowerCase();
        let useVision = false;
        let mimeType = 'image/jpeg';
        let base64Data = '';

        if (ext === '.pdf') {
            if (!pdfParse) throw new Error('La librería pdf-parse no está instalada.');
            console.log('📄 Detectado archivo PDF. Extrayendo texto...');
            const data = await pdfParse(fileBuffer);
            contentToAnalyze = data.text;
            
            if (contentToAnalyze.trim().length < 50) {
                console.log('⚠️ El PDF parece ser un escaneo (menos de 50 caracteres extraídos). Usando modelo de visión...');
                useVision = true;
                mimeType = 'application/pdf'; // OpenRouter/Gemini soporta esto, OpenAI puro a veces reniega.
                base64Data = fileBuffer.toString('base64');
            }
        } else if (ext === '.jpg' || ext === '.jpeg' || ext === '.png') {
            console.log('🖼️ Detectado archivo de imagen. Usando modelo de visión...');
            useVision = true;
            mimeType = ext === '.png' ? 'image/png' : 'image/jpeg';
            base64Data = fileBuffer.toString('base64');
        } else {
            contentToAnalyze = fileBuffer.toString('utf-8');
        }

        let messages: any[] = [];
        const startTime = Date.now();

        if (useVision) {
            console.log(`👁️  Enviando imagen/documento en Base64 (${base64Data.length} bytes) al modelo...`);
            messages = [
                {
                    role: 'user',
                    content: [
                        { type: 'text', text: promptBase + '\nPor favor, extrae los datos de esta imagen/documento.' },
                        { type: 'image_url', image_url: { url: `data:${mimeType};base64,${base64Data}` } }
                    ]
                }
            ];
        } else {
            console.log(`📝 Texto extraído (${contentToAnalyze.length} caracteres). Enviando a OpenRouter...`);
            console.log(`\n--- INICIO TEXTO EXTRAÍDO ---`);
            console.log(contentToAnalyze);
            console.log(`--- FIN TEXTO EXTRAÍDO ---\n`);
            
            const prompt = promptBase + `\nTexto a analizar:\n"""\n${contentToAnalyze}\n"""\n`;
            messages = [{ role: 'user', content: prompt }];
        }
        
        const response = await openai.chat.completions.create({
            model: model,
            messages: messages
        });

        const endTime = Date.now();
        const rawContent = response.choices[0]?.message?.content || '';
        const durationMs = endTime - startTime;

        console.log(`\n⏱️  Tiempo de respuesta: ${(durationMs / 1000).toFixed(2)}s`);
        console.log(`📦 Respuesta RAW:\n${rawContent}\n`);

        let cleanContent = rawContent.replace(/```json/gi, '').replace(/```/g, '').trim();
        cleanContent = cleanContent.replace(/\/\/.*$/gm, '').trim();
        
        // Removemos comas finales problemáticas antes de cerrar llaves/corchetes (muy común en SLMs)
        cleanContent = cleanContent.replace(/,\s*([\}\]])/g, '$1');

        // Si el modelo metió texto conversacional (ej. "Aquí tienes el JSON:"), extraemos solo el bloque entre la primera { y la última }
        const startIdx = cleanContent.indexOf('{');
        const endIdx = cleanContent.lastIndexOf('}');
        if (startIdx !== -1 && endIdx !== -1 && endIdx > startIdx) {
            cleanContent = cleanContent.substring(startIdx, endIdx + 1);
        }
        
        try {
            const parsed = JSON.parse(cleanContent);
            console.log(`✅ JSON Válido!`);
            console.log(parsed);
        } catch (jsonError: any) {
            console.error(`❌ ERROR: El modelo no devolvió un JSON válido. Error: ${jsonError.message}`);
        }
    } catch (error: any) {
        console.error(`❌ ERROR:`, error.message);
        if (error.response && error.response.data) {
            console.error('Detalles del error del proveedor:', JSON.stringify(error.response.data, null, 2));
        } else if (error.error) {
            console.error('Detalles del error:', JSON.stringify(error.error, null, 2));
        }
    }
}

runDocumentTest().catch(console.error);
