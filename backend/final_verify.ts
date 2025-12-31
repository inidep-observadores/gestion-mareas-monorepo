import { PrismaClient } from '@prisma/client';

async function verify() {
    const prisma = new PrismaClient();
    const count = await prisma.artePesca.count();
    const sample = await prisma.artePesca.findFirst();
    const buqueCount = await prisma.buque.count();
    console.log(`Artes de Pesca: ${count}`);
    console.log(`Sample: ${sample?.nombre}`);
    console.log(`Buques: ${buqueCount}`);
    await prisma.$disconnect();
}

verify();
