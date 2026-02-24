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

// Orden de carga (Padres antes que hijos)
export const LOAD_ORDER = [
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

export class DataLoader {
    constructor(private prisma: PrismaClient) { }

    /**
     * Mapa de transformaciones por modelo.
     * Aquí se pueden agregar reglas para manejar versiones antiguas de los datos.
     */
    private transformationRules: Record<string, (item: any) => any> = {
        // Ejemplo: Si el modelo 'Buque' antes tenía 'nombre' y ahora es 'nombreBuque'
        // Buque: (item) => {
        //     if (item.nombre && !item.nombreBuque) {
        //         item.nombreBuque = item.nombre;
        //         delete item.nombre;
        //     }
        //     return item;
        // }
    };

    /**
     * Registra una nueva regla de transformación para un modelo.
     */
    addTransformation(modelName: string, rule: (item: any) => any) {
        this.transformationRules[modelName] = rule;
    }

    /**
     * Transforma un registro antes de ser insertado.
     * Permite manejar retrocompatibilidad con esquemas antiguos.
     */
    transform(modelName: string, item: any): any {
        // Aplicar regla específica si existe
        if (this.transformationRules[modelName]) {
            item = this.transformationRules[modelName](item);
        }

        // Convertir strings de fecha a objetos Date automáticamente
        for (const key in item) {
            if (typeof item[key] === 'string' && /^\d{4}-\d{2}-\d{2}T\d{2}:\d{2}:\d{2}/.test(item[key])) {
                item[key] = new Date(item[key]);
            }
        }
        return item;
    }

    async cleanAll(): Promise<void> {
        console.log('Limpiando base de datos...');
        const cleanOrder = [...LOAD_ORDER].reverse();
        for (const modelName of cleanOrder) {
            const propertyName = modelName.charAt(0).toLowerCase() + modelName.slice(1);
            const model = (this.prisma as any)[propertyName];
            if (model) {
                await model.deleteMany();
            }
        }
        console.log('Base de datos limpia.');
    }

    async loadModel(modelName: string, dataDir: string): Promise<number> {
        const filePath = path.join(dataDir, `${modelName}.jsonl`);

        if (!fs.existsSync(filePath)) {
            return 0;
        }

        const propertyName = modelName.charAt(0).toLowerCase() + modelName.slice(1);
        const model = (this.prisma as any)[propertyName];

        if (!model) {
            throw new Error(`El modelo ${modelName} no existe en Prisma.`);
        }

        const lines = fs.readFileSync(filePath, 'utf8').split('\n').filter(line => line.trim());
        if (lines.length === 0) return 0;

        const data = lines.map(line => this.transform(modelName, JSON.parse(line)));

        // Usar createMany para mayor eficiencia
        if ('createMany' in model) {
            await model.createMany({ data });
        } else {
            for (const item of data) {
                await model.create({ data: item });
            }
        }

        return data.length;
    }

    async loadAll(dataDir: string): Promise<void> {
        console.log('--- Iniciando Seed Estático ---');

        await this.cleanAll();

        for (const modelName of LOAD_ORDER) {
            console.log(`Cargando ${modelName}...`);
            try {
                const count = await this.loadModel(modelName, dataDir);
                if (count > 0) {
                    console.log(`Cargados ${count} registros para ${modelName}.`);
                }
            } catch (error) {
                console.error(`Error cargando ${modelName}:`, error);
            }
        }

        console.log('--- Seed Estático Completado ---');
    }
}

async function main() {
    if (!process.env.DATABASE_URL || process.env.DATABASE_URL.includes('${')) {
        dotenv.config({ path: path.join(process.cwd(), '.env.develop') });
    }

    process.env.DATABASE_URL = expandEnv(process.env.DATABASE_URL);
    
    // =========================================================================
    // SALVAGUARDA CONTRA PÉRDIDA DE DATOS
    // =========================================================================
    const isProduction = process.env.NODE_ENV === 'production';
    const isProdDb = process.env.DATABASE_URL?.includes('supabase') || process.env.DATABASE_URL?.includes('prod');

    if (isProduction || isProdDb) {
        console.error('🚨 [ERROR CRÍTICO] EL SEED FUE BLOQUEADO.');
        console.error('Intentaste ejecutar `prisma db seed` en una base de datos de PRODUCCIÓN o con NODE_ENV=production.');
        console.error('El seed estático contiene una instrucción destructiva de borrado en cascada (cleanAll) que eliminaría la data operativa.');
        console.error('Abortando de inmediato para salvaguardar el sistema.');
        process.exit(1);
    }
    // =========================================================================

    const pool = new Pool({ connectionString: process.env.DATABASE_URL });
    const adapter = new PrismaPg(pool);
    const prisma = new PrismaClient({ adapter });

    const loader = new DataLoader(prisma);
    const dataDir = path.join(__dirname, 'data', 'static');

    try {
        await loader.loadAll(dataDir);
    } finally {
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
