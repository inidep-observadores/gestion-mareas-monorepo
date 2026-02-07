import { PrismaClient } from '@prisma/client';

async function debug() {
    const prisma = new PrismaClient();
    try {
        console.log('--- DB DEBUG START ---');
        const count = await prisma.jobQueue.count();
        console.log('Total jobs in DB:', count);

        if (count > 0) {
            const sample = await prisma.jobQueue.findMany({ take: 5 });
            console.log('Sample Jobs:', JSON.stringify(sample, null, 2));
        }
        console.log('--- DB DEBUG END ---');
    } catch (error) {
        console.error('DB ERROR:', error);
    } finally {
        await prisma.$disconnect();
    }
}

debug();
