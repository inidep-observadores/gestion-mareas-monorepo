import * as dotenv from 'dotenv';
import * as path from 'path';

dotenv.config();
if (!process.env.DATABASE_URL) {
    dotenv.config({ path: path.join(process.cwd(), '.env.develop') });
}

import { PrismaClient } from '@prisma/client';
import { PrismaPg } from '@prisma/adapter-pg';
import { Pool } from 'pg';

const pool = new Pool({ connectionString: process.env.DATABASE_URL });
const adapter = new PrismaPg(pool);
const prisma = new PrismaClient({ adapter });

async function main() {
    console.log('📊 Checking Mareas data configuration...\n');

    const total = await prisma.marea.count({ where: { activo: true } });
    const conDiasEstimados = await prisma.marea.count({
        where: {
            activo: true,
            diasEstimados: { not: null }
        }
    });
    const conFechaEstimada = await prisma.marea.count({
        where: {
            activo: true,
            fechaZarpadaEstimada: { not: null }
        }
    });

    console.log(`Total mareas activas: ${total}`);
    console.log(`Con diasEstimados: ${conDiasEstimados} (${Math.round(conDiasEstimados / total * 100)}%)`);
    console.log(`Con fechaZarpadaEstimada: ${conFechaEstimada} (${Math.round(conFechaEstimada / total * 100)}%)`);

    // Check a sample
    const sample = await prisma.marea.findFirst({
        where: { activo: true },
        select: {
            nroMarea,
            diasEstimados,
            fechaZarpadaEstimada,
            buque: { select: { nombreBuque: true } }
        }
    });

    console.log(`\nSample marea:`);
    console.log(JSON.stringify(sample, null, 2));
}

main()
    .catch(console.error)
    .finally(async () => await prisma.$disconnect());
