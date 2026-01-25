import { DataExporter, MODELS } from './extract-data';
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
        Pool: jest.fn().mockImplementation(() => {
            return {
                connect: jest.fn(),
                query: jest.fn(),
                end: jest.fn(),
            };
        }),
    };
});

describe('DataExporter', () => {
    let mockPrisma: any;
    let exporter: DataExporter;

    beforeEach(() => {
        mockPrisma = {
            user: {
                findMany: jest.fn().mockResolvedValue([{ id: 1, email: 'test@test.com' }]),
            },
            $disconnect: jest.fn(),
        };
        exporter = new DataExporter(mockPrisma);
        jest.clearAllMocks();
    });

    describe('serialize', () => {
        it('debe serializar objetos básicos correctamente', () => {
            const item = { id: 1, name: 'Test' };
            const result = DataExporter.serialize(item);
            expect(result).toBe('{"id":1,"name":"Test"}');
        });

        it('debe convertir Decimal de Prisma a Number', () => {
            const item = {
                id: 1,
                price: {
                    d: [100, 50], e: 2, s: 1,
                    toNumber: () => 100.5
                } // Simulación de objeto Decimal
            };
            const result = DataExporter.serialize(item);
            expect(JSON.parse(result).price).toBe(100.5);
        });

        it('debe mantener Dates como strings ISO en la serialización JSON', () => {
            const date = new Date('2024-01-01T12:00:00Z');
            const item = { date };
            const result = DataExporter.serialize(item);
            expect(JSON.parse(result).date).toBe(date.toISOString());
        });
    });

    describe('exportModel', () => {
        it('debe escribir datos en un archivo .jsonl', async () => {
            const mockStream = {
                write: jest.fn(),
                end: jest.fn(),
                on: jest.fn((event, cb) => {
                    if (event === 'finish') cb();
                }),
            };
            (fs.createWriteStream as jest.Mock).mockReturnValue(mockStream);

            const count = await exporter.exportModel('User', '/tmp');

            expect(count).toBe(1);
            expect(mockPrisma.user.findMany).toHaveBeenCalled();
            expect(fs.createWriteStream).toHaveBeenCalledWith(path.join('/tmp', 'User.jsonl'));
            expect(mockStream.write).toHaveBeenCalledWith('{"id":1,"email":"test@test.com"}\n');
            expect(mockStream.end).toHaveBeenCalled();
        });

        it('debe retornar 0 si no hay datos', async () => {
            mockPrisma.user.findMany.mockResolvedValue([]);
            const count = await exporter.exportModel('User', '/tmp');
            expect(count).toBe(0);
            expect(fs.createWriteStream).not.toHaveBeenCalled();
        });

        it('debe lanzar error si el modelo no existe', async () => {
            await expect(exporter.exportModel('InexistentModel', '/tmp'))
                .rejects.toThrow('no existe en PrismaClient');
        });
    });

    describe('Cobertura de Modelos', () => {
        it('debe tener todos los modelos definidos en MODELS', () => {
            // Esta prueba sirve para recordar que si se agrega un modelo al schema, 
            // hay que agregarlo a la lista de extracción.
            // Aquí podríamos leer schema.prisma programáticamente para comparar, 
            // pero por ahora verificamos que la lista no esté vacía.
            expect(MODELS.length).toBeGreaterThan(20);
            expect(MODELS).toContain('User');
            expect(MODELS).toContain('Marea');
        });
    });
});
