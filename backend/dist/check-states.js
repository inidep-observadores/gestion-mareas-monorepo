"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
const client_1 = require("@prisma/client");
require("dotenv/config");
const prisma = new client_1.PrismaClient();
async function check() {
    try {
        const estados = await prisma.estadoMarea.findMany({
            orderBy: { orden: 'asc' }
        });
        console.log('Available Marea States:');
        console.table(estados);
    }
    catch (error) {
        console.error('Error querying database:', error);
    }
    finally {
        await prisma.$disconnect();
    }
}
check();
//# sourceMappingURL=check-states.js.map