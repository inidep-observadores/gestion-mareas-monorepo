"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
exports.DataExporter = exports.MODELS = void 0;
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
exports.MODELS = [
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
class DataExporter {
    constructor(prisma) {
        this.prisma = prisma;
    }
    static serialize(item) {
        return JSON.stringify(item, (key, value) => {
            if (typeof value === 'object' && value !== null && value.d && value.e && value.s) {
                return typeof value.toNumber === 'function' ? value.toNumber() : Number(value);
            }
            return value;
        });
    }
    async exportModel(modelName, outputDir) {
        const propertyName = modelName.charAt(0).toLowerCase() + modelName.slice(1);
        const model = this.prisma[propertyName];
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
    async exportAll(outputDir) {
        if (!fs.existsSync(outputDir)) {
            fs.mkdirSync(outputDir, { recursive: true });
            console.log(`Directorio creado: ${outputDir}`);
        }
        console.log('--- Iniciando Extracción de Datos ---');
        for (const modelName of exports.MODELS) {
            console.log(`Extrayendo ${modelName}...`);
            try {
                const count = await this.exportModel(modelName, outputDir);
                if (count === 0) {
                    console.log(`Sin datos para ${modelName}, omitiendo archivo.`);
                }
                else {
                    console.log(`Extraídos ${count} registros para ${modelName}.`);
                }
            }
            catch (error) {
                console.error(`Error extrayendo ${modelName}:`, error);
            }
        }
        console.log('--- Extracción Completada ---');
    }
}
exports.DataExporter = DataExporter;
async function main() {
    if (!process.env.DATABASE_URL || process.env.DATABASE_URL.includes('${')) {
        dotenv.config({ path: path.join(process.cwd(), '.env.develop') });
    }
    process.env.DATABASE_URL = expandEnv(process.env.DATABASE_URL);
    const pool = new pg_1.Pool({ connectionString: process.env.DATABASE_URL });
    const adapter = new adapter_pg_1.PrismaPg(pool);
    const prisma = new client_1.PrismaClient({ adapter });
    const exporter = new DataExporter(prisma);
    const outputDir = path.join(__dirname, 'data', 'static');
    try {
        await exporter.exportAll(outputDir);
    }
    finally {
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
//# sourceMappingURL=extract-data.js.map