import 'reflect-metadata';
import { Test, TestingModule } from '@nestjs/testing';
import { MareasService } from './mareas.service';
import { PrismaService } from '../prisma/prisma.service';
import { BusinessRulesService } from '../common/business-rules/business-rules.service';
import { MailService } from '../mail/mail.service';
import { AlertsService } from '../alerts/alerts.service';
import { BadRequestException, NotFoundException } from '@nestjs/common';
import { MareaEstado, TipoEtapa } from './mareas.constants';

describe('MareasService', () => {
    let service: MareasService;
    let prisma: PrismaService;

    const createMockPrisma = () => ({
        marea: {
            findUnique: jest.fn(),
            findMany: jest.fn(),
            update: jest.fn(),
            create: jest.fn(),
            count: jest.fn(),
        },
        buque: {
            findUnique: jest.fn(),
        },
        observador: {
            findUnique: jest.fn(),
        },
        mareaEtapa: {
            findFirst: jest.fn(),
            update: jest.fn(),
            create: jest.fn(),
            deleteMany: jest.fn(),
            count: jest.fn(),
        },
        mareaEtapaObservador: {
            deleteMany: jest.fn(),
            create: jest.fn(),
        },
        mareaMovimiento: {
            create: jest.fn(),
        },
        estadoMarea: {
            findFirst: jest.fn(),
        },
        transicionEstado: {
            findMany: jest.fn(),
            findFirst: jest.fn(),
        },
        $transaction: jest.fn((cb) => cb(mockPrismaService)),
    });

    let mockPrismaService: any;

    const mockBusinessRulesService = {
        getRules: jest.fn().mockReturnValue({
            PLAZO_ENTREGA_DATOS: 15,
            PLAZO_CONFECCION_INFORME: 30,
            PLAZO_PROTOCOLIZACION: 15,
            DIAS_DESCANSO_POST_MAREA: 5,
        }),
    };

    const mockMailService = {};
    const mockAlertsService = {};

    beforeEach(async () => {
        mockPrismaService = createMockPrisma();
        const module: TestingModule = await Test.createTestingModule({
            providers: [
                MareasService,
                { provide: PrismaService, useValue: mockPrismaService },
                { provide: BusinessRulesService, useValue: mockBusinessRulesService },
                { provide: MailService, useValue: mockMailService },
                { provide: AlertsService, useValue: mockAlertsService },
            ],
        }).compile();

        service = module.get<MareasService>(MareasService);
        prisma = module.get<PrismaService>(PrismaService);
    });

    describe('validateStagesChronology (Edge Cases)', () => {
        it('should throw error if arrival is before departure in same stage', () => {
            const stages = [
                {
                    nroEtapa: 1,
                    fechaZarpada: '2025-01-10T10:00:00Z',
                    fechaArribo: '2025-01-09T10:00:00Z', // Invalid
                }
            ];
            expect(() => (service as any).validateStagesChronology(stages))
                .toThrow(/arribo no puede ser anterior a la de zarpada/);
        });

        it('should throw error if stage 2 departure is before stage 1 arrival', () => {
            const stages = [
                {
                    nroEtapa: 1,
                    fechaZarpada: '2025-01-01T10:00:00Z',
                    fechaArribo: '2025-01-05T10:00:00Z',
                },
                {
                    nroEtapa: 2,
                    fechaZarpada: '2025-01-04T10:00:00Z', // Invalid (before Jan 5)
                    fechaArribo: '2025-01-10T10:00:00Z',
                }
            ];
            expect(() => (service as any).validateStagesChronology(stages))
                .toThrow(/fecha de zarpada no puede ser anterior al arribo de la etapa anterior/);
        });

        it('should pass if dates are equal (limit case)', () => {
            const stages = [
                {
                    nroEtapa: 1,
                    fechaZarpada: '2025-01-01T10:00:00Z',
                    fechaArribo: '2025-01-05T10:00:00Z',
                },
                {
                    nroEtapa: 2,
                    fechaZarpada: '2025-01-05T10:00:00Z', // Equal is allowed
                    fechaArribo: '2025-01-10T10:00:00Z',
                }
            ];
            expect(() => (service as any).validateStagesChronology(stages)).not.toThrow();
        });
    });

    describe('update (Impediment check)', () => {
        it('should throw BadRequestException if assigning an observer with impediment', async () => {
            const mareaId = 'marea-uuid';
            const observerId = 'obs-uuid';
            
            mockPrismaService.marea.findUnique.mockResolvedValue({ observadorPrincipalId: 'old-obs' });
            mockPrismaService.observador.findUnique.mockResolvedValue({ 
                conImpedimento: true, 
                motivoImpedimento: 'Licencia medica' 
            });

            await expect(service.update(mareaId, { observadorId: observerId } as any))
                .rejects.toThrow(BadRequestException);
            
            await expect(service.update(mareaId, { observadorId: observerId } as any))
                .rejects.toThrow(/No se puede asignar el observador porque posee un impedimento/);
        });
    });

    describe('executeAction - RECIBIR_DATOS (Date range checks)', () => {
        it('should throw if reception date is before arrival', async () => {
            const mareaId = 'uuid';
            const marea = {
                id: mareaId,
                estadoActualId: 'estado-waiting',
                fechaInicioObservador: new Date('2025-01-01'),
                fechaFinObservador: new Date('2025-01-10'),
                etapas: [
                    { nroEtapa: 1, fechaZarpada: new Date('2025-01-01'), fechaArribo: new Date('2025-01-10') }
                ]
            };
            
            mockPrismaService.marea.findUnique.mockResolvedValue(marea);
            mockPrismaService.transicionEstado.findFirst.mockResolvedValue({
                estadoDestinoId: 'estado-received',
                etiqueta: 'Recibir'
            });

            const payload = {
                fechaRecepcion: '2025-01-09T00:00:00Z', // Before end (Jan 10)
                fechaInicioObservador: '2025-01-01T00:00:00Z',
                fechaFinObservador: '2025-01-10T00:00:00Z'
            };

            await expect(service.executeAction(mareaId, 'RECIBIR_DATOS', { id: 'user-id' } as any, payload))
                .rejects.toThrow(/La fecha de recepción no puede ser anterior a la finalización del observador/);
        });

        it('should throw if observer dates are inconsistent with stages', async () => {
            const mareaId = 'uuid';
            const marea = {
                id: mareaId,
                estadoActualId: 'estado-waiting',
                etapas: [
                    { nroEtapa: 1, fechaZarpada: new Date('2025-01-02'), fechaArribo: new Date('2025-01-10') }
                ]
            };
            
            mockPrismaService.marea.findUnique.mockResolvedValue(marea);
            mockPrismaService.transicionEstado.findFirst.mockResolvedValue({
                estadoDestinoId: 'estado-received',
                etiqueta: 'Recibir'
            });

            // Observer starts after stage 1 zarpada (inconsistent)
            const payload = {
                fechaRecepcion: '2025-01-15T00:00:00Z',
                fechaInicioObservador: '2025-01-03T00:00:00Z', // Should be <= 2025-01-02
                fechaFinObservador: '2025-01-10T00:00:00Z'
            };

            await expect(service.executeAction(mareaId, 'RECIBIR_DATOS', { id: 'user-id' } as any, payload))
                .rejects.toThrow(/inicio del observador no puede ser posterior a la zarpada/);
        });
    });

    describe('create (Uniqueness and Initialization)', () => {
        it('should throw error if marea already exists', async () => {
            const dto = {
                anioMarea: 2025,
                nroMarea: 1,
                tipoMarea: 'MC',
                buqueId: 'buque-1',
                pesqueriaId: 'pesq-1',
                observadorId: 'obs-1',
                fechaZarpadaEstimada: '2025-01-01'
            } as any;

            mockPrismaService.marea.findMany.mockResolvedValue([{ id: 'existing-id' }]);

            await expect(service.create(dto, { id: 'user-1' } as any))
                .rejects.toThrow(/ya existe/);
        });

        it('should create marea and state is initialized', async () => {
            const dto = {
                anioMarea: 2025,
                nroMarea: 2,
                tipoMarea: 'MC',
                buqueId: 'buque-1',
                pesqueriaId: 'pesq-1',
                observadorId: 'obs-1',
                fechaZarpadaEstimada: '2025-01-01'
            } as any;

            mockPrismaService.marea.findMany.mockResolvedValue([]);
            mockPrismaService.estadoMarea.findFirst.mockResolvedValue({ id: 'initial-state-id', esInicial: true });
            mockPrismaService.observador.findUnique.mockResolvedValue({ conImpedimento: false });
            mockPrismaService.marea.create.mockResolvedValue({ id: 'new-id', ...dto });

            const result = await service.create(dto, { id: 'user-1' } as any);
            expect(result).toBeDefined();
            expect(mockPrismaService.marea.create).toHaveBeenCalledWith(expect.objectContaining({
                data: expect.objectContaining({
                    estadoActualId: 'initial-state-id'
                })
            }));
        });
    });

    describe('executeAction - REGISTRAR_INICIO', () => {
        it('should create first stage automatically if it does not exist', async () => {
            const mareaId = 'marea-1';
            const marea = { id: mareaId, buqueId: 'buque-1', estadoActualId: 'designada' };
            
            mockPrismaService.marea.findUnique.mockResolvedValue(marea);
            mockPrismaService.transicionEstado.findFirst.mockResolvedValue({ estadoDestinoId: 'ejecucion', etiqueta: 'Iniciar' });
            mockPrismaService.mareaEtapa.count.mockResolvedValue(0); // No stages yet
            mockPrismaService.buque.findUnique = jest.fn().mockResolvedValue({ puertoBaseId: 'puerto-base' });

            const payload = { fechaInicioObservador: '2025-01-01T10:00:00Z' };
            await service.executeAction(mareaId, 'REGISTRAR_INICIO', { id: 'user-1' } as any, payload);

            expect(mockPrismaService.mareaEtapa.create).toHaveBeenCalledWith(expect.objectContaining({
                data: expect.objectContaining({
                    nroEtapa: 1,
                    fechaZarpada: new Date(payload.fechaInicioObservador)
                })
            }));
        });
    });
});
