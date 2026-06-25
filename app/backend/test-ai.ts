import { config } from 'dotenv';
import { GoogleGenAI } from '@google/genai';
import * as fs from 'fs';

config();

async function runTest() {
    const apiKey = process.env.GEMINI_API_KEY;
    const ai = new GoogleGenAI({ apiKey });
    
    // Archivos proporcionados
    const file1Path = "c:\\Users\\danieldt\\Documents\\Desarrollo\\Web\\gestion-mareas-monorepo\\app\\backend\\old_data\\ComunicacionNovedades\\20260604030743692.pdf";
    const file2Path = "c:\\Users\\danieldt\\Documents\\Desarrollo\\Web\\gestion-mareas-monorepo\\app\\backend\\old_data\\ComunicacionNovedades\\20260604030857414.pdf";

    const pdf1Base64 = fs.readFileSync(file1Path).toString("base64");
    const pdf2Base64 = fs.readFileSync(file2Path).toString("base64");

    const prompt = `
Eres un asistente experto en logística pesquera. 
Tu tarea es analizar los comprobantes de pasajes adjuntos (que pueden ser boletos de colectivo o tarjetas de embarque de avión).
El objetivo es determinar:
1. Quién es el pasajero (observador).
2. Si el pasaje representa una salida DESDE Mar del Plata o una llegada HACIA Mar del Plata.

Reglas para "estadoDisponibilidad":
- Usa 'INICIO_VIAJE' si el pasaje indica una salida desde Mar del Plata hacia otro destino.
- Usa 'FIN_VIAJE' si el pasaje indica que el destino final es Mar del Plata.
- Usa 'TRANSITO' si el viaje no involucra a Mar del Plata como origen ni destino (por ejemplo, vuelos internos).

Las fechas deben formatearse como 'YYYY-MM-DD'.
`;
    
    const schema = {
        type: 'OBJECT',
        properties: {
            observador: { type: 'STRING' },
            estadoDisponibilidad: { type: 'STRING' },
            fechaInicio: { type: 'STRING' },
            origen: { type: 'STRING' },
            destino: { type: 'STRING' }
        }
    };

    console.log("🚀 Analizando PDF 1 (Boleto Bus Costera Criolla)...");
    try {
        const response1 = await ai.models.generateContent({
            model: 'gemini-2.5-flash',
            contents: [
                prompt,
                { inlineData: { data: pdf1Base64, mimeType: "application/pdf" } }
            ],
            config: {
                responseMimeType: 'application/json',
                responseSchema: schema
            }
        });
        console.log("✅ === RESULTADO PDF 1 ===");
        console.log(response1.text);
    } catch(e) { console.error(e) }
}

runTest();
