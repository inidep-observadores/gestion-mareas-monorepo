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

if (!process.env.DATABASE_URL || process.env.DATABASE_URL.includes('${')) {
    dotenv.config({ path: path.join(process.cwd(), '.env.develop') });
}

process.env.DATABASE_URL = expandEnv(process.env.DATABASE_URL);

const pool = new Pool({ connectionString: process.env.DATABASE_URL });
const adapter = new PrismaPg(pool);
const prisma = new PrismaClient({ adapter });

const MODELS = [
    'User',
    'PasswordResetToken',
    'Product',
    'ProductImage',
    'TipoFlota',
    'Buque',
    'ArtePesca',
    'Pesqueria',
    'Puerto',
    'Especie',
    'Observador',
    'ObservadorPesqueria',
    'EstadoMarea',
    'TransicionEstado',
    'Marea',
    'MareaEtapa',
    'MareaEtapaObservador',
    'MareaMovimiento',
    'MareaArchivo',
    'Lance',
    'Captura',
    'Muestra',
    'MuestraDetalleTalla',
    'Submuestra',
    'Produccion',
    'BuqueTrayectoria',
    'BuqueTrayectoriaPunto',
    'Alerta',
    'AlertaEvento',
    'ImportacionAccessSnapshot',
    'ErrorLog'
];

async function main() {
    const outputDir = path.join(__dirname, 'data', 'static');
    if (!fs.existsSync(outputDir)) {
        fs.mkdirSync(outputDir, { recursive: true });
        console.log(`Directorio creado: ${outputDir}`);
    }

    console.log('--- Iniciando Extracción de Datos ---');

    for (const modelName of MODELS) {
        const propertyName = modelName.charAt(0).toLowerCase() + modelName.slice(1);
        const model = (prisma as any)[propertyName];

        if (!model) {
            console.error(`Error: El modelo ${modelName} (${propertyName}) no existe en PrismaClient.`);
            continue;
        }

        console.log(`Extrayendo ${modelName}...`);
        const data = await model.findMany();

        if (data.length === 0) {
            console.log(`Sin datos para ${modelName}, omitiendo archivo.`);
            continue;
        }

        const filePath = path.join(outputDir, `${modelName}.jsonl`);
        const stream = fs.createWriteStream(filePath);

        for (const item of data) {
            // Manejar tipos especiales como Decimal de Prisma
            const serialized = JSON.stringify(item, (key, value) => {
                if (typeof value === 'object' && value !== null && value.d && value.e && value.s) {
                    // Es un Decimal de Prisma/Decimal.js
                    return Number(value);
                }
                return value;
            });
            stream.write(serialized + '\n');
        }

        stream.end();
        console.log(`Extraídos ${data.length} registros para ${modelName}.`);
    }

    console.log('--- Extracción Completada ---');
}

main()
    .catch(e => {
        console.error('Error durante la extracción:', e);
        process.exit(1);
    })
    .finally(async () => {
        await prisma.$disconnect();
        await pool.end();
    });
