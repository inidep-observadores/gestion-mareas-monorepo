"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
const dotenv = require("dotenv");
const path = require("path");
const fs = require("fs");
const client_1 = require("@prisma/client");
const adapter_pg_1 = require("@prisma/adapter-pg");
const pg_1 = require("pg");
dotenv.config();
function expandEnv(str) {
    if (!str)
        return str;
    return str.replace(/\${(\w+)}/g, (_, v) => process.env[v] || '');
}
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
    const log = (msg) => {
        const timestamp = new Date().toISOString();
        const formattedMsg = `[${timestamp}] ${msg}`;
        console.log(formattedMsg);
        logStream.write(formattedMsg + '\n');
    };
    log('--- Iniciando Migración de Observador Principal a Mareas ---');
    const pool = new pg_1.Pool({ connectionString: process.env.DATABASE_URL });
    const adapter = new adapter_pg_1.PrismaPg(pool);
    const prisma = new client_1.PrismaClient({ adapter });
    try {
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
                await prisma.marea.update({
                    where: { id: marea.id },
                    data: {
                        observadorPrincipalId: observadorPrincipal.observadorId
                    }
                });
                log(`[OK] Marea ${marea.id} (${marea.anioMarea}-${marea.nroMarea}) -> Observador: ${observadorPrincipal.observadorId}`);
                updatedCount++;
            }
            catch (err) {
                log(`[ERROR] Marea ${marea.id}: ${err.message}`);
                errorCount++;
            }
        }
        log('\n--- Resumen de Ejecución ---');
        log(`Mareas actualizadas: ${updatedCount}`);
        log(`Mareas omitidas: ${skippedCount}`);
        log(`Errores: ${errorCount}`);
        log(`Log completo guardado en: ${logPath}`);
    }
    catch (error) {
        log(`Error fatal durante la migración: ${error.message}`);
        if (error.stack)
            log(error.stack);
    }
    finally {
        await prisma.$disconnect();
        await pool.end();
        logStream.end();
    }
}
main();
//# sourceMappingURL=migrate-marea-observers.js.map