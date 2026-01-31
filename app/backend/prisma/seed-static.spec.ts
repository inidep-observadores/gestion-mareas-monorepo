import { DataLoader, LOAD_ORDER } from './seed-static';
import * as fs from 'fs';
import * as path from 'path';

jest.mock('fs');
jest.mock('@prisma/adapter-pg', () => {
    return {
        PrismaPg: jest.fn().mockImplementation(() => ({})),
    };
});
jest.mock('pg', () => {
    return {
        Pool: jest.fn().mockImplementation(() => ({
            connect: jest.fn(),
            query: jest.fn(),
            end: jest.fn(),
        })),
    };
});

describe('DataLoader', () => {
    let mockPrisma: any;
    let loader: DataLoader;

    beforeEach(() => {
        mockPrisma = {
            user: {
                deleteMany: jest.fn().mockResolvedValue({ count: 1 }),
                createMany: jest.fn().mockResolvedValue({ count: 1 }),
                create: jest.fn().mockResolvedValue({ id: 1 }),
            },
            $disconnect: jest.fn(),
        };
        loader = new DataLoader(mockPrisma);
        jest.clearAllMocks();
    });

    describe('transform', () => {
        it('debe convertir strings de fecha a objetos Date', () => {
            const item = { id: 1, createdAt: '2024-01-01T12:00:00.000Z' };
            const result = loader.transform('User', item);
            expect(result.createdAt).toBeInstanceOf(Date);
            expect(result.createdAt.toISOString()).toBe('2024-01-01T12:00:00.000Z');
        });

        it('debe permitir transformaciones personalizadas para retrocompatibilidad', () => {
            loader.addTransformation('User', (item) => {
                if (item.oldName) {
                    item.newName = item.oldName;
                    delete item.oldName;
                }
                return item;
            });

            const item = { id: 1, oldName: 'Old Value' };
            const result = loader.transform('User', item);

            expect(result.newName).toBe('Old Value');
            expect(result.oldName).toBeUndefined();
        });

        it('debe manejar campos anidados si se requiere (ej. JSON)', () => {
            const item = { id: 1, metadata: '{"key": "value"}' };
            // Si en el futuro transformamos JSON strings a objetos, aquí iría el test
            const result = loader.transform('User', item);
            expect(result.metadata).toBe('{"key": "value"}');
        });
    });

    describe('cleanAll', () => {
        it('debe llamar a deleteMany en todos los modelos en orden inverso', async () => {
            await loader.cleanAll();
            expect(mockPrisma.user.deleteMany).toHaveBeenCalled();
        });
    });

    describe('loadModel', () => {
        it('debe cargar datos usando createMany si está disponible', async () => {
            (fs.existsSync as jest.Mock).mockReturnValue(true);
            (fs.readFileSync as jest.Mock).mockReturnValue('{"id":1, "name":"Test"}\n');

            const count = await loader.loadModel('User', '/tmp');

            expect(count).toBe(1);
            expect(mockPrisma.user.createMany).toHaveBeenCalledWith({
                data: [{ id: 1, name: 'Test' }]
            });
        });

        it('debe usar create si createMany no está disponible', async () => {
            (fs.existsSync as jest.Mock).mockReturnValue(true);
            (fs.readFileSync as jest.Mock).mockReturnValue('{"id":1, "name":"Test"}\n');

            // Simulamos que el modelo no tiene createMany
            delete mockPrisma.user.createMany;

            const count = await loader.loadModel('User', '/tmp');

            expect(count).toBe(1);
            expect(mockPrisma.user.create).toHaveBeenCalledWith({
                data: { id: 1, name: 'Test' }
            });
        });

        it('debe retornar 0 si el archivo no existe', async () => {
            (fs.existsSync as jest.Mock).mockReturnValue(false);
            const count = await loader.loadModel('User', '/tmp');
            expect(count).toBe(0);
            expect(mockPrisma.user.createMany).not.toHaveBeenCalled();
        });
    });

    describe('Orden de Carga', () => {
        it('debe tener todos los modelos necesarios en LOAD_ORDER', () => {
            expect(LOAD_ORDER.length).toBeGreaterThan(20);
            expect(LOAD_ORDER).toContain('User');
            expect(LOAD_ORDER.indexOf('User')).toBeLessThan(LOAD_ORDER.indexOf('Marea'));
        });
    });
});
