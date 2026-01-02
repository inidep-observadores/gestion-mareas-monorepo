import * as dotenv from 'dotenv';
import * as path from 'path';

dotenv.config();
if (!process.env.DATABASE_URL) {
    dotenv.config({ path: path.join(process.cwd(), '.env.develop') });
}

import { PrismaClient } from '@prisma/client';
import { PrismaPg } from '@prisma/adapter-pg';
import { Pool } from 'pg';

const pool = new Pool({ connectionString: process.env.DATABASE_URL });
const adapter = new PrismaPg(pool);
const prisma = new PrismaClient({ adapter });

async function main() {
    console.log('🔍 Validating Mareas Data...\n');

    // Check TANGO II (En Ejecución)
    const tango = await prisma.marea.findFirst({
        where: { nroMarea: 196, anioMarea: 2025 },
        include: { estadoActual: true, etapas: true }
    });

    if (tango) {
        console.log(`[MC-196-25] ${tango.buqueId} - Estado: ${tango.estadoActual.codigo}`);
        console.log(`  Fecha Zarpada Estimada: ${tango.fechaZarpadaEstimada}`);
        console.log(`  Dias Estimados: ${tango.diasEstimados}`);
        console.log(`  Etapas (${tango.etapas.length}):`);
        tango.etapas.forEach(e => {
            console.log(`    Nro: ${e.nroEtapa}, Zarpada: ${e.fechaZarpada}, Arribo: ${e.fechaArribo}`);
        });
    }

    // Check VALERIA DEL ATLANTICO (With Zona Austral)
    const valeria = await prisma.marea.findFirst({
        where: { nroMarea: 1, anioMarea: 2025 }
    });

    if (valeria) {
        console.log(`\n[MC-1-25] ${valeria.buqueId}`);
        console.log(`  Dias Zona Austral: ${valeria.diasZonaAustral} (Expected: 32)`);
        console.log(`  Dias Estimados: ${valeria.diasEstimados}`);
    }
}

main()
    .catch(console.error)
    .finally(async () => await prisma.$disconnect());
