import { PrismaClient } from '@prisma/client';
import { TipoMarea } from './src/mareas/mareas.constants';

const prisma = new PrismaClient();

async function main() {
    const mareaCode = 'MC-171-25';
    console.log(`Checking marea ${mareaCode}...`);

    const marea = await prisma.marea.findFirst({
        where: {
            nroMarea: 171,
            anioMarea: 25, // Assuming 25 is stored as 25 or 2025
            tipoMarea: TipoMarea.MC
        },
        include: {
            observadorPrincipal: true,
            etapas: {
                include: {
                    observadores: {
                        include: { observador: true }
                    }
                }
            }
        }
    });

    if (!marea) {
        // Try with 2025
        console.log('Not found with 25, trying with 2025...');
        const marea2 = await prisma.marea.findFirst({
            where: {
                nroMarea: 171,
                anioMarea: 2025,
                tipoMarea: TipoMarea.MC
            },
            include: {
                observadorPrincipal: true,
                etapas: {
                    include: {
                        observadores: {
                            include: { observador: true }
                        }
                    }
                }
            }
        });
        if (!marea2) {
            console.log('Marea not found in DB.');
            return;
        }
        printMarea(marea2);
    } else {
        printMarea(marea);
    }
}

function printMarea(marea: any) {
    console.log('Marea ID:', marea.id);
    console.log('Observador Principal:', marea.observadorPrincipal ? `${marea.observadorPrincipal.nombre} ${marea.observadorPrincipal.apellido}` : 'NULL');
    console.log('Observador Principal ID:', marea.observadorPrincipalId);

    console.log('Etapas:', marea.etapas.length);
    marea.etapas.forEach((e: any) => {
        console.log(`  Etapa ${e.nroEtapa}: ${e.observadores.length} observadores`);
        e.observadores.forEach((o: any) => {
            console.log(`    - ${o.observador.nombre} ${o.observador.apellido} (${o.rol})`);
        });
    });
}

main()
    .catch(e => console.error(e))
    .finally(async () => await prisma.$disconnect());
