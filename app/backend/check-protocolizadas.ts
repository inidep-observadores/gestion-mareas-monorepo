
import * as dotenv from 'dotenv';
import * as path from 'path';
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

async function main() {
    console.log('--- Mareas Protocolizadas ---');
    const mareas = await prisma.marea.findMany({
        where: {
            estadoActual: { codigo: 'PROTOCOLIZADA' },
            activo: true
        },
        select: {
            id: true,
            nroMarea: true,
            anioMarea: true,
            anioProtocolizacion: true,
            nroProtocolizacion: true,
            fechaProtocolizacion: true,
            estadoActual: { select: { nombre: true, codigo: true } }
        },
        take: 10
    });

    console.table(mareas.map(m => ({
        id: m.id,
        marea: `${m.nroMarea}/${m.anioMarea}`,
        anioProt: m.anioProtocolizacion,
        nroProt: m.nroProtocolizacion,
        fechaProt: m.fechaProtocolizacion,
        estado: m.estadoActual.codigo
    })));

    console.log('\n--- Conteo de Protocolizadas por Anio Protocolizacion ---');
    const counts = await prisma.marea.groupBy({
        by: ['anioProtocolizacion'],
        _count: { id: true },
        where: {
            estadoActual: { codigo: 'PROTOCOLIZADA' },
            activo: true
        }
    });
    console.table(counts);

    console.log('\n--- Conteo de Protocolizadas por Anio Marea ---');
    const countsMarea = await prisma.marea.groupBy({
        by: ['anioMarea'],
        _count: { id: true },
        where: {
            estadoActual: { codigo: 'PROTOCOLIZADA' },
            activo: true
        }
    });
    console.table(countsMarea);
}

main()
    .catch(e => console.error(e))
    .finally(async () => await prisma.$disconnect());
