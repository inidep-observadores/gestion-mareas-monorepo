"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
const client_1 = require("@prisma/client");
const mareas_constants_1 = require("../mareas/mareas.constants");
const prisma = new client_1.PrismaClient();
async function main() {
    const currentYear = new Date().getFullYear();
    const activeMareas = await prisma.marea.findMany({
        where: {
            activo: true,
            anioMarea: currentYear,
            estadoActual: {
                codigo: mareas_constants_1.MareaEstado.EN_EJECUCION
            }
        },
        include: {
            buque: { select: { nombreBuque: true } },
            etapas: {
                where: { fechaZarpada: { not: null } },
                include: {
                    observadores: {
                        include: {
                            observador: { select: { id: true, nombre: true, apellido: true, activo: true } }
                        }
                    }
                }
            }
        }
    });
    console.log(`Found ${activeMareas.length} mareas in execution.`);
    activeMareas.forEach(marea => {
        let observerFound = false;
        let activeObserverFound = false;
        console.log(`\nBuque: ${marea.buque.nombreBuque} (Marea #${marea.nroMarea})`);
        marea.etapas.forEach(etapa => {
            if (etapa.observadores.length > 0) {
                observerFound = true;
                etapa.observadores.forEach(obsRel => {
                    const obs = obsRel.observador;
                    console.log(`  - Obs: ${obs.nombre} ${obs.apellido} (Activo: ${obs.activo})`);
                    if (obs && obs.activo) {
                        activeObserverFound = true;
                    }
                });
            }
        });
        if (!observerFound) {
            console.error(`  [ALERTA] NO TIENE OBSERVADORES ASIGNADOS.`);
        }
        else if (!activeObserverFound) {
            console.error(`  [ALERTA] TIENE OBSERVADORES, PERO NINGUNO ESTÁ ACTIVO.`);
        }
        else {
            console.log(`  [OK] Tiene al menos un observador activo.`);
        }
    });
}
main()
    .catch(e => console.error(e))
    .finally(async () => await prisma.$disconnect());
//# sourceMappingURL=check_marea_observers.js.map