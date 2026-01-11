"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
const client_1 = require("@prisma/client");
const prisma = new client_1.PrismaClient();
async function main() {
    const alerts = await prisma.alerta.findMany({
        select: {
            id: true,
            titulo: true,
            estado: true,
            prioridad: true,
            fechaDetectada: true,
            fechaCierre: true
        }
    });
    console.log('ALERTAS EN BD:');
    console.log(JSON.stringify(alerts, null, 2));
    const events = await prisma.alertaEvento.findMany({
        include: {
            alerta: { select: { titulo: true } }
        },
        orderBy: { fechaHora: 'desc' },
        take: 10
    });
    console.log('\nÚLTIMOS EVENTOS:');
    console.log(JSON.stringify(events, null, 2));
}
main()
    .catch((e) => {
    console.error(e);
    process.exit(1);
})
    .finally(async () => {
    await prisma.$disconnect();
});
//# sourceMappingURL=check-alerts.js.map