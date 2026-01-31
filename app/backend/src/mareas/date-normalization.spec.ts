import 'reflect-metadata';
import { Test, TestingModule } from '@nestjs/testing';
import { MareasService } from './mareas.service';
import { PrismaService } from '../prisma/prisma.service';
import { BusinessRulesService } from '../common/business-rules/business-rules.service';
import { MailService } from '../mail/mail.service';
import { AlertsService } from '../alerts/alerts.service';
import { TipoMarea, TipoEtapa } from './mareas.constants';
import { DateUtils } from '../common/utils/date.utils';

describe('Mareas - Normalización de Fechas', () => {
    let service: MareasService;
    let prisma: PrismaService;

    const mockPrisma = {
        marea: {
            create: jest.fn(),
            update: jest.fn(),
            findUnique: jest.fn(),
            findMany: jest.fn(),
            count: jest.fn(),
        },
        mareaEtapa: {
            create: jest.fn(),
            update: jest.fn(),
            deleteMany: jest.fn(),
            count: jest.fn(),
            findFirst: jest.fn(),
        },
        mareaMovimiento: {
            create: jest.fn(),
        },
        estadoMarea: {
            findFirst: jest.fn().mockResolvedValue({ id: 'INI', nombre: 'INICIAL' }),
        },
        transicionEstado: {
            findFirst: jest.fn(),
        },
        buque: {
            findUnique: jest.fn(),
        },
        observador: {
            findUnique: jest.fn(),
        },
        $transaction: jest.fn((cb) => cb(mockPrisma)),
    };

    const mockBusinessRulesService = {
        getRules: jest.fn().mockReturnValue({}),
    };

    beforeEach(async () => {
        const module: TestingModule = await Test.createTestingModule({
            providers: [
                MareasService,
                { provide: PrismaService, useValue: mockPrisma },
                { provide: BusinessRulesService, useValue: mockBusinessRulesService },
                { provide: MailService, useValue: {} },
                { provide: AlertsService, useValue: {} },
            ],
        }).compile();

        service = module.get<MareasService>(MareasService);
        prisma = module.get<PrismaService>(PrismaService);
        jest.clearAllMocks();

        // Mock base para findUnique (usado por findOne)
        mockPrisma.marea.findUnique.mockResolvedValue({
            id: 'marea-id',
            anioMarea: 2025,
            nroMarea: 1,
            tipoMarea: TipoMarea.MC,
            etapas: [],
            observaciones: ''
        });
    });

    it('debería truncar la hora al crear una marea', async () => {
        const user = { id: 'user-1', fullName: 'Tester' } as any;
        const dto = {
            anioMarea: 2025,
            nroMarea: 1,
            buqueId: 'buque-1',
            fechaZarpadaEstimada: '2025-01-28T15:30:00Z',
            fechaInicioObservador: '2025-01-29T08:45:00Z',
            tipoMarea: TipoMarea.MC
        } as any;

        mockPrisma.marea.findMany.mockResolvedValue([]);
        mockPrisma.marea.create.mockResolvedValue({ id: 'marea-1', ...dto });

        await service.create(dto, user);

        expect(mockPrisma.marea.create).toHaveBeenCalledWith(expect.objectContaining({
            data: expect.objectContaining({
                fechaZarpadaEstimada: new Date('2025-01-28T15:30:00Z'),
                fechaInicioObservador: new Date('2025-01-29T08:45:00Z'),
            })
        }));
    });

    it('debería truncar la hora al actualizar una marea', async () => {
        const id = 'marea-1';
        const dto = {
            fechaProtocolizacion: '2025-02-15T12:00:00Z',
            fechaFinObservador: '2025-02-10T23:59:59Z'
        } as any;

        // No necesitamos mockResolvedValueOnce porque el mock base de findUnique ya devuelve etapas: []
        await service.update(id, dto);

        expect(mockPrisma.marea.update).toHaveBeenCalledWith(expect.objectContaining({
            where: { id },
            data: expect.objectContaining({
                fechaProtocolizacion: new Date('2025-02-15T12:00:00Z'),
                fechaFinObservador: new Date('2025-02-10T23:59:59Z'),
            })
        }));
    });

    it('debería truncar la hora al sincronizar etapas', async () => {
        const mareaId = 'marea-1';
        const stages = [
            {
                fechaZarpada: '2025-01-01T10:00:00Z',
                fechaArribo: '2025-01-05T18:00:00Z',
                puertoZarpadaId: 'p-1',
                puertoArriboId: 'p-2'
            }
        ];

        await service.syncStages(mockPrisma, mareaId, stages);

        expect(mockPrisma.mareaEtapa.create).toHaveBeenCalledWith(expect.objectContaining({
            data: expect.objectContaining({
                fechaZarpada: new Date('2025-01-01T10:00:00Z'),
                fechaArribo: new Date('2025-01-05T18:00:00Z'),
            })
        }));
    });

    it('debería truncar la hora al REGISTRAR_INICIO', async () => {
        const mareaId = 'marea-1';
        const user = { id: 'u-1' } as any;
        const payload = { fechaInicioObservador: '2025-01-10T14:20:00Z' };

        // mockResolvedValueOnce para la carga inicial de executeAction
        mockPrisma.marea.findUnique.mockResolvedValueOnce({
            id: mareaId,
            estadoActualId: 'E1',
            estadoActual: { nombre: 'INI' },
            buqueId: 'b-1',
            etapas: []
        });

        mockPrisma.transicionEstado.findFirst.mockResolvedValue({ estadoDestinoId: 'E2' });
        mockPrisma.mareaEtapa.count.mockResolvedValue(0);
        mockPrisma.buque.findUnique.mockResolvedValue({ puertoBaseId: 'p-1' });

        await service.executeAction(mareaId, 'REGISTRAR_INICIO', user, payload);

        expect(mockPrisma.marea.update).toHaveBeenCalledWith(expect.objectContaining({
            data: expect.objectContaining({
                fechaInicioObservador: new Date('2025-01-10T14:20:00Z')
            })
        }));

        expect(mockPrisma.mareaEtapa.create).toHaveBeenCalledWith(expect.objectContaining({
            data: expect.objectContaining({
                fechaZarpada: new Date('2025-01-10T14:20:00Z')
            })
        }));
    });

    it('debería truncar la hora al RECIBIR_DATOS', async () => {
        const mareaId = 'marea-1';
        const user = { id: 'u-1' } as any;
        const payload = {
            fechaRecepcion: '2025-03-01T10:00:00Z',
            fechaInicioObservador: '2025-01-01T08:00:00Z',
            fechaFinObservador: '2025-02-01T20:00:00Z'
        };

        mockPrisma.marea.findUnique.mockResolvedValueOnce({
            id: mareaId,
            estadoActualId: 'E2',
            estadoActual: { nombre: 'EJEC' },
            etapas: []
        });
        mockPrisma.transicionEstado.findFirst.mockResolvedValue({ estadoDestinoId: 'E3' });

        await service.executeAction(mareaId, 'RECIBIR_DATOS', user, payload);

        expect(mockPrisma.marea.update).toHaveBeenCalledWith(expect.objectContaining({
            data: expect.objectContaining({
                fechaInicioObservador: new Date('2025-01-01T08:00:00Z'),
                fechaFinObservador: new Date('2025-02-01T20:00:00Z')
            })
        }));
    });
});

