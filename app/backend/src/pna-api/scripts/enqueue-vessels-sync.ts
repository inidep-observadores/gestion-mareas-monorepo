
import { PrismaClient } from '@prisma/client';
import { PrismaPg } from '@prisma/adapter-pg';
import { Pool } from 'pg';
import * as dotenv from 'dotenv';
import { join } from 'path';

// Cargar variables de entorno
const envPath = join(process.cwd(), '.env');
dotenv.config({ path: envPath });

async function enqueueVesselsSync() {
    console.log('--- Iniciando Encolamiento de Sincronización de Buques (2024-2025) ---');

    if (!process.env.DATABASE_URL) {
        console.error('❌ Error: DATABASE_URL no está definida.');
        process.exit(1);
    }

    const pool = new Pool({ connectionString: process.env.DATABASE_URL });
    const adapter = new PrismaPg(pool);
    const prisma = new PrismaClient({ adapter });

    try {
        await prisma.$connect();

        // 1. Obtener IDs únicos de buques vinculados a mareas 2024 y 2025
        const mareas = await prisma.marea.findMany({
            where: {
                anioMarea: { in: [2024, 2025] },
                activo: true
            },
            select: {
                buqueId: true
            }
        });

        const buqueIds = [...new Set(mareas.map(m => m.buqueId))];
        console.log(`🔍 Se identificaron ${buqueIds.length} buques para revisar.`);

        // 2. Obtener detalles de esos buques
        const buques = await prisma.buque.findMany({
            where: {
                id: { in: buqueIds }
            },
            select: {
                id: true,
                nombreBuque: true,
                idMbpc: true,
                mmsi: true,
                fechaUltimaActApi: true
            }
        });

        const THRESHOLD_DAYS = parseInt(process.env.VESSEL_SYNC_THRESHOLD_DAYS || '7', 10);
        const now = new Date();
        let enqueuedCount = 0;

        for (const buque of buques) {
            // Verificar si necesita actualización (si no tiene o es vieja)
            const needsSync = !buque.fechaUltimaActApi ||
                (now.getTime() - buque.fechaUltimaActApi.getTime()) / (1000 * 3600 * 24) >= THRESHOLD_DAYS;

            if (needsSync) {
                // Verificar si ya hay un trabajo pendiente para este buque para no duplicar
                const existingJob = await prisma.jobQueue.findFirst({
                    where: {
                        type: 'VESSEL_SYNC',
                        status: 'PENDING',
                        payload: {
                            path: ['id'],
                            equals: buque.id
                        }
                    }
                });

                if (!existingJob) {
                    await prisma.jobQueue.create({
                        data: {
                            type: 'VESSEL_SYNC',
                            payload: {
                                id: buque.id,
                                nombreBuque: buque.nombreBuque,
                                idMbpc: buque.idMbpc,
                                mmsi: buque.mmsi
                            },
                            priority: 10,
                            status: 'PENDING',
                            nextRunAt: new Date()
                        }
                    });
                    enqueuedCount++;
                    console.log(`[+] Encolado: ${buque.nombreBuque} (${buque.idMbpc || buque.mmsi || 'Sin ID'})`);
                } else {
                    console.log(`[-] Ya existe trabajo pendiente para: ${buque.nombreBuque}`);
                }
            } else {
                console.log(`[ok] ${buque.nombreBuque} está actualizado.`);
            }
        }

        console.log('--------------------------------------------');
        console.log(`✅ Proceso finalizado. Se encolaron ${enqueuedCount} trabajos de sincronización.`);
        console.log('Los trabajos serán procesados por el Scheduler automáticamente.');

    } catch (error) {
        console.error('❌ Error fatal:', error);
    } finally {
        await prisma.$disconnect();
        await pool.end();
    }
}

enqueueVesselsSync();
