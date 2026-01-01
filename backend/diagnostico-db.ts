import { PrismaClient } from '@prisma/client';

async function main() {
    const prisma = new PrismaClient();
    try {
        console.log('--- Diagnóstico de Base de Datos ---');
        const countBefore = await prisma.marea.count();
        console.log(`Mareas actuales: ${countBefore}`);

        const buque = await prisma.buque.findFirst();
        const estado = await prisma.estadoMarea.findFirst();

        if (!buque || !estado) {
            console.error('ERROR: No se encontraron catálogos base (buques o estados).');
            return;
        }

        console.log('Intentando insertar marea de prueba...');
        const marea = await prisma.marea.create({
            data: {
                anioMarea: 2025,
                nroMarea: 9991,
                tipoMarea: 'MC',
                buqueId: buque.id,
                estadoActualId: estado.id,
                observaciones: 'PRUEBA DE CONEXION'
            }
        });
        console.log('¡Marea insertada con éxito! ID:', marea.id);

        const countAfter = await prisma.marea.count();
        console.log(`Mareas después de inserción: ${countAfter}`);

        // No la borramos para que el usuario pueda verla en Prisma Studio si quiere
        console.log('Marea de prueba persistida.');

    } catch (error) {
        console.error('ERROR DURANTE LA INSERCION:', error);
    } finally {
        await prisma.$disconnect();
    }
}

main();
