import 'reflect-metadata';
import { Test, TestingModule } from '@nestjs/testing';
import { MareasService } from './mareas.service';
import { PrismaService } from '../prisma/prisma.service';
import { BusinessRulesService } from '../common/business-rules/business-rules.service';
import { MailService } from '../mail/mail.service';
import { AlertsService } from '../alerts/alerts.service';
import { ConfigService } from '@nestjs/config';
import { BadRequestException, NotFoundException } from '@nestjs/common';
import { MareaEstado, TipoEtapa } from './mareas.constants';

describe('MareasService', () => {
    let service: MareasService;
    let prisma: PrismaService;

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
            update: jest.fn(),
            create: jest.fn(),
            deleteMany: jest.fn(),
            count: jest.fn(),
            findMany: jest.fn(),
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
                fechaRecepcion: '2025-01-09T00:00:00Z',
                fechaInicioObservador: '2025-01-01T00:00:00Z',
                fechaFinObservador: '2025-01-10T00:00:00Z'
            };

            await expect(service.executeAction(mareaId, 'RECIBIR_DATOS', { id: 'user-id' } as any, payload))
                .rejects.toThrow();
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

            const payload = {
                fechaRecepcion: '2025-01-15T00:00:00Z',
                fechaInicioObservador: '2025-01-03T00:00:00Z',
                fechaFinObservador: '2025-01-10T00:00:00Z'
            };

            await expect(service.executeAction(mareaId, 'RECIBIR_DATOS', { id: 'user-id' } as any, payload))
                .rejects.toThrow();
        });
    });

    describe('checkVesselAvailability', () => {
        it('should return available: true if no designated marea exists', async () => {
            mockPrismaService.marea.findFirst.mockResolvedValue(null);
            const result = await service.checkVesselAvailability('buque-1');
            expect(result.available).toBe(true);
            expect(result.marea).toBeNull();
        });

        it('should return available: false if designated marea exists', async () => {
            mockPrismaService.marea.findFirst.mockResolvedValue({
                nroMarea: 123, anioMarea: 25, tipoMarea: 'MC'
            });
            const result = await service.checkVesselAvailability('buque-1');
            expect(result.available).toBe(false);
            expect(result.marea).toBe('MC-123-25');
        });
    });

    describe('checkObserverAvailability', () => {
        it('should return available: true if no designated marea exists', async () => {
            mockPrismaService.marea.findFirst.mockResolvedValue(null);
            const result = await service.checkObserverAvailability('obs-1');
            expect(result.available).toBe(true);
            expect(result.marea).toBeNull();
        });

        it('should return available: false if designated marea exists', async () => {
            mockPrismaService.marea.findFirst.mockResolvedValue({
                nroMarea: 456, anioMarea: 25, tipoMarea: 'CI'
            });
            const result = await service.checkObserverAvailability('obs-1');
            expect(result.available).toBe(false);
            expect(result.marea).toBe('CI-456-25');
        });
    });

    describe('create (Uniqueness and Business Rules)', () => {
        it('should throw BadRequestException if marea already exists with correct message', async () => {
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
                .rejects.toThrow(BadRequestException);
            await expect(service.create(dto, { id: 'user-1' } as any))
                .rejects.toThrow('La marea MC-1-2025 ya está registrada en el sistema.');
        });

        it('should throw BadRequestException if year of zarpada is invalid', async () => {
            const dto = {
                anioMarea: 2025,
                nroMarea: 1,
                tipoMarea: 'MC',
                buqueId: 'buque-1',
                fechaZarpadaEstimada: '2024-12-31' // Invalid year
            } as any;

            mockPrismaService.marea.findMany.mockResolvedValue([]);
            mockPrismaService.estadoMarea.findFirst.mockResolvedValue({ id: 'init' });

            await expect(service.create(dto, { id: 'user-1' } as any))
                .rejects.toThrow(/El año de zarpada estimada/);
        });

        it('should throw BadRequestException if vessel already has a designated marea', async () => {
            const dto = {
                anioMarea: 2025,
                nroMarea: 2,
                tipoMarea: 'MC',
                buqueId: 'buque-occupied',
                fechaZarpadaEstimada: '2025-01-01'
            } as any;

            mockPrismaService.marea.findMany.mockResolvedValue([]);
            mockPrismaService.estadoMarea.findFirst.mockResolvedValue({ id: 'init' });
            // Mocking the check inside create
            mockPrismaService.marea.findFirst.mockResolvedValue({ nroMarea: 1, anioMarea: 25, tipoMarea: 'MC' });

            await expect(service.create(dto, { id: 'user-1' } as any))
                .rejects.toThrow(/El buque ya tiene una marea designada/);
        });

        it('should throw BadRequestException if observer already has a designated marea', async () => {
            const dto = {
                anioMarea: 2025,
                nroMarea: 2,
                tipoMarea: 'MC',
                buqueId: 'buque-1',
                observadorId: 'obs-occupied',
                fechaZarpadaEstimada: '2025-01-01'
            } as any;

            mockPrismaService.marea.findMany.mockResolvedValue([]);
            mockPrismaService.estadoMarea.findFirst.mockResolvedValue({ id: 'init' });
            // Success call for vessel
            mockPrismaService.marea.findFirst
                .mockResolvedValueOnce(null) // Vessel check
                .mockResolvedValueOnce({ nroMarea: 7, anioMarea: 25, tipoMarea: 'MC' }); // Observer check

            await expect(service.create(dto, { id: 'user-1' } as any))
                .rejects.toThrow(/El observador ya está designado en otra marea/);
        });

        it('should create marea if everything is valid', async () => {
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
            mockPrismaService.marea.findFirst.mockResolvedValue(null); // Both checks return null
            mockPrismaService.observador.findUnique.mockResolvedValue({ conImpedimento: false });
            mockPrismaService.marea.create.mockResolvedValue({ id: 'new-id', ...dto });

            const result = await service.create(dto, { id: 'user-1' } as any);
            expect(result).toBeDefined();
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

            // La fecha en el payload será truncada por el servicio
            const expectedDate = new Date(payload.fechaInicioObservador);

            await service.executeAction(mareaId, 'REGISTRAR_INICIO', { id: 'user-1' } as any, payload);

            expect(mockPrismaService.mareaEtapa.create).toHaveBeenCalledWith(expect.objectContaining({
                data: expect.objectContaining({
                    nroEtapa: 1,
                    fechaZarpada: expectedDate
                })
            }));
        });
    });
    describe('update (Business Rules and Blinking)', () => {
        const mareaId = 'marea-uuid';

        it('should allow clearing optional fields by sending null', async () => {
            mockPrismaService.marea.findUnique.mockResolvedValue({ id: mareaId, etapas: [] });

            const dto = {
                diasZonaAustral: null,
                observaciones: null,
                nroProtocolizacion: null,
                anioProtocolizacion: null,
                fechaProtocolizacion: null
            };

            await service.update(mareaId, dto as any);

            expect(mockPrismaService.marea.update).toHaveBeenCalledWith(expect.objectContaining({
                where: { id: mareaId },
                data: expect.objectContaining({
                    diasZonaAustral: null,
                    observaciones: null,
                    nroProtocolizacion: null,
                    anioProtocolizacion: null,
                    fechaProtocolizacion: null
                })
            }));
        });

        it('should throw error if fechaFinObservador is provided without fechaInicioObservador (and not in DB)', async () => {
            mockPrismaService.marea.findUnique.mockResolvedValue({ id: mareaId, fechaInicioObservador: null, etapas: [] });

            const dto = { fechaFinObservador: '2025-01-10T00:00:00Z' };

            await expect(service.update(mareaId, dto as any))
                .rejects.toThrow('Si se especifica la fecha de fin del observador, la fecha de inicio es obligatoria.');
        });

        it('should throw error if fechaInicioObservador is after fechaFinObservador', async () => {
            mockPrismaService.marea.findUnique.mockResolvedValue({ id: mareaId, etapas: [] });

            const dto = {
                fechaInicioObservador: '2025-01-11T00:00:00Z',
                fechaFinObservador: '2025-01-10T00:00:00Z'
            };

            await expect(service.update(mareaId, dto as any))
                .rejects.toThrow('La fecha de inicio del observador no puede ser posterior a la de fin.');
        });

        it('should throw error if fechaFinObservador is provided but there are open stages in DTO', async () => {
            mockPrismaService.marea.findUnique.mockResolvedValue({ id: mareaId, fechaInicioObservador: '2025-01-01', etapas: [], estadoActual: { codigo: 'MC', nombre: 'Navegando' } });

            const dto = {
                fechaFinObservador: '2025-01-10T00:00:00Z',
                etapas: [
                    { id: 'etapa-1', fechaZarpada: '2025-01-01', fechaArribo: null }
                ]
            };

            await expect(service.update(mareaId, dto as any))
                .rejects.toThrow('No se puede establecer la fecha de fin del observador si existen etapas sin fecha de arribo.');
        });

        it('should throw error if fechaFinObservador is provided but there are open stages in DB', async () => {
            mockPrismaService.marea.findUnique.mockResolvedValue({ id: mareaId, fechaInicioObservador: '2025-01-01', etapas: [], estadoActual: { codigo: 'MC', nombre: 'Navegando' } });
            mockPrismaService.mareaEtapa.count.mockResolvedValue(1);

            const dto = { fechaFinObservador: '2025-01-10T00:00:00Z' };

            await expect(service.update(mareaId, dto as any))
                .rejects.toThrow('No se puede establecer la fecha de fin del observador si existen etapas sin fecha de arribo.');
        });

        it('should throw error if protocolization fields are inconsistent (some null, some defined)', async () => {
            mockPrismaService.marea.findUnique.mockResolvedValue({ id: mareaId, etapas: [] });

            const dto = {
                nroProtocolizacion: 123,
                anioProtocolizacion: 2024
                // fechaProtocolizacion is missing/undefined
            };

            await expect(service.update(mareaId, dto as any))
                .rejects.toThrow('Los campos de protocolización (número, año y fecha) deben completarse todos juntos o permanecer todos vacíos.');
        });

        it('should throw error if protocolization fields are partially cleared (some null, some defined)', async () => {
            mockPrismaService.marea.findUnique.mockResolvedValue({ id: mareaId, etapas: [] });

            const dto = {
                nroProtocolizacion: null,
                anioProtocolizacion: 2024,
                fechaProtocolizacion: '2025-01-01'
            };

            await expect(service.update(mareaId, dto as any))
                .rejects.toThrow('Los campos de protocolización (número, año y fecha) deben completarse todos juntos o permanecer todos vacíos.');
        });

        it('should pass if all protocolization fields are null', async () => {
            mockPrismaService.marea.findUnique.mockResolvedValue({ id: mareaId, etapas: [] });

            const dto = {
                nroProtocolizacion: null,
                anioProtocolizacion: null,
                fechaProtocolizacion: null
            };

            const result = await service.update(mareaId, dto as any);
            expect(result).toBeDefined();
        });

        it('should throw error if stage zarpada fields are incomplete', async () => {
            mockPrismaService.marea.findUnique.mockResolvedValue({ id: mareaId, etapas: [] });

            const dto = {
                etapas: [
                    { id: 'e1', puertoZarpadaId: 'p1' } // Missing fechaZarpada
                ]
            };

            await expect(service.update(mareaId, dto as any))
                .rejects.toThrow(/zarpada son obligatorios/);
        });

        it('should throw error if stage arribo fields are inconsistent (fecha present, puerto missing)', async () => {
            mockPrismaService.marea.findUnique.mockResolvedValue({ id: mareaId, etapas: [] });

            const dto = {
                etapas: [
                    { id: 'e1', fechaZarpada: '2025-01-01', puertoZarpadaId: 'p1', fechaArribo: '2025-01-05' } // Missing puertoArribo
                ]
            };

            await expect(service.update(mareaId, dto as any))
                .rejects.toThrow(/arribo deben completarse juntos/);
        });

        it('should throw error if stage arribo fields are inconsistent (puerto present, fecha missing)', async () => {
            mockPrismaService.marea.findUnique.mockResolvedValue({ id: mareaId, etapas: [] });

            const dto = {
                etapas: [
                    { id: 'e1', fechaZarpada: '2025-01-01', puertoZarpadaId: 'p1', puertoArriboId: 'p2' } // Missing fechaArribo
                ]
            };

            await expect(service.update(mareaId, dto as any))
                .rejects.toThrow(/arribo deben completarse juntos/);
        });
    });

    describe('getRecentMovements', () => {
        const { DateUtils } = require('../common/utils/date.utils');

        it('should calculate limitDate based on DateUtils.getNow', async () => {
            const days = 7;
            const fixedNow = new Date('2024-06-15T10:00:00Z');

            const getNowSpy = jest.spyOn(DateUtils, 'getNow').mockReturnValue(fixedNow);

            mockPrismaService.mareaEtapa.findMany.mockResolvedValue([]);

            await service.getRecentMovements(days);

            expect(getNowSpy).toHaveBeenCalled();

            getNowSpy.mockRestore();
        });
        describe('getMareaContext', () => {
            it('should enrich actions with toStateName and requiresNotes', async () => {
                const mareaId = 'marea-1';
                const estadoOrigenId = 'estado-origin-id';
                const mockMarea = {
                    id: mareaId,
                    id_marea: 'MC-100-24',
                    estadoActualId: estadoOrigenId,
                    buque: { nombre: 'Ship' },
                    estadoActual: { nombre: 'Designada' },
                    etapas: [],
                    alertas: [],
                    movimientos: []
                };

                mockPrismaService.marea.findUnique.mockResolvedValue(mockMarea);
                mockPrismaService.transicionEstado.findMany.mockResolvedValue([
                    {
                        accion: 'REGISTRAR_INICIO',
                        etiqueta: 'Iniciar Marea',
                        estadoOrigenId: estadoOrigenId,
                        estadoDestinoId: 'dest-1',
                        requiereObs: true,
                        claseBoton: 'btn-primary',
                        estadoDestino: { nombre: 'En Ejecución' }
                    },
                    {
                        accion: 'OTRA_ACCION',
                        etiqueta: 'Otra',
                        estadoOrigenId: estadoOrigenId,
                        estadoDestinoId: 'dest-2',
                        requiereObs: false,
                        claseBoton: 'btn-secondary',
                        estadoDestino: { nombre: 'Otro Estado' }
                    }
                ]);
                mockPrismaService.alerta.findMany.mockResolvedValue([]);

                const result = await service.getMareaContext(mareaId);

                expect(result.actions['REGISTRAR_INICIO']).toMatchObject({
                    toStateName: 'En Ejecución',
                    requiresNotes: true
                });
                expect(result.actions['OTRA_ACCION']).toMatchObject({
                    toStateName: 'Otro Estado',
                    requiresNotes: false
                });
            });
        });
    });
});
