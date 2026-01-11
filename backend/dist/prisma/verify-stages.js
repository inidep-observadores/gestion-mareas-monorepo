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
async function verify() {
    const totalMareas = await prisma.marea.count({ where: { anioMarea: 2025 } });
    console.log(`Total mareas 2025: ${totalMareas}`);
    const canceladas = await prisma.marea.findMany({
        where: {
            anioMarea: 2025,
            estadoActual: { codigo: 'CANCELADA' }
        },
        include: { etapas: true }
    });
    console.log(`\nMareas CANCELADAS: ${canceladas.length}`);
    const canceladasConEtapas = canceladas.filter(m => m.etapas.length > 0);
    console.log(`  - Con etapas (debería ser 0): ${canceladasConEtapas.length}`);
    if (canceladasConEtapas.length > 0) {
        console.log(`  ERROR: Mareas canceladas con etapas:`, canceladasConEtapas.map(m => m.nroMarea));
    }
    const activas = await prisma.marea.findMany({
        where: {
            anioMarea: 2025,
            estadoActual: { codigo: { not: 'CANCELADA' } }
        },
        include: { etapas: true }
    });
    console.log(`\nMareas ACTIVAS (no canceladas): ${activas.length}`);
    const sinEtapas = activas.filter(m => m.etapas.length === 0);
    console.log(`  - Sin etapas (debería ser 0): ${sinEtapas.length}`);
    if (sinEtapas.length > 0) {
        console.log(`  ERROR: Mareas activas sin etapas:`, sinEtapas.slice(0, 5).map(m => m.nroMarea));
    }
    const conUnaEtapa = activas.filter(m => m.etapas.length === 1);
    console.log(`  - Con 1 etapa (default): ${conUnaEtapa.length}`);
    const conVariasEtapas = activas.filter(m => m.etapas.length > 1);
    console.log(`  - Con múltiples etapas: ${conVariasEtapas.length}`);
    const etapasDefault = await prisma.mareaEtapa.findMany({
        where: { observaciones: { contains: 'generada automáticamente' } },
        take: 3,
        include: { marea: { select: { nroMarea: true } } }
    });
    console.log(`\nEtapas generadas automáticamente (sample):`, etapasDefault.map(e => `Marea ${e.marea.nroMarea}, Etapa ${e.nroEtapa}`));
    await prisma.$disconnect();
}
verify().catch(console.error);
//# sourceMappingURL=verify-stages.js.map