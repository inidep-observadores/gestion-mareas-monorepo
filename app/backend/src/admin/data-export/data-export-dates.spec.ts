import 'reflect-metadata';
import { Test, TestingModule } from '@nestjs/testing';
import { DataExportService } from './data-export.service';
import { PrismaService } from '../../prisma/prisma.service';
import { ConfigService } from '@nestjs/config';
import { DateUtils } from '../../common/utils/date.utils';

describe('DataExportService - Normalización de Fechas', () => {
    let service: DataExportService;
    let prisma: PrismaService;

    const mockPrisma = {
        marea: {
            create: jest.fn(),
            deleteMany: jest.fn(),
            findFirst: jest.fn(),
            findMany: jest.fn(),
        },
        buque: {
            findUnique: jest.fn(),
            findFirst: jest.fn(),
            findMany: jest.fn(),
        },
        estadoMarea: { findMany: jest.fn() },
        artePesca: { findMany: jest.fn() },
        puerto: { findMany: jest.fn() },
        pesqueria: { findMany: jest.fn() },
        especie: { findMany: jest.fn() },
        observador: { findMany: jest.fn() },
        user: { findMany: jest.fn() },
        $transaction: jest.fn((cb) => cb(mockPrisma)),
    };

    const mockConfigService = {
        get: jest.fn().mockReturnValue('exports'),
    };

    beforeEach(async () => {
        const module: TestingModule = await Test.createTestingModule({
            providers: [
                DataExportService,
                { provide: PrismaService, useValue: mockPrisma },
                { provide: ConfigService, useValue: mockConfigService },
            ],
        }).compile();

        service = module.get<DataExportService>(DataExportService);
        prisma = module.get<PrismaService>(PrismaService);
        jest.clearAllMocks();
    });

    it('debería truncar la hora al importar una marea y sus etapas', async () => {
        // Mock de catálogos necesarios para la importación
        mockPrisma.buque.findMany.mockResolvedValue([{ id: 'buque-1', matricula: '1234' }]);
        mockPrisma.especie.findMany.mockResolvedValue([{ id: 'esp-1', codigo: 'ESP1' }]);
        mockPrisma.estadoMarea.findMany.mockResolvedValue([{ id: 'E1', codigo: 'INI' }]);
        mockPrisma.artePesca.findMany.mockResolvedValue([{ id: 'A1', codigoNumerico: 'A' }]);
        mockPrisma.puerto.findMany.mockResolvedValue([{ id: 'P1', codigoInterno: 'P', nombre: 'P' }]);
        mockPrisma.pesqueria.findMany.mockResolvedValue([{ id: 'Q1', codigo: 'Q' }]);
        mockPrisma.observador.findMany.mockResolvedValue([{ id: 'O1', codigoInterno: 'L1' }]);
        mockPrisma.user.findMany.mockResolvedValue([{ id: 'U1', email: 'test@test.com' }]);

        // Mock de un archivo ZIP con una marea
        const mockMareaJson = {
            anioMarea: 2025,
            nroMarea: 123,
            buqueMatricula: '1234',
            fechaZarpadaEstimada: '2025-05-10T15:00:00Z',
            fechaInicioObservador: '2025-05-11T10:30:00Z',
            etapas: [
                {
                    nroEtapa: 1,
                    fechaZarpada: '2025-05-12T08:00:00Z',
                    fechaArribo: '2025-05-20T20:45:00Z'
                }
            ]
        };

        const mockZip = {
            readAsText: jest.fn().mockReturnValue(JSON.stringify(mockMareaJson) + '\n'),
            getEntry: jest.fn().mockReturnValue(true)
        } as any;

        // Invocamos el método interno de importación de mareas (mockeando el flujo del ZIP)
        await (service as any).importMareas(mockZip);

        expect(mockPrisma.marea.create).toHaveBeenCalledWith(expect.objectContaining({
            data: expect.objectContaining({
                fechaZarpadaEstimada: DateUtils.truncateTime('2025-05-10T15:00:00Z'),
                fechaInicioObservador: DateUtils.truncateTime('2025-05-11T10:30:00Z'),
                etapas: expect.objectContaining({
                    create: expect.arrayContaining([
                        expect.objectContaining({
                            fechaZarpada: DateUtils.truncateTime('2025-05-12T08:00:00Z'),
                            fechaArribo: DateUtils.truncateTime('2025-05-20T20:45:00Z'),
                        })
                    ])
                })
            })
        }));
    });
});
