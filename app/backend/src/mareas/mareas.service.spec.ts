import 'reflect-metadata';
import { Test, TestingModule } from '@nestjs/testing';
import { MareasService } from './mareas.service';
import { PrismaService } from '../prisma/prisma.service';
import { BusinessRulesService } from '../common/business-rules/business-rules.service';
import { MailService } from '../mail/mail.service';
import { AlertsService } from '../alerts/alerts.service';
import { ConfigService } from '@nestjs/config';
import { BadRequestException, NotFoundException } from '@nestjs/common';
import { TipoEtapa } from './mareas.constants';

describe('MareasService', () => {
    let service: MareasService;
    let prisma: PrismaService;
    let mockPrismaService: any;

    const createMockPrisma = () => ({
        marea: {
            findUnique: jest.fn(),
            findMany: jest.fn(),
            findFirst: jest.fn(),
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
            findUnique: jest.fn(),
            update: jest.fn(),
            create: jest.fn(),
            deleteMany: jest.fn(),
            count: jest.fn(),
            findMany: jest.fn().mockResolvedValue([]),
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
        alerta: {
            findMany: jest.fn(),
        },
        $transaction: jest.fn((cb) => cb(mockPrismaService)),
    });

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
                { provide: ConfigService, useValue: { get: jest.fn() } },
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
                    fechaArribo: '2025-01-09T10:00:00Z',
                }
            ];
            expect(() => (service as any).validateStagesChronology(stages))
                .toThrow(/arribo no puede ser anterior a la de zarpada/);
        });

        it('should throw error if stage 2 departure is before stage 1 arrival', () => {
            const stages = [
                { nroEtapa: 1, fechaZarpada: '2025-01-01T10:00:00Z', fechaArribo: '2025-01-05T10:00:00Z' },
                { nroEtapa: 2, fechaZarpada: '2025-01-04T10:00:00Z', fechaArribo: '2025-01-10T10:00:00Z' }
            ];
            expect(() => (service as any).validateStagesChronology(stages))
                .toThrow(/fecha de zarpada no puede ser anterior al arribo de la etapa anterior/);
        });

        it('should pass if dates are equal (limit case)', () => {
            const stages = [
                { nroEtapa: 1, fechaZarpada: '2025-01-01T10:00:00Z', fechaArribo: '2025-01-05T10:00:00Z' },
                { nroEtapa: 2, fechaZarpada: '2025-01-05T10:00:00Z', fechaArribo: '2025-01-10T10:00:00Z' }
            ];
            expect(() => (service as any).validateStagesChronology(stages)).not.toThrow();
        });
    });

    describe('update (Designation fields restriction)', () => {
        const mareaId = 'marea-uuid';
        const estadoDesignada = { id: 'est-des', codigo: 'DESIGNADA', nombre: 'Designada' };
        const estadoEjecucion = { id: 'est-eje', codigo: 'EN_EJECUCION', nombre: 'En Ejecución' };

        it('should allow modifying anioMarea if state is DESIGNADA', async () => {
            mockPrismaService.marea.findUnique.mockResolvedValue({ 
                id: mareaId, 
                anioMarea: 2024, 
                estadoActual: estadoDesignada 
            });
            const dto = { anioMarea: 2025 };
            await service.update(mareaId, dto as any, { id: 'user-id' } as any);
            expect(mockPrismaService.marea.update).toHaveBeenCalled();
        });

        it('should throw BadRequestException if modifying anioMarea and state is NOT DESIGNADA', async () => {
            mockPrismaService.marea.findUnique.mockResolvedValue({ 
                id: mareaId, 
                anioMarea: 2024, 
                estadoActual: estadoEjecucion 
            });
            const dto = { anioMarea: 2025 };
            await expect(service.update(mareaId, dto as any, { id: 'user-id' } as any))
                .rejects.toThrow(/Solo se puede modificar el número, año y tipo de marea/);
        });

        it('should throw BadRequestException if modifying nroMarea and state is NOT DESIGNADA', async () => {
            mockPrismaService.marea.findUnique.mockResolvedValue({ 
                id: mareaId, 
                nroMarea: 100, 
                estadoActual: estadoEjecucion 
            });
            const dto = { nroMarea: 101 };
            await expect(service.update(mareaId, dto as any, { id: 'user-id' } as any))
                .rejects.toThrow(/Solo se puede modificar el número, año y tipo de marea/);
        });

        it('should throw BadRequestException if modifying tipoMarea and state is NOT DESIGNADA', async () => {
            mockPrismaService.marea.findUnique.mockResolvedValue({ 
                id: mareaId, 
                tipoMarea: 'MC', 
                estadoActual: estadoEjecucion 
            });
            const dto = { tipoMarea: 'CI' };
            await expect(service.update(mareaId, dto as any, { id: 'user-id' } as any))
                .rejects.toThrow(/Solo se puede modificar el número, año y tipo de marea/);
        });
    });

    describe('update (Impediment check)', () => {
        it('should throw BadRequestException if assigning an observer with impediment', async () => {
            const mareaId = 'marea-uuid';
            const observerId = 'obs-uuid';
            mockPrismaService.marea.findUnique.mockResolvedValue({ 
                id: mareaId,
                observadorPrincipalId: 'old-obs',
                estadoActual: { codigo: 'DESIGNADA' } 
            });
            mockPrismaService.observador.findUnique.mockResolvedValue({ conImpedimento: true, motivoImpedimento: 'Licencia medica' });
            await expect(service.update(mareaId, { observadorId: observerId } as any, { id: 'user-id' } as any)).rejects.toThrow(/No se puede asignar el observador porque posee un impedimento/);
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
                etapas: [{ nroEtapa: 1, fechaZarpada: new Date('2025-01-01'), fechaArribo: new Date('2025-01-10') }]
            };
            mockPrismaService.marea.findUnique.mockResolvedValue(marea);
            mockPrismaService.transicionEstado.findFirst.mockResolvedValue({ estadoDestinoId: 'estado-received', etiqueta: 'Recibir' });
            const payload = { fechaRecepcion: '2025-01-09T00:00:00Z', fechaInicioObservador: '2025-01-01T00:00:00Z', fechaFinObservador: '2025-01-10T00:00:00Z' };
            await expect(service.executeAction(mareaId, 'RECIBIR_DATOS', { id: 'user-id' } as any, payload)).rejects.toThrow();
        });
    });

    describe('checkVesselAvailability', () => {
        it('should return available: true if no designated marea exists', async () => {
            mockPrismaService.marea.findFirst.mockResolvedValue(null);
            const result = await service.checkVesselAvailability('buque-1');
            expect(result.available).toBe(true);
        });
    });

    describe('create (Business Rules)', () => {
        it('should throw BadRequestException if marea already exists', async () => {
            mockPrismaService.marea.findMany.mockResolvedValue([{ id: 'existing-id' }]);
            await expect(service.create({ anioMarea: 2025, nroMarea: 1, tipoMarea: 'MC' } as any, { id: 'user-1' } as any)).rejects.toThrow(/ya está registrada/);
        });
    });

    describe('Fuentes Persistence', () => {
        const mareaId = 'marea-uuid';
        const etapaId = 'etapa-uuid';

        it('syncStages should preserve existing fuentes if they are not in the payload', async () => {
            const incomingStages = [{
                id: etapaId,
                nroEtapa: 1,
                puertoZarpadaId: 'p1',
                fechaZarpada: '2025-01-01',
                pesqueriaId: 'pesq-1'
            }];

            await (service as any).syncStages(mockPrismaService, mareaId, incomingStages);

            expect(mockPrismaService.mareaEtapa.update).toHaveBeenCalledWith(expect.objectContaining({
                where: { id: etapaId },
                data: expect.objectContaining({
                    fuentesZarpada: undefined,
                    fuentesArribo: undefined
                })
            }));
        });

        it('update should protect existing fuentes in stages', async () => {
            const existingEtapa = { id: etapaId, mareaId: mareaId, fuentesZarpada: { sources: ['PNA'] } };
            mockPrismaService.marea.findUnique.mockResolvedValue({ 
                id: mareaId, 
                etapas: [], 
                estadoActual: { codigo: 'DESIGNADA' } 
            });
            mockPrismaService.mareaEtapa.findFirst.mockResolvedValue(existingEtapa);

            const dto = { etapas: [{ id: etapaId, puertoZarpadaId: 'p2', fechaZarpada: '2025-01-02' }] };
            await service.update(mareaId, dto as any, { id: 'user-id' } as any);

            expect(mockPrismaService.mareaEtapa.update).toHaveBeenCalledWith(expect.objectContaining({
                where: { id: etapaId },
                data: expect.not.objectContaining({ fuentesZarpada: null })
            }));
        });
    });

    describe('Intención de Cierre de Marea', () => {
        const mareaId = 'm-1';
        const etapaId = 'e-1';

        it('should throw error if attempting to set intention on a marea not in execution', async () => {
            mockPrismaService.marea.findUnique.mockResolvedValue({
                id: mareaId,
                estadoActual: { codigo: 'PROTOCOLIZADA', nombre: 'Protocolizada' },
                etapas: [{ id: etapaId }]
            });
            await expect(service.setIntencionCierreMarea(mareaId, etapaId, true, { id: 'user' } as any))
                .rejects.toThrow(/marea no está en ejecución/);
        });

        it('should activate intention if valid', async () => {
            const mockMarea = {
                id: mareaId,
                estadoActual: { codigo: 'EN_EJECUCION' },
                etapas: [{ id: etapaId, metadata: {} }]
            };
            mockPrismaService.marea.findUnique.mockResolvedValue(mockMarea);
            mockPrismaService.marea.findFirst.mockResolvedValue(null); // No tiene designacion pendiente

            const result = await service.setIntencionCierreMarea(mareaId, etapaId, true, { id: 'user' } as any);
            expect(result.success).toBe(true);
            expect(result.metadata.opcionesCierre.finalizarMareaAlArribo).toBe(true);
            expect(mockPrismaService.mareaEtapa.update).toHaveBeenCalled();
            expect(mockPrismaService.mareaMovimiento.create).toHaveBeenCalled();
        });

        it('debeFinalizarMareaAlArribar should return true if metadata flag is true', async () => {
            mockPrismaService.marea.findUnique.mockResolvedValue({ buqueId: 'b-1' });
            mockPrismaService.mareaEtapa.findUnique.mockResolvedValue({
                id: etapaId,
                metadata: { opcionesCierre: { finalizarMareaAlArribo: true } }
            });
            mockPrismaService.marea.findFirst.mockResolvedValue(null);

            const result = await (service as any).evaluarCierreAlArribar(mareaId, etapaId);
            expect(result).toBe('RECOMENDADO_POR_INTENCION');
        });

        it('debeFinalizarMareaAlArribar should return true if a designation is pending', async () => {
            mockPrismaService.marea.findUnique.mockResolvedValue({ buqueId: 'b-1' });
            mockPrismaService.mareaEtapa.findUnique.mockResolvedValue({
                id: etapaId,
                metadata: { opcionesCierre: { finalizarMareaAlArribo: false } }
            });
            mockPrismaService.marea.findFirst.mockResolvedValue({ id: 'designated-marea-1' });

            const result = await (service as any).evaluarCierreAlArribar(mareaId, etapaId);
            expect(result).toBe('FORZADO_POR_DESIGNACION');
        });
    });
});
