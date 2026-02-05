import { PrismaClient } from '@prisma/client';
import * as dotenv from 'dotenv';
import * as path from 'path';

// Cargar variables de entorno explícitamente para Jest
dotenv.config({ path: path.join(process.cwd(), '.env') });

describe('Integridad de Base de Datos de Mareas (Triggers y Constraints)', () => {
    let prisma: PrismaClient;

    beforeAll(async () => {
        try {
            console.log('Inicializando Prisma Client para tests de integridad...');
            prisma = new PrismaClient({
                log: ['error', 'warn']
            });
            await prisma.$connect();
            console.log('Conexión exitosa a la DB.');
        } catch (e) {
            console.error('Error FATAL conectando a Prisma:', e);
            throw e;
        }
    });

    afterAll(async () => {
        if (prisma) {
            await prisma.$disconnect();
        }
    });

    describe('Check Constraint de Año (Flexible)', () => {
        it('debería permitir zarpada en el mismo año que el año de marea', async () => {
            const buque = await prisma.buque.findFirst();
            const estado = await prisma.estadoMarea.findFirst({ where: { OR: [{ codigo: 'DISE' }, { codigo: 'DESIGNADA' }] } });

            const marea = await prisma.marea.create({
                data: {
                    anioMarea: 2025,
                    nroMarea: 9991,
                    tipoMarea: 'MC',
                    buqueId: buque?.id || '',
                    estadoActualId: estado?.id || '',
                    fechaZarpadaEstimada: new Date('2025-06-15T10:00:00Z'),
                }
            });
            expect(marea).toBeDefined();
            await prisma.marea.delete({ where: { id: marea.id } });
        });

        it('debería permitir zarpada en ENERO del año siguiente (+1)', async () => {
            const buque = await prisma.buque.findFirst();
            const estado = await prisma.estadoMarea.findFirst({ where: { OR: [{ codigo: 'DISE' }, { codigo: 'DESIGNADA' }] } });

            const marea = await prisma.marea.create({
                data: {
                    anioMarea: 2025,
                    nroMarea: 9992,
                    tipoMarea: 'MC',
                    buqueId: buque?.id || '',
                    estadoActualId: estado?.id || '',
                    fechaZarpadaEstimada: new Date('2026-01-10T10:00:00Z'),
                }
            });
            expect(marea).toBeDefined();
            await prisma.marea.delete({ where: { id: marea.id } });
        });

        it('debería FALLAR si la zarpada es en FEBRERO del año siguiente (+1)', async () => {
            const buque = await prisma.buque.findFirst();
            const estado = await prisma.estadoMarea.findFirst({ where: { OR: [{ codigo: 'DISE' }, { codigo: 'DESIGNADA' }] } });

            await expect(prisma.marea.create({
                data: {
                    anioMarea: 2025,
                    nroMarea: 9993,
                    tipoMarea: 'MC',
                    buqueId: buque?.id || '',
                    estadoActualId: estado?.id || '',
                    fechaZarpadaEstimada: new Date('2026-02-10T10:00:00Z'),
                }
            })).rejects.toThrow();
        });
    });

    describe('Trigger de Disponibilidad', () => {
        let buqueId: string;
        let estadoActivaId: string;

        beforeAll(async () => {
            buqueId = (await prisma.buque.findFirst())?.id || '';
            const estado = await prisma.estadoMarea.findFirst({ where: { codigo: 'ACTIVA' } });
            estadoActivaId = estado?.id || '';
        });

        it('debería FALLAR si se intenta crear una marea para un buque que ya tiene marea ACTIVA', async () => {
            // 1. Crear marea activa legítima
            const mareaActiva = await prisma.marea.create({
                data: {
                    anioMarea: 2025,
                    nroMarea: 9994,
                    tipoMarea: 'MC',
                    buqueId: buqueId,
                    estadoActualId: estadoActivaId,
                    fechaZarpadaEstimada: new Date('2025-05-01T10:00:00Z'),
                }
            });

            // 2. Intentar crear otra marea para el mismo buque
            await expect(prisma.marea.create({
                data: {
                    anioMarea: 2025,
                    nroMarea: 9995,
                    tipoMarea: 'MC',
                    buqueId: buqueId,
                    estadoActualId: estadoActivaId,
                    fechaZarpadaEstimada: new Date('2025-06-01T10:00:00Z'),
                }
            })).rejects.toThrow(/buque ya tiene una marea activa/i);

            // Limpieza
            await prisma.marea.delete({ where: { id: mareaActiva.id } });
        });
    });
});
