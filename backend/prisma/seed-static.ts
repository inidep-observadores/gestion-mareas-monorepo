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

// Orden de carga (Padres antes que hijos)
const LOAD_ORDER = [
    'User',
    'PasswordResetToken',
    'Product',
    'ProductImage',
    'TipoFlota',
    'Pesqueria',
    'Puerto',
    'Especie',
    'ArtePesca',
    'EstadoMarea',
    'TransicionEstado',
    'Buque',
    'Observador',
    'ObservadorPesqueria',
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
    console.log('--- Iniciando Seed Estático ---');

    // 1. Limpieza de tablas (Orden inverso)
    console.log('Limpiando base de datos...');
    const cleanOrder = [...LOAD_ORDER].reverse();
    for (const modelName of cleanOrder) {
        const propertyName = modelName.charAt(0).toLowerCase() + modelName.slice(1);
        const model = (prisma as any)[propertyName];
        if (model) {
            await model.deleteMany();
        }
    }
    console.log('Base de datos limpia.');

    // 2. Carga de datos
    const dataDir = path.join(__dirname, 'data', 'static');

    for (const modelName of LOAD_ORDER) {
        const filePath = path.join(dataDir, `${modelName}.jsonl`);

        if (!fs.existsSync(filePath)) {
            continue;
        }

        console.log(`Cargando ${modelName}...`);
        const propertyName = modelName.charAt(0).toLowerCase() + modelName.slice(1);
        const model = (prisma as any)[propertyName];

        const lines = fs.readFileSync(filePath, 'utf8').split('\n').filter(line => line.trim());
        if (lines.length === 0) continue;

        const data = lines.map(line => {
            const item = JSON.parse(line);
            // Convertir strings de fecha a objetos Date
            for (const key in item) {
                if (typeof item[key] === 'string' && /^\d{4}-\d{2}-\d{2}T\d{2}:\d{2}:\d{2}/.test(item[key])) {
                    item[key] = new Date(item[key]);
                }
            }
            return item;
        });

        // Usar createMany para mayor eficiencia
        if ('createMany' in model) {
            await model.createMany({ data });
        } else {
            for (const item of data) {
                await model.create({ data: item });
            }
        }
        console.log(`Cargados ${data.length} registros para ${modelName}.`);
    }

    console.log('--- Seed Estático Completado ---');
}

main()
    .catch(e => {
        console.error('Error durante el seed estático:', e);
        process.exit(1);
    })
    .finally(async () => {
        await prisma.$disconnect();
        await pool.end();
    });
