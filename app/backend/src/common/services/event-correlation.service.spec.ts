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

        it('debería retornar IGNORE_OLD si no hay etapas abiertas', async () => {
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

            const result = await service.evaluateEventContext('buque-1', 'ARRIBO', new Date('2024-01-06T10:00:00Z'));

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
});
