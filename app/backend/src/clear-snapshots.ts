import { PrismaClient } from '@prisma/client';

async function clear() {
    const prisma = new PrismaClient();
    try {
        const count = await prisma.pnaApiSnapshot.deleteMany();
        console.log(`Eliminados ${count.count} snapshots.`);
    } catch (e) {
        console.error(e);
    } finally {
        await prisma.$disconnect();
    }
}

clear();
