import * as dotenv from 'dotenv';
import * as path from 'path';
import * as fs from 'fs';
import { PrismaClient } from '@prisma/client';
import { PrismaPg } from '@prisma/adapter-pg';
import { Pool } from 'pg';
import MDBReader from 'mdb-reader';

dotenv.config();

// Mapeo sugerido por el usuario
const SPECIES_TO_FISHERY: Record<string, string> = {
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
    const logPath = path.join(logDir, 'migration_update_buques.log');
    const logStream = fs.createWriteStream(logPath, { flags: 'w' });

    const log = (msg: string) => {
        const timestamp = new Date().toISOString();
        const formattedMsg = `[${timestamp}] ${msg}`;
        console.log(formattedMsg);
        logStream.write(formattedMsg + '\n');
    };

    log('--- Iniciando Actualización de Pesquería Habitual de Buques ---');

    const pool = new Pool({ connectionString: process.env.DATABASE_URL });
    const adapter = new PrismaPg(pool);
    const prisma = new PrismaClient({ adapter });

    const accessPath = path.join(process.cwd(), 'old_data', 'MareasAipBD.accdb');

    if (!fs.existsSync(accessPath)) {
        console.error(`Error: No se encontró el archivo Access en ${accessPath}`);
        return;
    }

    try {
        const buffer = fs.readFileSync(accessPath);
        const reader = new MDBReader(buffer);
        const table = reader.getTable('Mareas');
        const data = table.getData();

        log(`Leídos ${data.length} registros de la tabla Mareas.`);

        // 1. Agrupar frecuencias de especies por buque
        const buqueSpeciesCount: Record<string, Record<string, number>> = {};

        for (const row of data) {
            const buqueName = (row.Buque as string)?.trim().toUpperCase();
            const especieName = (row.Especie as string)?.trim().toUpperCase();

            if (!buqueName || !especieName) continue;

            if (!buqueSpeciesCount[buqueName]) {
                buqueSpeciesCount[buqueName] = {};
            }

            buqueSpeciesCount[buqueName][especieName] = (buqueSpeciesCount[buqueName][especieName] || 0) + 1;
        }

        // 2. Determinar la especie dominante por cada buque
        const buqueDominantSpecies: Record<string, string> = {};
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

        // 3. Obtener pesquerías del sistema para el mapeo
        const pesquerias = await prisma.pesqueria.findMany();
        const pesqueriaMap: Record<string, string> = {}; // nombre -> id
        pesquerias.forEach(p => {
            pesqueriaMap[p.nombre] = p.id;
        });

        // 4. Actualizar buques en Postgres
        let updatedCount = 0;
        let notFoundSpecies = new Set<string>();
        let notFoundFishery = new Set<string>();
        let notFoundBuque = new Set<string>();

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

            // Buscar el buque en nuestra BD (insensible a mayúsculas/minúsculas y espacios)
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
            } else {
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

    } catch (error) {
        log(`Error durante la migración: ${error.message}`);
        if (error.stack) log(error.stack);
    } finally {
        await prisma.$disconnect();
        await pool.end();
        logStream.end();
    }
}

main();
