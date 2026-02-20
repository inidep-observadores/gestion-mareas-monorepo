
import { PrismaClient } from '@prisma/client';

async function checkData() {
    const prisma = new PrismaClient();
    try {
        const buquesCount = await prisma.buque.count();
        const estadosCount = await prisma.estadoMarea.count();
        const estados = await prisma.estadoMarea.findMany();
        const buques = await prisma.buque.findMany({ where: { activo: true }, take: 5 });

        console.log('Buques count:', buquesCount);
        console.log('Estados count:', estadosCount);
        console.log('Estados:', JSON.stringify(estados.map(e => e.codigo)));
        console.log('Buques activos (first 5):', JSON.stringify(buques.map(b => b.nombre)));
    } catch (e) {
        console.error(e);
    } finally {
        await prisma.$disconnect();
    }
}

checkData();
