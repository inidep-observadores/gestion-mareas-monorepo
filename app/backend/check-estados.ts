
import { PrismaClient } from '@prisma/client';

const prisma = new PrismaClient();

async function main() {
    console.log('--- Estados de Marea ---');
    const estados = await prisma.estadoMarea.findMany({
        orderBy: { orden: 'asc' }
    });

    console.table(estados.map(e => ({
        codigo: e.codigo,
        nombre: e.nombre,
        mostrarEnPanel: e.mostrarEnPanel,
        activo: e.activo
    })));

    console.log('\n--- Conteo de Mareas por Estado ---');
    const counts = await prisma.marea.groupBy({
        by: ['estadoActualId'],
        _count: { id: true },
        where: { activo: true }
    });

    const estadosMap = new Map(estados.map(e => [e.id, e]));

    counts.forEach(c => {
        const estado = estadosMap.get(c.estadoActualId);
        console.log(`${estado?.nombre || 'Desconocido'} (${estado?.codigo || c.estadoActualId}): ${c._count.id}`);
    });
}

main()
    .catch(e => console.error(e))
    .finally(async () => await prisma.$disconnect());
