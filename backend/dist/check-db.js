"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
const client_1 = require("@prisma/client");
const prisma = new client_1.PrismaClient();
async function main() {
    const count = await prisma.buque.count();
    console.log(`Buques count: ${count}`);
    const mareas = await prisma.marea.count();
    console.log(`Mareas count: ${mareas}`);
}
main()
    .catch(e => console.error(e))
    .finally(async () => await prisma.$disconnect());
//# sourceMappingURL=check-db.js.map