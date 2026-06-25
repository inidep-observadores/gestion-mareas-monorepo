import { Test, TestingModule } from '@nestjs/testing';
import { NovedadesAiService } from './novedades-ai.service';
import { ConfigService } from '@nestjs/config';

// Mock de @google/genai
jest.mock('@google/genai', () => ({
    GoogleGenAI: jest.fn().mockImplementation(() => ({
        models: {
            generateContent: jest.fn(),
        },
    })),
}));

import { GoogleGenAI } from '@google/genai';

describe('NovedadesAiService', () => {
    let service: NovedadesAiService;
    let configService: ConfigService;

    beforeEach(async () => {
        jest.clearAllMocks();

        const module: TestingModule = await Test.createTestingModule({
            providers: [
                NovedadesAiService,
                {
                    provide: ConfigService,
                    useValue: {
                        get: jest.fn((key: string) => {
                            if (key === 'GEMINI_API_KEY') return 'fake-api-key';
                            return null;
                        }),
                    },
                },
            ],
        }).compile();

        service = module.get<NovedadesAiService>(NovedadesAiService);
        configService = module.get<ConfigService>(ConfigService);
    });

    it('debería estar definido', () => {
        expect(service).toBeDefined();
    });

    describe('procesarNovedad', () => {
        it('debería extraer correctamente las fechas, nombre y tipo de novedad del PDF de ejemplo real', async () => {
            // Este es un texto real extraído de "NO-2026-46560153-APN-DIOYT#INIDEP.pdf"
            const textoExtraidoPDF = `
                República Argentina - Poder Ejecutivo Nacional
                Referencia: CLAUDIO NADAL-LICENCIA ANUAL ORDINARIA
                ASUNTO: 09 A) Licencia Anual Ordinaria
                AGENTE: CLAUDIO NADAL
                Nº DE CUIL:20160125765 
                AÑO 2025 F/ DESDE 11/05/2026 F/ HASTA 26/05/2026 DIAS 16
                MOTIVO DE LA LICENCIA: Licencia anual ordinaria
            `;

            // Simulamos la respuesta estructurada de Gemini (Structured Outputs)
            const mockGeminiResponse = {
                text: JSON.stringify({
                    observador: 'CLAUDIO NADAL',
                    cuil: '20160125765',
                    estadoDisponibilidad: 'LICEN', // Traducido de "Licencia Anual Ordinaria"
                    fechaInicio: '2026-05-11', // ISO format requerido por backend
                    fechaFin: '2026-05-26', // ISO format
                    motivo: 'Licencia anual ordinaria (16 dias)'
                })
            };

            // Mockeamos el método en la instancia exacta que usa el servicio
            ((service as any).ai.models.generateContent as jest.Mock).mockResolvedValue(mockGeminiResponse);

            const result = await service.procesarNovedad(textoExtraidoPDF);

            expect(result).toBeDefined();
            expect(result.observador).toBe('CLAUDIO NADAL');
            expect(result.cuil).toBe('20160125765');
            expect(result.estadoDisponibilidad).toBe('LICEN');
            expect(result.fechaInicio).toBe('2026-05-11');
            expect(result.fechaFin).toBe('2026-05-26');
            
            // Verificamos que se haya llamado al modelo correctamente
            expect((service as any).ai.models.generateContent).toHaveBeenCalledWith(
                expect.objectContaining({
                    model: 'gemini-2.5-flash',
                    config: expect.objectContaining({
                        responseMimeType: 'application/json'
                    })
                })
            );
        });
    });
});
