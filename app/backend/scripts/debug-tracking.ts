import { PrismaClient } from '@prisma/client';

const prisma = new PrismaClient();

async function main() {
    const vesselName = 'LU QING YUAN YU 277';
    console.log(`Checking tracking for: ${vesselName}`);

    const vessel = await prisma.buque.findFirst({
        where: { nombreBuque: { contains: vesselName, mode: 'insensitive' } },
        include: {
            mareas: {
                where: { estadoActual: { codigo: 'DESIGNADA' } },
                include: { estadoActual: true }
            }
        }
    });

    if (!vessel) {
        console.log('Buque no encontrado');
        return;
    }

    console.log(`Buque ID: ${vessel.id}, Matricula: ${vessel.matricula}`);
    console.log(`Mareas DESIGNADAS: ${vessel.mareas.length}`);

    const trajectory = await prisma.buqueTrayectoria.findUnique({
        where: { buqueId: vessel.id }
    });

    if (!trajectory) {
        console.log('Sin registro de trayectoria (BuqueTrayectoria)');
    } else {
        const count = await prisma.buqueTrayectoriaPunto.count({
            where: { trayectoriaId: trajectory.id }
        });
        const lastPoint = await prisma.buqueTrayectoriaPunto.findFirst({
            where: { trayectoriaId: trajectory.id },
            orderBy: { timestamp: 'desc' }
        });

        console.log(`Total puntos: ${count}`);
        if (lastPoint) {
            console.log(`Ultimo punto: ${lastPoint.timestamp.toISOString()} (${lastPoint.lat}, ${lastPoint.lon})`);
        }
    }
}

main()
    .catch(e => {
        console.error(e);
        process.exit(1);
    })
    .finally(async () => {
        await prisma.$disconnect();
    });
