import { PrismaClient } from '@prisma/client';

const prisma = new PrismaClient();

async function main() {
    const marea = await prisma.marea.findFirst({
        where: {
            nroMarea: 98,
            buque: { nombreBuque: { contains: 'ANDRES JORGE' } }
        },
        include: {
            estadoActual: true,
            buque: true,
            etapas: { orderBy: { nroEtapa: 'asc' } },
            movimientos: {
                orderBy: { fechaHora: 'desc' },
                include: { estadoHasta: true }
            }
        },
        orderBy: { anioMarea: 'desc' }
    });

    console.log(JSON.stringify(marea, null, 2));
}

main()
    .catch(e => console.error(e))
    .finally(() => prisma.$disconnect());
