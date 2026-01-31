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

export const MODELS = [
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

export class DataExporter {
    constructor(private prisma: PrismaClient) { }

    static serialize(item: any): string {
        return JSON.stringify(item, (key, value) => {
            if (typeof value === 'object' && value !== null && value.d && value.e && value.s) {
                // Es un Decimal de Prisma/Decimal.js
                return typeof value.toNumber === 'function' ? value.toNumber() : Number(value);
            }
            return value;
        });
    }

    async exportModel(modelName: string, outputDir: string): Promise<number> {
        const propertyName = modelName.charAt(0).toLowerCase() + modelName.slice(1);
        const model = (this.prisma as any)[propertyName];

        if (!model) {
            throw new Error(`El modelo ${modelName} (${propertyName}) no existe en PrismaClient.`);
        }

        const data = await model.findMany();

        if (data.length === 0) {
            return 0;
        }

        const filePath = path.join(outputDir, `${modelName}.jsonl`);
        const stream = fs.createWriteStream(filePath);

        for (const item of data) {
            stream.write(DataExporter.serialize(item) + '\n');
        }

        await new Promise((resolve, reject) => {
            stream.on('finish', resolve);
            stream.on('error', reject);
            stream.end();
        });

        return data.length;
    }

    async exportAll(outputDir: string): Promise<void> {
        if (!fs.existsSync(outputDir)) {
            fs.mkdirSync(outputDir, { recursive: true });
            console.log(`Directorio creado: ${outputDir}`);
        }

        console.log('--- Iniciando Extracción de Datos ---');

        for (const modelName of MODELS) {
            console.log(`Extrayendo ${modelName}...`);
            try {
                const count = await this.exportModel(modelName, outputDir);
                if (count === 0) {
                    console.log(`Sin datos para ${modelName}, omitiendo archivo.`);
                } else {
                    console.log(`Extraídos ${count} registros para ${modelName}.`);
                }
            } catch (error) {
                console.error(`Error extrayendo ${modelName}:`, error);
            }
        }

        console.log('--- Extracción Completada ---');
    }
}

async function main() {
    if (!process.env.DATABASE_URL || process.env.DATABASE_URL.includes('${')) {
        dotenv.config({ path: path.join(process.cwd(), '.env.develop') });
    }

    process.env.DATABASE_URL = expandEnv(process.env.DATABASE_URL);

    const pool = new Pool({ connectionString: process.env.DATABASE_URL });
    const adapter = new PrismaPg(pool);
    const prisma = new PrismaClient({ adapter });

    const exporter = new DataExporter(prisma);
    const outputDir = path.join(__dirname, 'data', 'static');

    try {
        await exporter.exportAll(outputDir);
    } finally {
        await prisma.$disconnect();
        await pool.end();
    }
}

if (require.main === module) {
    main().catch(e => {
        console.error('Error fatal durante la extracción:', e);
        process.exit(1);
    });
}
