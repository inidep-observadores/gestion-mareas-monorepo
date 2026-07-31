import { Test, TestingModule } from '@nestjs/testing';
import { NovedadesAiService } from './novedades-ai.service';
import { ConfigService } from '@nestjs/config';
import { PrismaService } from '../prisma/prisma.service';

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
                            if (key === 'LLM_MODEL') return 'gemini-3.1-flash-lite';
                            return null;
                        }),
                    },
                },
                {
                    provide: PrismaService,
                    useValue: {
                        feriado: {
                            findMany: jest.fn().mockResolvedValue([]),
                        },
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

    describe('procesarElemento', () => {
        it('debería extraer correctamente las fechas, nombre y periodo de novedad del PDF de ejemplo real', async () => {
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
                    numeroGde: 'NO-2026-46560153-APN-DIOYT#INIDEP',
                    periodos: [
                        {
                            tipoNovedad: 'LICEN',
                            fechaInicio: '2026-05-11',
                            fechaFin: '2026-05-26',
                            motivo: 'Licencia anual ordinaria'
                        }
                    ]
                })
            };

            // Mockeamos el método en la instancia exacta que usa el servicio
            ((service as any).ai.models.generateContent as jest.Mock).mockResolvedValue(mockGeminiResponse);

            const result = await service.procesarElemento(textoExtraidoPDF);

            expect(result).toBeDefined();
            expect(result.observador).toBe('CLAUDIO NADAL');
            expect(result.cuil).toBe('20160125765');
            expect(result.periodos).toBeDefined();
            expect(result.periodos[0].tipoNovedad).toBe('LICEN');
            expect(result.periodos[0].fechaInicio).toBe('2026-05-11');
            expect(result.periodos[0].fechaFin).toBe('2026-05-26');
            
            // Verificamos que se haya llamado al modelo correctamente
            expect((service as any).ai.models.generateContent).toHaveBeenCalledWith(
                expect.objectContaining({
                    model: 'gemini-3.1-flash-lite',
                    config: expect.objectContaining({
                        responseMimeType: 'application/json'
                    })
                })
            );
        });
    });
});
