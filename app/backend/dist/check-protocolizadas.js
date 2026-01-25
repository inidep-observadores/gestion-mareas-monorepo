"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
const dotenv = require("dotenv");
const path = require("path");
const client_1 = require("@prisma/client");
const adapter_pg_1 = require("@prisma/adapter-pg");
const pg_1 = require("pg");
dotenv.config();
function expandEnv(str) {
    if (!str)
        return str;
    return str.replace(/\${(\w+)}/g, (_, v) => process.env[v] || '');
}
if (!process.env.DATABASE_URL || process.env.DATABASE_URL.includes('${')) {
    dotenv.config({ path: path.join(process.cwd(), '.env.develop') });
}
process.env.DATABASE_URL = expandEnv(process.env.DATABASE_URL);
const pool = new pg_1.Pool({ connectionString: process.env.DATABASE_URL });
const adapter = new adapter_pg_1.PrismaPg(pool);
const prisma = new client_1.PrismaClient({ adapter });
async function main() {
    console.log('--- Mareas Protocolizadas ---');
    const mareas = await prisma.marea.findMany({
        where: {
            estadoActual: { codigo: 'PROTOCOLIZADA' },
            activo: true
        },
        select: {
            id: true,
            nroMarea: true,
            anioMarea: true,
            anioProtocolizacion: true,
            nroProtocolizacion: true,
            fechaProtocolizacion: true,
            estadoActual: { select: { nombre: true, codigo: true } }
        },
        take: 10
    });
    console.table(mareas.map(m => ({
        id: m.id,
        marea: `${m.nroMarea}/${m.anioMarea}`,
        anioProt: m.anioProtocolizacion,
        nroProt: m.nroProtocolizacion,
        fechaProt: m.fechaProtocolizacion,
        estado: m.estadoActual.codigo
    })));
    console.log('\n--- Conteo de Protocolizadas por Anio Protocolizacion ---');
    const counts = await prisma.marea.groupBy({
        by: ['anioProtocolizacion'],
        _count: { id: true },
        where: {
            estadoActual: { codigo: 'PROTOCOLIZADA' },
            activo: true
        }
    });
    console.table(counts);
    console.log('\n--- Conteo de Protocolizadas por Anio Marea ---');
    const countsMarea = await prisma.marea.groupBy({
        by: ['anioMarea'],
        _count: { id: true },
        where: {
            estadoActual: { codigo: 'PROTOCOLIZADA' },
            activo: true
        }
    });
    console.table(countsMarea);
}
main()
    .catch(e => console.error(e))
    .finally(async () => await prisma.$disconnect());
//# sourceMappingURL=check-protocolizadas.js.map