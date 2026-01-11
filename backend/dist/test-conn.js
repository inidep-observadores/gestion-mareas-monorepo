"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
const dotenv = require("dotenv");
const path = require("path");
const client_1 = require("@prisma/client");
dotenv.config({ path: path.join(__dirname, '.env.develop') });
async function main() {
    const prisma = new client_1.PrismaClient();
    try {
        console.log('--- DB Connection Check ---');
        console.log('DATABASE_URL:', process.env.DATABASE_URL ? 'Loaded' : 'NOT LOADED');
        const mareaCount = await prisma.marea.count();
        const buqueCount = await prisma.buque.count();
        const stateCount = await prisma.estadoMarea.count();
        console.log('Mareas:', mareaCount);
        console.log('Buques:', buqueCount);
        console.log('Estados:', stateCount);
    }
    catch (e) {
        console.error('Connection FAIL:', e.message);
    }
    finally {
        await prisma.$disconnect();
    }
}
main();
//# sourceMappingURL=test-conn.js.map