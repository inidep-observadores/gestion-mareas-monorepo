import { Injectable, Logger } from '@nestjs/common';
import { ConfigService } from '@nestjs/config';
import { GoogleGenAI } from '@google/genai';

@Injectable()
export class NovedadesAiService {
    private readonly logger = new Logger(NovedadesAiService.name);
    private ai: GoogleGenAI;

    constructor(private readonly configService: ConfigService) {
        const apiKey = this.configService.get<string>('GEMINI_API_KEY');
        this.ai = new GoogleGenAI({ apiKey: apiKey || 'dummy-key' });
    }

    async procesarNovedad(texto: string): Promise<any> {
        const prompt = `
Eres un asistente experto en recursos humanos y logística pesquera. Tu tarea es extraer datos de notificaciones de novedades (licencias, francos, disponibilidades) de observadores pesqueros a partir de texto (que generalmente proviene de PDFs parseados o cuerpos de correos).

Extrae la información y devuélvela estrictamente cumpliendo el esquema JSON requerido.
Reglas:
1. "estadoDisponibilidad" debe ser uno de estos códigos: 'LICEN', 'FC', 'RP', 'ENFERMEDAD', 'DISPONIBLE'. Si es una 'Licencia Anual Ordinaria', usa 'LICEN'.
2. Las fechas ("fechaInicio" y "fechaFin") deben extraerse y formatearse estrictamente como 'YYYY-MM-DD', que es el formato ISO estándar requerido por nuestra base de datos PostgreSQL.

Texto a analizar:
"""
${texto}
"""
`;
        try {
            const response = await this.ai.models.generateContent({
                model: 'gemini-2.5-flash',
                contents: prompt,
                config: {
                    responseMimeType: 'application/json',
                    responseSchema: {
                        type: 'OBJECT',
                        properties: {
                            observador: { type: 'STRING' },
                            cuil: { type: 'STRING' },
                            estadoDisponibilidad: { type: 'STRING' },
                            fechaInicio: { type: 'STRING' },
                            fechaFin: { type: 'STRING' },
                            motivo: { type: 'STRING' }
                        },
                        required: ['observador', 'estadoDisponibilidad', 'fechaInicio']
                    }
                }
            });

            if (!response.text) {
                throw new Error('Gemini no devolvió respuesta.');
            }

            return JSON.parse(response.text);
        } catch (error) {
            this.logger.error(`Error procesando novedad con IA: ${error.message}`);
            throw error;
        }
    }
}
