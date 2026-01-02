import { PrismaClient } from '@prisma/client';
import { PrismaPg } from '@prisma/adapter-pg';
import { Pool } from 'pg';
import * as dotenv from 'dotenv';
import * as path from 'path';

dotenv.config();
if (!process.env.DATABASE_URL) {
    dotenv.config({ path: path.join(process.cwd(), '.env.develop') });
}

const pool = new Pool({ connectionString: process.env.DATABASE_URL });
const adapter = new PrismaPg(pool);
const prisma = new PrismaClient({ adapter });

async function checkMareas() {
    const count = await prisma.marea.count({ where: { anioMarea: 2025 } });
    console.log(`Mareas 2025 en DB: ${count}`);

    if (count > 0) {
        const sample = await prisma.marea.findMany({
            where: { anioMarea: 2025 },
            take: 5,
            select: { nroMarea: true, buque: { select: { nombreBuque: true } }, tipoMarea: true }
        });
        console.log('Muestra:', sample);
    }

    await prisma.$disconnect();
}

checkMareas().catch(console.error);
