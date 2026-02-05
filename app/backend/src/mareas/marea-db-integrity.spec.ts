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

            // Cachear datos base con los códigos reales del catálogo
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
    });

    describe('Trigger de Disponibilidad (Flexibilización de Designación)', () => {
        it('debería PERMITIR designar una marea futura mientras el buque está EN_EJECUCION', async () => {
            // 1. Crear marea actualmente navegando
            const mareaNavegando = await prisma.marea.create({
                data: {
                    anioMarea: 2025,
                    nroMarea: 8881,
                    tipoMarea: 'MC',
                    buqueId: buqueId,
                    estadoActualId: estadoEnEjecucionId,
                    fechaZarpadaEstimada: new Date('2025-01-01T10:00:00Z'),
                }
            });

            try {
                // 2. Intentar DESIGNAR una nueva marea para el mismo buque (Debería permitirse)
                const mareaFutura = await prisma.marea.create({
                    data: {
                        anioMarea: 2025,
                        nroMarea: 8882,
                        tipoMarea: 'MC',
                        buqueId: buqueId,
                        estadoActualId: estadoDiseId,
                        fechaZarpadaEstimada: new Date('2025-02-01T10:00:00Z'),
                    }
                });

                expect(mareaFutura).toBeDefined();
                await prisma.marea.delete({ where: { id: mareaFutura.id } });
            } finally {
                // Limpieza
                await prisma.marea.delete({ where: { id: mareaNavegando.id } });
            }
        });

        it('debería BLOQUEAR si se intenta iniciar una marea EN_EJECUCION cuando ya hay otra EN_EJECUCION', async () => {
            // 1. Crear marea navegando
            const marea1 = await prisma.marea.create({
                data: {
                    anioMarea: 2025,
                    nroMarea: 8883,
                    tipoMarea: 'MC',
                    buqueId: buqueId,
                    estadoActualId: estadoEnEjecucionId,
                    fechaZarpadaEstimada: new Date('2025-01-01T10:00:00Z'),
                }
            });

            try {
                // 2. Intentar iniciar OTRA marea al mismo tiempo (Debería FALLAR)
                await expect(prisma.marea.create({
                    data: {
                        anioMarea: 2025,
                        nroMarea: 8884,
                        tipoMarea: 'MC',
                        buqueId: buqueId,
                        estadoActualId: estadoEnEjecucionId,
                        fechaZarpadaEstimada: new Date('2025-01-15T10:00:00Z'),
                    }
                })).rejects.toThrow(/marea en ejecución/i);
            } finally {
                await prisma.marea.delete({ where: { id: marea1.id } });
            }
        });
    });
});
