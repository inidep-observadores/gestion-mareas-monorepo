import * as dotenv from 'dotenv';
import * as path from 'path';
import * as fs from 'fs';
import { PrismaClient } from '@prisma/client';
import { PrismaPg } from '@prisma/adapter-pg';
import { Pool } from 'pg';

dotenv.config();

function expandEnv(str: string | undefined): string | undefined {
    if (!str) return str;
    return str.replace(/\${(\w+)}/g, (_, v) => process.env[v] || '');
}

// Cargar configuración de base de datos
const envFile = path.join(process.cwd(), '.env.develop');
if (fs.existsSync(envFile)) {
    dotenv.config({ path: envFile });
}

process.env.DATABASE_URL = expandEnv(process.env.DATABASE_URL);

async function main() {
    const logDir = path.join(__dirname, 'logs');
    if (!fs.existsSync(logDir)) {
        fs.mkdirSync(logDir, { recursive: true });
    }
    const logPath = path.join(logDir, 'migrate-marea-observers.log');
    const logStream = fs.createWriteStream(logPath, { flags: 'w' });

    const log = (msg: string) => {
        const timestamp = new Date().toISOString();
        const formattedMsg = `[${timestamp}] ${msg}`;
        console.log(formattedMsg);
        logStream.write(formattedMsg + '\n');
    };

    log('--- Iniciando Migración de Observador Principal a Mareas ---');

    const pool = new Pool({ connectionString: process.env.DATABASE_URL });
    const adapter = new PrismaPg(pool);
    const prisma = new PrismaClient({ adapter });

    try {
        // Obtenemos las mareas que tengan etapa 1 y observador principal
        const mareas = await prisma.marea.findMany({
            include: {
                etapas: {
                    where: { nroEtapa: 1 },
                    include: {
                        observadores: {
                            where: { rol: 'PRINCIPAL' }
                        }
                    }
                }
            }
        });

        log(`Encontradas ${mareas.length} mareas para procesar.`);

        let updatedCount = 0;
        let skippedCount = 0;
        let errorCount = 0;

        for (const marea of mareas) {
            try {
                const primeraEtapa = marea.etapas[0];

                if (!primeraEtapa) {
                    log(`[SKIP] Marea ${marea.id} (${marea.anioMarea}-${marea.nroMarea}): No tiene la Etapa 1.`);
                    skippedCount++;
                    continue;
                }

                const observadorPrincipal = primeraEtapa.observadores[0];

                if (!observadorPrincipal) {
                    log(`[SKIP] Marea ${marea.id} (${marea.anioMarea}-${marea.nroMarea}): No tiene observador principal en la Etapa 1.`);
                    skippedCount++;
                    continue;
                }

                // Usamos cast a 'any' para evitar errores de tipos en el IDE si el cliente Prisma no está actualizado localmente
                await (prisma.marea.update as any)({
                    where: { id: marea.id },
                    data: {
                        observadorPrincipalId: observadorPrincipal.observadorId
                    }
                });

                log(`[OK] Marea ${marea.id} (${marea.anioMarea}-${marea.nroMarea}) -> Observador: ${observadorPrincipal.observadorId}`);
                updatedCount++;
            } catch (err) {
                log(`[ERROR] Marea ${marea.id}: ${err.message}`);
                errorCount++;
            }
        }

        log('\n--- Resumen de Ejecución ---');
        log(`Mareas actualizadas: ${updatedCount}`);
        log(`Mareas omitidas: ${skippedCount}`);
        log(`Errores: ${errorCount}`);
        log(`Log completo guardado en: ${logPath}`);

    } catch (error) {
        log(`Error fatal durante la migración: ${error.message}`);
        if (error.stack) log(error.stack);
    } finally {
        await prisma.$disconnect();
        await pool.end();
        logStream.end();
    }
}

main();
