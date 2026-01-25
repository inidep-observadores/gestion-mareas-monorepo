"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
const client_1 = require("@prisma/client");
const prisma = new client_1.PrismaClient();
async function main() {
    const sample = await prisma.buque.findFirst({
        where: {
            esloraM: { not: null }
        },
        select: {
            nombreBuque: true,
            matricula: true,
            esloraM: true,
            potenciaHp: true
        }
    });
    console.log('Sample Vessel with technical data:');
    console.log(JSON.stringify(sample, null, 2));
    const totalWithData = await prisma.buque.count({
        where: {
            OR: [
                { esloraM: { not: null } },
                { potenciaHp: { not: null } }
            ]
        }
    });
    console.log(`Total vessels with technical specifications: ${totalWithData}`);
}
main()
    .catch(e => console.error(e))
    .finally(async () => await prisma.$disconnect());
//# sourceMappingURL=verify_specs.js.map