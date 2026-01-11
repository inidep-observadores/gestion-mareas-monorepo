"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
const client_1 = require("@prisma/client");
const adapter_pg_1 = require("@prisma/adapter-pg");
const pg_1 = require("pg");
const dotenv = require("dotenv");
const path = require("path");
dotenv.config();
if (!process.env.DATABASE_URL) {
    dotenv.config({ path: path.join(process.cwd(), '.env.develop') });
}
const pool = new pg_1.Pool({ connectionString: process.env.DATABASE_URL });
const adapter = new adapter_pg_1.PrismaPg(pool);
const prisma = new client_1.PrismaClient({ adapter });
async function checkMareas() {
    const count = await prisma.marea.count({ where: { anioMarea: 2025 } });
    console.log(`Mareas 2025 en DB: ${count}`);
    if (count > 0) {
        const sample = await prisma.marea.findMany({
            where: { anioMarea: 2025 },
            take: 5,
            select: { nroMarea: true, buque: { select: { nombreBuque: true } }, tipoMarea: true }
        });
        console.log('Muestra:', sample);
    }
    await prisma.$disconnect();
}
checkMareas().catch(console.error);
//# sourceMappingURL=check-mareas.js.map