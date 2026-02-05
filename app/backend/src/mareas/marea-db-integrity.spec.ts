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
    let estadoEnEjecucionId: string;

    beforeAll(async () => {
        const dbUrl = process.env.DATABASE_URL;
        if (!dbUrl) {
            throw new Error('DATABASE_URL no está definida en el entorno (.env).');
        }

        pool = new Pool({ connectionString: dbUrl });
        const adapter = new PrismaPg(pool);
        prisma = new PrismaClient({ adapter });

        try {
            await prisma.$connect();

            const buque = await prisma.buque.findFirst({ where: { activo: true } });
            const dise = await prisma.estadoMarea.findFirst({ where: { codigo: 'DESIGNADA' } });
            const ejecucion = await prisma.estadoMarea.findFirst({ where: { codigo: 'EN_EJECUCION' } });

            if (!buque || !dise || !ejecucion) {
                throw new Error('Datos base insuficientes en DB para ejecutar tests.');
            }

            buqueId = buque.id;
            estadoDiseId = dise.id;
            estadoEnEjecucionId = ejecucion.id;
        } catch (e) {
            throw e;
        }
    });

    afterAll(async () => {
        if (prisma) await prisma.$disconnect();
        if (pool) await pool.end();
    });

    describe('Reglas de Disponibilidad (Refinadas)', () => {
        it('debería permitir 1 DESIGNADA mientras se está EN_EJECUCION', async () => {
            const marea1 = await prisma.marea.create({
                data: {
                    anioMarea: 2025,
                    nroMarea: 7771,
                    tipoMarea: 'MC',
                    buqueId: buqueId,
                    estadoActualId: estadoEnEjecucionId,
                    fechaZarpadaEstimada: new Date('2025-01-01T10:00:00Z'),
                }
            });

            const marea2 = await prisma.marea.create({
                data: {
                    anioMarea: 2025,
                    nroMarea: 7772,
                    tipoMarea: 'MC',
                    buqueId: buqueId,
                    estadoActualId: estadoDiseId,
                    fechaZarpadaEstimada: new Date('2025-02-01T10:00:00Z'),
                }
            });

            expect(marea2).toBeDefined();

            await prisma.marea.delete({ where: { id: marea2.id } });
            await prisma.marea.delete({ where: { id: marea1.id } });
        });

        it('debería BLOQUEAR si se intenta tener 2 mareas en estado DESIGNADA para el mismo recurso', async () => {
            const marea1 = await prisma.marea.create({
                data: {
                    anioMarea: 2025,
                    nroMarea: 7773,
                    tipoMarea: 'MC',
                    buqueId: buqueId,
                    estadoActualId: estadoDiseId,
                    fechaZarpadaEstimada: new Date('2025-03-01T10:00:00Z'),
                }
            });

            try {
                await expect(prisma.marea.create({
                    data: {
                        anioMarea: 2025,
                        nroMarea: 7774,
                        tipoMarea: 'MC',
                        buqueId: buqueId,
                        estadoActualId: estadoDiseId,
                        fechaZarpadaEstimada: new Date('2025-04-01T10:00:00Z'),
                    }
                })).rejects.toThrow(/ya tiene otra marea designada/i);
            } finally {
                await prisma.marea.delete({ where: { id: marea1.id } });
            }
        });

        it('debería BLOQUEAR si se intenta tener 2 mareas en estado EN_EJECUCION simultáneas', async () => {
            const marea1 = await prisma.marea.create({
                data: {
                    anioMarea: 2025,
                    nroMarea: 7775,
                    tipoMarea: 'MC',
                    buqueId: buqueId,
                    estadoActualId: estadoEnEjecucionId,
                    fechaZarpadaEstimada: new Date('2025-01-01T10:00:00Z'),
                }
            });

            try {
                await expect(prisma.marea.create({
                    data: {
                        anioMarea: 2025,
                        nroMarea: 7776,
                        tipoMarea: 'MC',
                        buqueId: buqueId,
                        estadoActualId: estadoEnEjecucionId,
                        fechaZarpadaEstimada: new Date('2025-01-15T10:00:00Z'),
                    }
                })).rejects.toThrow(/ya tiene una marea en ejecución/i);
            } finally {
                await prisma.marea.delete({ where: { id: marea1.id } });
            }
        });
    });
});
