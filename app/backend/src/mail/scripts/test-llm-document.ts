import OpenAI from 'openai';
import * as dotenv from 'dotenv';
import * as fs from 'fs';
import * as path from 'path';

// Solo importamos pdf-parse si el archivo es un PDF
let pdfParse: any;
try {
    pdfParse = require('pdf-parse');
} catch (e) {
    // Se ignora, se advertirá en tiempo de ejecución si se intenta usar un PDF
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
    if (args.length === 0) {
        console.error('❌ ERROR: Debes proporcionar la ruta a un documento (PDF, JPG, PNG).');
        console.log('Uso: pnpm test:doc <ruta_al_archivo> [modelo]');
        console.log('Ejemplo: pnpm test:doc ./archivos_prueba/licencia.pdf lfm2.5-1.2b-instruct:q5_k_m');
        process.exit(1);
    }

    const filePath = path.resolve(args[0]);
    const model = args[1] || 'lfm2.5-1.2b-instruct:q5_k_m';
    
    if (!fs.existsSync(filePath)) {
        console.error(`❌ ERROR: No se encontró el archivo en la ruta: ${filePath}`);
        process.exit(1);
    }

    const ext = path.extname(filePath).toLowerCase();
    
    const baseURL = process.env.OPENAI_BASE_URL || 'http://localhost:11434/v1';
    const apiKey = process.env.OPENROUTER_API_KEY || 'ollama';

    console.log(`\n==================================================`);
    console.log(`🧪 INICIANDO TEST DE DOCUMENTO: ${path.basename(filePath)}`);
    console.log(`🤖 Modelo: ${model}`);
    console.log(`==================================================\n`);

    const openai = new OpenAI({ baseURL, apiKey });
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
                mimeType = 'application/pdf';
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
            console.log(`📝 Texto extraído (${contentToAnalyze.length} caracteres). Enviando al modelo...`);
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
        cleanContent = cleanContent.replace(/,\s*([\}\]])/g, '$1');

        const startIdx = cleanContent.indexOf('{');
        const endIdx = cleanContent.lastIndexOf('}');
        if (startIdx !== -1 && endIdx !== -1 && endIdx > startIdx) {
            cleanContent = cleanContent.substring(startIdx, endIdx + 1);
        }
        
        try {
            const parsed = JSON.parse(cleanContent);
            console.log(`✅ JSON Válido!`);
            console.dir(parsed, { depth: null, colors: true });
        } catch (jsonError) {
            console.error(`❌ ERROR: El modelo no devolvió un JSON válido. Error: ${jsonError.message}`);
        }

    } catch (error) {
        console.error(`❌ ERROR de API:`, error.message);
    }
}

runDocumentTest().catch(console.error);
