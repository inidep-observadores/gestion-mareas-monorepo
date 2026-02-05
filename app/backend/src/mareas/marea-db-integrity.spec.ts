import 'reflect-metadata';
import * as dotenv from 'dotenv';
import * as path from 'path';
import { Pool } from 'pg';
import { PrismaPg } from '@prisma/adapter-pg';
import { PrismaClient } from '@prisma/client';

// Cargar variables de entorno
dotenv.config({ path: path.join(__dirname, '../../.env') });

describe('Integridad de Base de Datos de Mareas (Triggers y Constraints)', () => {
    let prisma: PrismaClient;
    let pool: Pool;
    let buqueId: string;
    let estadoDiseId: string;
    let estadoActivaId: string;

    beforeAll(async () => {
        const dbUrl = process.env.DATABASE_URL;
        if (!dbUrl) {
            throw new Error('DATABASE_URL no está definida en el entorno (.env).');
        }

        // Usar la misma lógica de conexión que PrismaService (pool + adaptador)
        pool = new Pool({ connectionString: dbUrl });
        const adapter = new PrismaPg(pool);
        prisma = new PrismaClient({ adapter });

        try {
            await prisma.$connect();

            // Cachear IDs necesarios para los tests
            const buque = await prisma.buque.findFirst({ where: { activo: true } });
            const dise = await prisma.estadoMarea.findFirst({ where: { codigo: 'DESIGNADA' } });
            const activa = await prisma.estadoMarea.findFirst({ where: { codigo: 'EN_EJECUCION' } });

            if (!buque || !dise || !activa) {
                throw new Error('Datos base insuficientes en DB para ejecutar tests.');
            }

            buqueId = buque.id;
            estadoDiseId = dise.id;
            estadoActivaId = activa.id;
        } catch (e) {
            throw e;
        }
    });

    afterAll(async () => {
        if (prisma) await prisma.$disconnect();
        if (pool) await pool.end();
    });

    describe('Check Constraint de Año (Flexible)', () => {
        it('debería permitir zarpada en el mismo año que el año de marea', async () => {
            const marea = await prisma.marea.create({
                data: {
                    anioMarea: 2025,
                    nroMarea: 9991,
                    tipoMarea: 'MC',
                    buqueId: buqueId,
                    estadoActualId: estadoDiseId,
                    fechaZarpadaEstimada: new Date('2025-06-15T10:00:00Z'),
                }
            });
            expect(marea).toBeDefined();
            await prisma.marea.delete({ where: { id: marea.id } });
        });

        it('debería prohibir zarpada en FEBRERO del año siguiente (+1)', async () => {
            await expect(prisma.marea.create({
                data: {
                    anioMarea: 2025,
                    nroMarea: 9993,
                    tipoMarea: 'MC',
                    buqueId: buqueId,
                    estadoActualId: estadoDiseId,
                    fechaZarpadaEstimada: new Date('2026-02-10T10:00:00Z'),
                }
            })).rejects.toThrow();
        });
    });

    describe('Trigger de Disponibilidad', () => {
        it('debería BLOQUEAR solapamiento de marea ACTIVA en el mismo buque', async () => {
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

            try {
                await expect(prisma.marea.create({
                    data: {
                        anioMarea: 2025,
                        nroMarea: 9995,
                        tipoMarea: 'MC',
                        buqueId: buqueId,
                        estadoActualId: estadoDiseId,
                        fechaZarpadaEstimada: new Date('2025-06-01T10:00:00Z'),
                    }
                })).rejects.toThrow(/buque ya tiene una marea activa/i);
            } finally {
                await prisma.marea.delete({ where: { id: mareaActiva.id } });
            }
        });
    });
});
