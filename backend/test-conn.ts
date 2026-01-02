import * as dotenv from 'dotenv';
import * as path from 'path';
import { PrismaClient } from '@prisma/client';

dotenv.config({ path: path.join(__dirname, '.env.develop') });

async function main() {
    const prisma = new PrismaClient();
    try {
        console.log('--- DB Connection Check ---');
        console.log('DATABASE_URL:', process.env.DATABASE_URL ? 'Loaded' : 'NOT LOADED');

        const mareaCount = await prisma.marea.count();
        const buqueCount = await prisma.buque.count();
        const stateCount = await prisma.estadoMarea.count();

        console.log('Mareas:', mareaCount);
        console.log('Buques:', buqueCount);
        console.log('Estados:', stateCount);

    } catch (e: any) {
        console.error('Connection FAIL:', e.message);
    } finally {
        await prisma.$disconnect();
    }
}

main();
