"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
const client_1 = require("@prisma/client");
const mareas_constants_1 = require("./src/mareas/mareas.constants");
const prisma = new client_1.PrismaClient();
async function main() {
    const mareaCode = 'MC-171-25';
    console.log(`Checking marea ${mareaCode}...`);
    const marea = await prisma.marea.findFirst({
        where: {
            nroMarea: 171,
            anioMarea: 25,
            tipoMarea: mareas_constants_1.TipoMarea.MC
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
        console.log('Not found with 25, trying with 2025...');
        const marea2 = await prisma.marea.findFirst({
            where: {
                nroMarea: 171,
                anioMarea: 2025,
                tipoMarea: mareas_constants_1.TipoMarea.MC
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
    }
    else {
        printMarea(marea);
    }
}
function printMarea(marea) {
    console.log('Marea ID:', marea.id);
    console.log('Observador Principal:', marea.observadorPrincipal ? `${marea.observadorPrincipal.nombre} ${marea.observadorPrincipal.apellido}` : 'NULL');
    console.log('Observador Principal ID:', marea.observadorPrincipalId);
    console.log('Etapas:', marea.etapas.length);
    marea.etapas.forEach((e) => {
        console.log(`  Etapa ${e.nroEtapa}: ${e.observadores.length} observadores`);
        e.observadores.forEach((o) => {
            console.log(`    - ${o.observador.nombre} ${o.observador.apellido} (${o.rol})`);
        });
    });
}
main()
    .catch(e => console.error(e))
    .finally(async () => await prisma.$disconnect());
//# sourceMappingURL=check-marea-data.js.map