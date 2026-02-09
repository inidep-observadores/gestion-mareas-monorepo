const { PrismaClient } = require('@prisma/client');
const prisma = new PrismaClient();

async function main() {
    try {
        console.log('--- Buscando Buque ---');
        const buques = await prisma.buque.findMany({
            where: {
                nombre: { contains: 'MELLINO', mode: 'insensitive' }
            }
        });
        console.log('Buques encontrados:', JSON.stringify(buques, null, 2));

        for (const buque of buques) {
            console.log(`\n--- Mareas para Buque: ${buque.nombre} (${buque.id}) ---`);
            const mareas = await prisma.marea.findMany({
                where: { buqueId: buque.id },
                include: {
                    estadoActual: true
                }
            });
            mareas.forEach(m => {
                console.log(`- Marea ID: ${m.id}, Código: ${m.codigo}, Estado: ${m.estadoActual.codigo}`);
            });

            const mc2226 = mareas.find(m => m.codigo === 'MC-22-26');
            if (mc2226) {
                console.log('\n--- Detalle Marea MC-22-26 ---');
                console.log(JSON.stringify(mc2226, null, 2));
            }
        }

    } catch (e) {
        console.error(e);
    } finally {
        await prisma.$disconnect();
    }
}

main();
