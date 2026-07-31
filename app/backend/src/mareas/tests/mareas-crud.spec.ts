import { Test, TestingModule } from '@nestjs/testing';
import { MareasService } from '../mareas.service';
import { PrismaService } from '../../prisma/prisma.service';
import { MailService } from '../../mail/mail.service';
import { AlertsService } from '../../alerts/alerts.service';
import { BusinessRulesService } from '../../common/business-rules/business-rules.service';
import { ConfigService } from '@nestjs/config';
import { TipoEtapa, MareaEstado } from '../mareas.constants';

describe('MareasService (CRUD)', () => {
    let service: MareasService;

    const mockMarea = {
        id: 'm-id',
        estadoActual: { codigo: MareaEstado.DESIGNADA, nombre: 'Designada' },
        etapas: []
    };

    const mockPrisma = {
        marea: {
            findUnique: jest.fn().mockResolvedValue(mockMarea),
            update: jest.fn().mockResolvedValue(mockMarea),
            count: jest.fn().mockResolvedValue(0),
        },
        mareaEtapa: {
            deleteMany: jest.fn().mockResolvedValue({ count: 0 }),
            findFirst: jest.fn().mockImplementation((args) => {
                // If searching by ID, return the stage
                if (args?.where?.id) {
                    return Promise.resolve({ id: args.where.id });
                }
                return Promise.resolve(null);
            }),
            findMany: jest.fn().mockResolvedValue([{ id: 'existing-id', fechaZarpada: new Date('2024-01-01T10:00:00Z'), fechaArribo: new Date('2024-01-08T10:00:00Z') }]),
            create: jest.fn().mockResolvedValue({ id: 'new-e-id' }),
            update: jest.fn().mockResolvedValue({ id: 'existing-e-id' }),
            count: jest.fn().mockResolvedValue(0),
        },
        mareaEtapaObservador: {
            deleteMany: jest.fn().mockResolvedValue({ count: 0 }),
            create: jest.fn().mockResolvedValue({}),
        },
        observador: {
            findUnique: jest.fn().mockResolvedValue({}),
        },
        $transaction: jest.fn((cb) => cb(mockPrisma)),
    };

    beforeEach(async () => {
        const module: TestingModule = await Test.createTestingModule({
            providers: [
                MareasService,
                { provide: PrismaService, useValue: mockPrisma },
                { provide: MailService, useValue: {} },
                { provide: AlertsService, useValue: {} },
                { provide: BusinessRulesService, useValue: { validate: () => ({ success: true }), rules: () => ({}) } },
                { provide: ConfigService, useValue: { get: () => 14 } },
            ],
        }).compile();
        service = module.get<MareasService>(MareasService);
        jest.clearAllMocks();
    });

    it('should complete full lifecycle (update existing stage and create new one)', async () => {
        const payload = {
            etapas: [
                { id: 'existing-id', nroEtapa: 1, puertoZarpadaId: 'p1', puertoArriboId: 'p2', fechaZarpada: '2024-01-01T10:00:00Z', fechaArribo: '2024-01-08T10:00:00Z', tipoEtapa: TipoEtapa.EC },
                { nroEtapa: 2, puertoZarpadaId: 'p2', fechaZarpada: '2024-01-10T10:00:00Z', tipoEtapa: TipoEtapa.EC }
            ]
        };

        await service.update('m-id', payload as any);

        expect(mockPrisma.mareaEtapa.deleteMany).toHaveBeenCalled();
        expect(mockPrisma.mareaEtapa.update).toHaveBeenCalledWith(expect.objectContaining({ where: { id: 'existing-id' } }));
        expect(mockPrisma.mareaEtapa.create).toHaveBeenCalled();
    });

    it('should skip stage sync if stages field is missing', async () => {
        await service.update('m-id', { pesqueriaId: 'p1' } as any);
        expect(mockPrisma.mareaEtapa.deleteMany).not.toHaveBeenCalled();
    });
});
