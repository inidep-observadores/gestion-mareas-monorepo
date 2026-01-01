import { PrismaClient } from '@prisma/client';
import 'dotenv/config';

const prisma = new PrismaClient();

async function check() {
    try {
        const estados = await prisma.estadoMarea.findMany({
            orderBy: { orden: 'asc' }
        });
        console.log('Available Marea States:');
        console.table(estados);
    } catch (error) {
        console.error('Error querying database:', error);
    } finally {
        await prisma.$disconnect();
    }
}

check();
