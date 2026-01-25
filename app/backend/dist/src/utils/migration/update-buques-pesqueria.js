"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
const dotenv = require("dotenv");
const path = require("path");
const fs = require("fs");
const client_1 = require("@prisma/client");
const adapter_pg_1 = require("@prisma/adapter-pg");
const pg_1 = require("pg");
const mdb_reader_1 = require("mdb-reader");
dotenv.config();
const SPECIES_TO_FISHERY = {
    'VIEIRA': 'Vieira',
    'MERLUZA AUSTRAL': 'Especies australes',
    'MERLUZA': 'Merluza común',
    'ANCHOITA': 'Anchoíta',
    'CENTOLLA': 'Centolla',
    'CABALLA': 'Caballa',
    'LANGOSTINO': 'Langostino',
    'CALAMAR': 'Calamar',
    'ABADEJO': 'Abadejo',
};
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
    const logPath = path.join(logDir, 'migration_update_buques.log');
    const logStream = fs.createWriteStream(logPath, { flags: 'w' });
    const log = (msg) => {
        const timestamp = new Date().toISOString();
        const formattedMsg = `[${timestamp}] ${msg}`;
        console.log(formattedMsg);
        logStream.write(formattedMsg + '\n');
    };
    log('--- Iniciando Actualización de Pesquería Habitual de Buques ---');
    const pool = new pg_1.Pool({ connectionString: process.env.DATABASE_URL });
    const adapter = new adapter_pg_1.PrismaPg(pool);
    const prisma = new client_1.PrismaClient({ adapter });
    const accessPath = path.join(process.cwd(), 'old_data', 'MareasAipBD.accdb');
    if (!fs.existsSync(accessPath)) {
        console.error(`Error: No se encontró el archivo Access en ${accessPath}`);
        return;
    }
    try {
        const buffer = fs.readFileSync(accessPath);
        const reader = new mdb_reader_1.default(buffer);
        const table = reader.getTable('Mareas');
        const data = table.getData();
        log(`Leídos ${data.length} registros de la tabla Mareas.`);
        const buqueSpeciesCount = {};
        for (const row of data) {
            const buqueName = row.Buque?.trim().toUpperCase();
            const especieName = row.Especie?.trim().toUpperCase();
            if (!buqueName || !especieName)
                continue;
            if (!buqueSpeciesCount[buqueName]) {
                buqueSpeciesCount[buqueName] = {};
            }
            buqueSpeciesCount[buqueName][especieName] = (buqueSpeciesCount[buqueName][especieName] || 0) + 1;
        }
        const buqueDominantSpecies = {};
        for (const buque in buqueSpeciesCount) {
            let maxCount = 0;
            let dominantSpecies = '';
            for (const especie in buqueSpeciesCount[buque]) {
                if (buqueSpeciesCount[buque][especie] > maxCount) {
                    maxCount = buqueSpeciesCount[buque][especie];
                    dominantSpecies = especie;
                }
            }
            buqueDominantSpecies[buque] = dominantSpecies;
        }
        log(`Encontrados ${Object.keys(buqueDominantSpecies).length} buques con registros en Access.`);
        const pesquerias = await prisma.pesqueria.findMany();
        const pesqueriaMap = {};
        pesquerias.forEach(p => {
            pesqueriaMap[p.nombre] = p.id;
        });
        let updatedCount = 0;
        let notFoundSpecies = new Set();
        let notFoundFishery = new Set();
        let notFoundBuque = new Set();
        for (const buqueAccessName in buqueDominantSpecies) {
            const especieDominante = buqueDominantSpecies[buqueAccessName];
            const pesqueriaNombre = SPECIES_TO_FISHERY[especieDominante];
            if (!pesqueriaNombre) {
                notFoundSpecies.add(especieDominante);
                continue;
            }
            const pesqueriaId = pesqueriaMap[pesqueriaNombre];
            if (!pesqueriaId) {
                notFoundFishery.add(pesqueriaNombre);
                continue;
            }
            const buque = await prisma.buque.findFirst({
                where: {
                    nombreBuque: {
                        equals: buqueAccessName,
                        mode: 'insensitive'
                    }
                }
            });
            if (buque) {
                await prisma.buque.update({
                    where: { id: buque.id },
                    data: { pesqueriaHabitualId: pesqueriaId }
                });
                updatedCount++;
                log(`[OK] Buque: ${buque.nombreBuque} (Access: ${buqueAccessName}) -> Pesquería: ${pesqueriaNombre}`);
            }
            else {
                notFoundBuque.add(buqueAccessName);
            }
        }
        log('\n--- Resumen de Ejecución ---');
        log(`Buques actualizados: ${updatedCount}`);
        if (notFoundBuque.size > 0) {
            log(`\nBuques no encontrados en Postgres (${notFoundBuque.size}):`);
            log(Array.from(notFoundBuque).join(', '));
        }
        if (notFoundSpecies.size > 0) {
            log(`\nEspecies sin mapeo definido en Access (${notFoundSpecies.size}):`);
            log(Array.from(notFoundSpecies).join(', '));
        }
        if (notFoundFishery.size > 0) {
            log(`\nPesquerías no encontradas en el catálogo del sistema (${notFoundFishery.size}):`);
            log(Array.from(notFoundFishery).join(', '));
        }
        log(`\nLog completo guardado en: ${logPath}`);
    }
    catch (error) {
        log(`Error durante la migración: ${error.message}`);
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
//# sourceMappingURL=update-buques-pesqueria.js.map