import { Injectable, Logger } from '@nestjs/common';
import { ConfigService } from '@nestjs/config';
import OpenAI from 'openai';

let pdfParse: any;
try {
    pdfParse = require('pdf-parse');
} catch (e) {
    console.warn('Advertencia: pdf-parse no está disponible.');
}

@Injectable()
export class NovedadesAiService {
    private readonly logger = new Logger(NovedadesAiService.name);
    private openai: OpenAI;

    constructor(private readonly configService: ConfigService) {
        // Soporte universal para cualquier variable de autenticación que tengas configurada
        const apiKey = this.configService.get<string>('LLM_API_KEY') || 
                       this.configService.get<string>('OLLAMA_API_KEY') || 
                       this.configService.get<string>('GEMINI_API_KEY') || 
                       this.configService.get<string>('OPENROUTER_API_KEY');
                       
        const baseURL = this.configService.get<string>('LLM_BASE_URL') || 
                        this.configService.get<string>('OPENAI_BASE_URL') || 
                        'https://openrouter.ai/api/v1';

        this.openai = new OpenAI({
            baseURL: baseURL,
            apiKey: apiKey || 'dummy-key',
        });
    }

    async procesarNovedad(texto: string, attachment?: { buffer: Buffer, mimetype: string }): Promise<any> {
        const prompt = `
Eres un sistema experto de extracción de datos para un software de recursos humanos pesquero.
Tu única tarea es leer un texto y extraer la información en un formato JSON estricto.

REGLAS DE EXTRACCIÓN:
1. "observador": Extraer el nombre completo.
2. "estadoDisponibilidad": DEBE ser exactamente uno de estos valores: ["LICEN", "FC", "RP", "ENFERMEDAD", "DISPONIBLE"]. 
   - Si el texto menciona "Licencia Anual Ordinaria", "vacaciones" o "Licencia", usa "LICEN".
   - Si menciona "enfermedad", "certificado médico", usa "ENFERMEDAD".
   - Si menciona "franco compensatorio" o "FC", usa "FC".
3. "fechaInicio": Extraer la fecha de inicio en formato "YYYY-MM-DD".
4. "fechaFin": Extraer la fecha de fin en formato "YYYY-MM-DD". Si no hay fecha de fin, omite esta clave.
5. "motivo": Breve resumen de la justificación, si aplica. (Opcional)

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
  "observador": "Nombre Apellido",
  "estadoDisponibilidad": "LICEN",
  "fechaInicio": "2026-07-15",
  "fechaFin": "2026-07-30"
}
`;
        let useVision = false;
        let mimeType = 'image/jpeg';
        let base64Data = '';
        let contentToAnalyze = texto || '';

        if (attachment) {
            if (attachment.mimetype === 'application/pdf') {
                try {
                    const pdfData = await pdfParse(attachment.buffer);
                    contentToAnalyze += '\n' + pdfData.text;
                    
                    if (pdfData.text.trim().length < 50) {
                        this.logger.warn(`PDF detectado como escaneo. Cambiando a modelo de visión.`);
                        useVision = true;
                        mimeType = 'application/pdf';
                        base64Data = attachment.buffer.toString('base64');
                    }
                } catch (error) {
                    this.logger.error(`Error procesando PDF nativo, intentando como imagen/visión: ${error.message}`);
                    useVision = true;
                    mimeType = 'application/pdf';
                    base64Data = attachment.buffer.toString('base64');
                }
            } else if (attachment.mimetype.startsWith('image/')) {
                useVision = true;
                mimeType = attachment.mimetype;
                base64Data = attachment.buffer.toString('base64');
            } else {
                contentToAnalyze += '\n' + attachment.buffer.toString('utf-8');
            }
        }

        let messages: any[] = [];
        const model = this.configService.get<string>('LLM_MODEL') || 'openrouter/free';

        if (useVision) {
            messages = [
                {
                    role: 'user',
                    content: [
                        { type: 'text', text: prompt + '\nPor favor, extrae los datos de esta imagen/documento.' },
                        { type: 'image_url', image_url: { url: `data:${mimeType};base64,${base64Data}` } }
                    ]
                }
            ];
        } else {
            messages = [{ role: 'user', content: prompt + `\nTexto a analizar:\n"""\n${contentToAnalyze}\n"""\n` }];
        }

        try {
            const response = await this.openai.chat.completions.create({
                model: model,
                messages: messages,
            });

            const content = response.choices[0]?.message?.content || '';
            
            let cleanContent = content.replace(/```json/gi, '').replace(/```/g, '').trim();
            cleanContent = cleanContent.replace(/\/\/.*$/gm, '').trim();
            cleanContent = cleanContent.replace(/,\s*([\}\]])/g, '$1');

            const startIdx = cleanContent.indexOf('{');
            const endIdx = cleanContent.lastIndexOf('}');
            if (startIdx !== -1 && endIdx !== -1 && endIdx > startIdx) {
                cleanContent = cleanContent.substring(startIdx, endIdx + 1);
            }

            if (!cleanContent) {
                throw new Error('El modelo de IA no devolvió contenido.');
            }

            return JSON.parse(cleanContent);
        } catch (error: any) {
            let errorMsg = error.message;
            if (error.response && error.response.data) {
                errorMsg += ' | Detalles del proveedor: ' + JSON.stringify(error.response.data);
            } else if (error.error) {
                errorMsg += ' | Detalles: ' + JSON.stringify(error.error);
            }
            this.logger.error(`Error procesando novedad con IA: ${errorMsg}`);
            throw new Error(`Error de IA: ${errorMsg}`);
        }
    }
}
