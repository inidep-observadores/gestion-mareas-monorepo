"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
exports.DataLoader = exports.LOAD_ORDER = void 0;
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
exports.LOAD_ORDER = [
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
class DataLoader {
    constructor(prisma) {
        this.prisma = prisma;
        this.transformationRules = {};
    }
    addTransformation(modelName, rule) {
        this.transformationRules[modelName] = rule;
    }
    transform(modelName, item) {
        if (this.transformationRules[modelName]) {
            item = this.transformationRules[modelName](item);
        }
        for (const key in item) {
            if (typeof item[key] === 'string' && /^\d{4}-\d{2}-\d{2}T\d{2}:\d{2}:\d{2}/.test(item[key])) {
                item[key] = new Date(item[key]);
            }
        }
        return item;
    }
    async cleanAll() {
        console.log('Limpiando base de datos...');
        const cleanOrder = [...exports.LOAD_ORDER].reverse();
        for (const modelName of cleanOrder) {
            const propertyName = modelName.charAt(0).toLowerCase() + modelName.slice(1);
            const model = this.prisma[propertyName];
            if (model) {
                await model.deleteMany();
            }
        }
        console.log('Base de datos limpia.');
    }
    async loadModel(modelName, dataDir) {
        const filePath = path.join(dataDir, `${modelName}.jsonl`);
        if (!fs.existsSync(filePath)) {
            return 0;
        }
        const propertyName = modelName.charAt(0).toLowerCase() + modelName.slice(1);
        const model = this.prisma[propertyName];
        if (!model) {
            throw new Error(`El modelo ${modelName} no existe en Prisma.`);
        }
        const lines = fs.readFileSync(filePath, 'utf8').split('\n').filter(line => line.trim());
        if (lines.length === 0)
            return 0;
        const data = lines.map(line => this.transform(modelName, JSON.parse(line)));
        if ('createMany' in model) {
            await model.createMany({ data });
        }
        else {
            for (const item of data) {
                await model.create({ data: item });
            }
        }
        return data.length;
    }
    async loadAll(dataDir) {
        console.log('--- Iniciando Seed Estático ---');
        await this.cleanAll();
        for (const modelName of exports.LOAD_ORDER) {
            console.log(`Cargando ${modelName}...`);
            try {
                const count = await this.loadModel(modelName, dataDir);
                if (count > 0) {
                    console.log(`Cargados ${count} registros para ${modelName}.`);
                }
            }
            catch (error) {
                console.error(`Error cargando ${modelName}:`, error);
            }
        }
        console.log('--- Seed Estático Completado ---');
    }
}
exports.DataLoader = DataLoader;
async function main() {
    if (!process.env.DATABASE_URL || process.env.DATABASE_URL.includes('${')) {
        dotenv.config({ path: path.join(process.cwd(), '.env.develop') });
    }
    process.env.DATABASE_URL = expandEnv(process.env.DATABASE_URL);
    const pool = new pg_1.Pool({ connectionString: process.env.DATABASE_URL });
    const adapter = new adapter_pg_1.PrismaPg(pool);
    const prisma = new client_1.PrismaClient({ adapter });
    const loader = new DataLoader(prisma);
    const dataDir = path.join(__dirname, 'data', 'static');
    try {
        await loader.loadAll(dataDir);
    }
    finally {
        await prisma.$disconnect();
        await pool.end();
    }
}
if (require.main === module) {
    main().catch(e => {
        console.error('Error fatal durante el seed estático:', e);
        process.exit(1);
    });
}
//# sourceMappingURL=seed-static.js.map