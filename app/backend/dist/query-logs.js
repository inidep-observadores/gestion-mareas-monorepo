"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
const client_1 = require("@prisma/client");
const prisma = new client_1.PrismaClient();
async function main() {
    const logs = await prisma.errorLog.findMany({
        orderBy: { timestamp: 'desc' },
        take: 10,
    });
    console.log(JSON.stringify(logs, null, 2));
}
main()
    .catch(e => {
    console.error(e);
    process.exit(1);
})
    .finally(async () => {
    await prisma.$disconnect();
});
//# sourceMappingURL=query-logs.js.map