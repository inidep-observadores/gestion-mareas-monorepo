"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
const client_1 = require("@prisma/client");
const prisma = new client_1.PrismaClient();
async function main() {
    const activeMareas = await prisma.marea.findMany({
        where: {
            estadoActual: { codigo: { in: ['EN_EJECUCION', 'DESIGNADA'] } }
        },
        include: {
            buque: true,
            estadoActual: true
        }
    });
    console.log('Mareas Activas (EN_EJECUCION o DESIGNADA):');
    activeMareas.forEach(m => {
        console.log(`- Buque: ${m.buque.nombreBuque} (Matrícula: ${m.buque.matricula}), Estado: ${m.estadoActual.codigo}, Marea: ${m.nroMarea}/${m.anioMarea}`);
    });
}
main()
    .catch(e => console.error(e))
    .finally(async () => await prisma.$disconnect());
//# sourceMappingURL=check_active.js.map