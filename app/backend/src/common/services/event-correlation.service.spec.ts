import { Test, TestingModule } from '@nestjs/testing';
import { EventCorrelationService, EventDecisionAction } from './event-correlation.service';
import { PrismaService } from '../../prisma/prisma.service';

describe('EventCorrelationService (Hotfix Rules)', () => {
    let service: EventCorrelationService;
    let prisma: PrismaService;

    const mockPrisma = {
        marea: {
            findMany: jest.fn(),
        },
        alerta: {
            findFirst: jest.fn(),
        },
    };

    beforeEach(async () => {
        const module: TestingModule = await Test.createTestingModule({
            providers: [
                EventCorrelationService,
                { provide: PrismaService, useValue: mockPrisma },
            ],
        }).compile();

        service = module.get<EventCorrelationService>(EventCorrelationService);
        prisma = module.get<PrismaService>(PrismaService);
    });

    afterEach(() => {
        jest.clearAllMocks();
    });

    describe('evaluateEventContext - Arribos en Mareas DESIGNADA', () => {
        it('debería retornar NO_MATCH al detectar un ARRIBO en una marea DESIGNADA', async () => {
            mockPrisma.marea.findMany.mockResolvedValue([
                {
                    id: 'marea-1',
                    estadoActual: { codigo: 'DESIGNADA' },
                    etapas: [],
                    buque: { id: 'buque-1' },
                    observadorPrincipal: null,
                },
            ]);
            mockPrisma.alerta.findFirst.mockResolvedValue(null);

            const result = await service.evaluateEventContext('buque-1', 'ARRIBO', new Date());

            expect(result.action).toBe(EventDecisionAction.NO_MATCH);
        });

        it('debería retornar CREATE_ALERT al detectar una ZARPADA en una marea DESIGNADA', async () => {
            mockPrisma.marea.findMany.mockResolvedValue([
                {
                    id: 'marea-1',
                    estadoActual: { codigo: 'DESIGNADA' },
                    etapas: [],
                    buque: { id: 'buque-1' },
                    observadorPrincipal: null,
                },
            ]);
            mockPrisma.alerta.findFirst.mockResolvedValue(null);

            const result = await service.evaluateEventContext('buque-1', 'ZARPADA', new Date());

            expect(result.action).toBe(EventDecisionAction.CREATE_ALERT);
        });
    });

    describe('evaluateEventContext - Arribos en Mareas EN_EJECUCION', () => {
        it('debería retornar RECOMMEND_FIN_MAREA si hay una marea DESIGNADA esperando (Prioridad sobre Arribo)', async () => {
            mockPrisma.marea.findMany.mockResolvedValue([
                {
                    id: 'marea-en-ejecucion',
                    estadoActual: { codigo: 'EN_EJECUCION' },
                    etapas: [{ nroEtapa: 1, fechaZarpada: new Date('2024-01-01T10:00:00Z'), fechaArribo: null }],
                    buque: { id: 'buque-1' },
                    observadorPrincipal: null,
                },
                {
                    id: 'marea-designada',
                    estadoActual: { codigo: 'DESIGNADA' },
                    etapas: [],
                    buque: { id: 'buque-1' },
                    observadorPrincipal: null,
                },
            ]);
            mockPrisma.alerta.findFirst.mockResolvedValue(null);

            const result = await service.evaluateEventContext('buque-1', 'ARRIBO', new Date('2024-01-05T10:00:00Z'));

            expect(result.action).toBe(EventDecisionAction.RECOMMEND_FIN_MAREA);
            expect(result.mareaSiguiente.id).toBe('marea-designada');
        });

        it('debería retornar IGNORE_OLD si el evento es el mismo día que una etapa ya cerrada', async () => {
            mockPrisma.marea.findMany.mockResolvedValue([
                {
                    id: 'marea-1',
                    estadoActual: { codigo: 'EN_EJECUCION' },
                    etapas: [
                        { nroEtapa: 1, fechaZarpada: new Date('2024-01-01T10:00:00Z'), fechaArribo: new Date('2024-01-05T10:00:00Z') }
                    ],
                    buque: { id: 'buque-1' },
                    observadorPrincipal: null,
                },
            ]);
            mockPrisma.alerta.findFirst.mockResolvedValue(null);

            // Misma fecha local (Jan 05) pero hora distinta -> Debe ignorarse como duplicado/viejo en lugar de crear discrepancia
            const result = await service.evaluateEventContext('buque-1', 'ARRIBO', new Date('2024-01-05T15:00:00Z'));

            expect(result.action).toBe(EventDecisionAction.IGNORE_OLD);
        });

        it('debería retornar IGNORE_OLD si el arribo es anterior a la zarpada de la etapa abierta', async () => {
            mockPrisma.marea.findMany.mockResolvedValue([
                {
                    id: 'marea-1',
                    estadoActual: { codigo: 'EN_EJECUCION' },
                    etapas: [
                        { nroEtapa: 1, fechaZarpada: new Date('2024-01-05T10:00:00Z'), fechaArribo: null }
                    ],
                    buque: { id: 'buque-1' },
                    observadorPrincipal: null,
                },
            ]);
            mockPrisma.alerta.findFirst.mockResolvedValue(null);

            const result = await service.evaluateEventContext('buque-1', 'ARRIBO', new Date('2024-01-05T09:00:00Z'));

            expect(result.action).toBe(EventDecisionAction.IGNORE_OLD);
        });

        it('debería retornar CREATE_ALERT si el arribo es válido y NO hay marea designada', async () => {
            mockPrisma.marea.findMany.mockResolvedValue([
                {
                    id: 'marea-1',
                    estadoActual: { codigo: 'EN_EJECUCION' },
                    etapas: [
                        { nroEtapa: 1, fechaZarpada: new Date('2024-01-05T10:00:00Z'), fechaArribo: null }
                    ],
                    buque: { id: 'buque-1' },
                    observadorPrincipal: null,
                },
            ]);
            mockPrisma.alerta.findFirst.mockResolvedValue(null);

            const result = await service.evaluateEventContext('buque-1', 'ARRIBO', new Date('2024-01-05T15:00:00Z'));

            expect(result.action).toBe(EventDecisionAction.CREATE_ALERT);
            expect(result.nroEtapa).toBe(1);
        });
    });

    describe('findExistingAlert - Deduplicación Cruzada', () => {
        it('debería encontrar una alerta previa de PNA al buscar desde Tracking (Source Stacking)', async () => {
            const alertPna = {
                id: 'alert-pna',
                tipo: 'ARRIBO',
                referenciaId: 'marea-1',
                referenciaTipo: 'MAREA',
                metadata: {
                    source: 'API_PNA',
                    buqueId: 'buque-1'
                }
            };

            mockPrisma.alerta.findFirst.mockResolvedValue(alertPna);
            mockPrisma.marea.findMany.mockResolvedValue([
                {
                    id: 'marea-1',
                    estadoActual: { codigo: 'EN_EJECUCION' },
                    etapas: [],
                    buque: { id: 'buque-1' },
                    observadorPrincipal: null,
                },
            ]);

            // Tracking detecta el mismo evento 50 min antes (04:35)
            const trackingDate = new Date('2024-02-06T04:35:00Z');
            const result = await service.evaluateEventContext('buque-1', 'ARRIBO', trackingDate);

            expect(result.action).toBe(EventDecisionAction.VALIDATE_ALERT);
            expect(result.existingAlert.id).toBe('alert-pna');

            // Verificar que se haya llamado a findFirst STRICTAMENTE con el mareaId (referenciaId)
            // y YA NO con el OR buqueId que causaba falsos positivos.
            expect(mockPrisma.alerta.findFirst).toHaveBeenCalledWith(expect.objectContaining({
                where: expect.objectContaining({
                    AND: expect.arrayContaining([
                        expect.objectContaining({ referenciaId: 'marea-1' })
                    ])
                })
            }));
        });

        it('debería CREAR una alerta de ZARPADA si existe una alerta previa de ZARPADA del mismo BUQUE pero de DISTINTA marea', async () => {
            // Escenario: El buque tiene una marea vieja con una alerta de zarpada colgada (pendiente)
            // y una marea nueva DESIGNADA que acaba de zarpar.

            const alertOldMarea = {
                id: 'alert-old',
                tipo: 'ZARPADA',
                referenciaId: 'marea-old',
                metadata: { buqueId: 'buque-1' }
            };

            mockPrisma.marea.findMany.mockResolvedValue([
                {
                    id: 'marea-new',
                    estadoActual: { codigo: 'DESIGNADA' },
                    etapas: [],
                    buque: { id: 'buque-1' },
                }
            ]);

            // La búsqueda estricta para 'marea-new' debe retornar null (no hay alertas para la nueva marea)
            mockPrisma.alerta.findFirst.mockResolvedValue(null);

            const result = await service.evaluateEventContext('buque-1', 'ZARPADA', new Date());

            // Debe CREAR la alerta en lugar de validar la vieja, gracias a la deduplicación estricta
            expect(result.action).toBe(EventDecisionAction.CREATE_ALERT);
            expect(result.marea.id).toBe('marea-new');
        });
    });
});
