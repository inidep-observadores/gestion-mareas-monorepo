import OpenAI from 'openai';
import * as dotenv from 'dotenv';
import { join } from 'path';

dotenv.config({ path: join(process.cwd(), '.env') });

const promptBase = `
Eres un sistema experto de extracción de datos para un software de recursos humanos.
Tu única tarea es leer un texto y extraer la información en un formato JSON estricto.

REGLAS DE EXTRACCIÓN:
1. "observador": Extraer el nombre completo.
2. "estadoDisponibilidad": DEBE ser exactamente uno de estos valores: ["LICEN", "FC", "RP", "ENFERMEDAD", "DISPONIBLE"]. 
   - Si el texto menciona "Licencia Anual Ordinaria" o "vacaciones", usa "LICEN".
   - Si menciona "enfermedad" o "certificado médico", usa "ENFERMEDAD".
   - Si menciona "franco compensatorio" o "FC", usa "FC".
3. "fechaInicio": Extraer la fecha de inicio en formato "YYYY-MM-DD".
4. "fechaFin": Extraer la fecha de fin en formato "YYYY-MM-DD". Si no hay fecha de fin, omite esta clave.

FORMATO DE RESPUESTA:
Debes responder ÚNICAMENTE con un objeto JSON válido. No incluyas texto antes ni después.

Ejemplo de salida esperada:
{
  "observador": "Nombre Apellido",
  "estadoDisponibilidad": "LICEN",
  "fechaInicio": "2026-07-15",
  "fechaFin": "2026-07-30"
}

Texto a analizar:
"""
{{TEXTO}}
"""
`;

const sampleEmails = [
    {
        name: 'Licencia Ordinaria',
        text: 'Por medio de la presente solicito Licencia Anual Ordinaria para el observador Juan Perez, desde el 15 de julio de 2026 hasta el 30 de julio de 2026 inclusive.',
        expectedStatus: 'LICEN',
    },
    {
        name: 'Franco Compensatorio',
        text: 'Aviso que Martin Gomez se tomará FC por los días navegados. Arranca el 01/08/2026 y vuelve el 10/08/2026.',
        expectedStatus: 'FC',
    },
    {
        name: 'Enfermedad sin fecha fin',
        text: 'El observador Roberto Carlos (CUIL 20-12345678-9) presentó certificado médico por enfermedad a partir del día de hoy 27 de junio de 2026. Hasta nuevo aviso.',
        expectedStatus: 'ENFERMEDAD',
    }
];

async function runTests() {
    const args = process.argv.slice(2);
    const model = args[0] || 'lfm2.5-1.2b-instruct:q5_k_m';
    
    const baseURL = process.env.LLM_BASE_URL || process.env.OPENAI_BASE_URL || 'http://localhost:11434/v1';
    const apiKey = process.env.GEMINI_API_KEY || process.env.OPENROUTER_API_KEY || 'ollama';

    console.log(`\n==================================================`);
    console.log(`🧪 INICIANDO TEST DE MODELO LLM: ${model}`);
    console.log(`📡 URL Base: ${baseURL}`);
    console.log(`==================================================\n`);

    const openai = new OpenAI({
        baseURL,
        apiKey,
    });

    for (const sample of sampleEmails) {
        console.log(`\n▶️ Test Case: [${sample.name}]`);
        console.log(`📄 Texto: "${sample.text}"`);
        
        const prompt = promptBase.replace('{{TEXTO}}', sample.text);
        
        const startTime = Date.now();
        try {
            const response = await openai.chat.completions.create({
                model: model,
                messages: [{ role: 'user', content: prompt }],
                response_format: { type: 'json_object' }
            });

            const endTime = Date.now();
            const rawContent = response.choices[0]?.message?.content || '';
            const durationMs = endTime - startTime;

            console.log(`⏱️  Tiempo de respuesta: ${(durationMs / 1000).toFixed(2)}s`);
            console.log(`📦 Respuesta RAW:\n${rawContent}\n`);

            const cleanContent = rawContent.replace(/<thought>[\s\S]*?<\/thought>/g, '').replace(/```json/gi, '').replace(/```/g, '').trim();
            
            try {
                const parsed = JSON.parse(cleanContent);
                console.log(`✅ JSON Válido!`);
                console.log(parsed);

                if (parsed.estadoDisponibilidad === sample.expectedStatus) {
                    console.log(`🎯 Estado Extraído Correctamente: ${parsed.estadoDisponibilidad}`);
                } else {
                    console.log(`⚠️  ADVERTENCIA: Estado esperado era ${sample.expectedStatus} pero devolvió ${parsed.estadoDisponibilidad}`);
                }
            } catch (jsonError) {
                console.error(`❌ ERROR: El modelo no devolvió un JSON válido. Error: ${jsonError.message}`);
            }

        } catch (error) {
            console.error(`❌ ERROR de API:`, error.message);
        }
        console.log(`--------------------------------------------------`);
    }
}

runTests().catch(console.error);
