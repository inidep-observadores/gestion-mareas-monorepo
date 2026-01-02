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
    console.log('🧹 Limpiando mareas del 2025...\n');

    // Find mareas for 2025
    const mareas = await prisma.marea.findMany({
        where: { anioMarea: 2025 },
        select: { id: true }
    });

    const mareaIds = mareas.map(m => m.id);
    console.log(`Found ${mareaIds.length} mareas to delete.`);

    if (mareaIds.length === 0) {
        console.log('No mareas to delete.');
        return;
    }

    // 1. Delete MareaMovimiento
    const movs = await prisma.mareaMovimiento.deleteMany({
        where: { mareaId: { in: mareaIds } }
    });
    console.log(`Deleted ${movs.count} movimientos.`);

    // 2. Delete MareaEtapaObservador (via Etapa ids)
    // First get etapa IDs
    const etapas = await prisma.mareaEtapa.findMany({
        where: { mareaId: { in: mareaIds } },
        select: { id: true }
    });
    const etapaIds = etapas.map(e => e.id);

    if (etapaIds.length > 0) {
        const obs = await prisma.mareaEtapaObservador.deleteMany({
            where: { etapaId: { in: etapaIds } }
        });
        console.log(`Deleted ${obs.count} etapa observadores.`);

        // 3. Delete MareaEtapa
        const etapsDeleted = await prisma.mareaEtapa.deleteMany({
            where: { id: { in: etapaIds } }
        });
        console.log(`Deleted ${etapsDeleted.count} etapas.`);
    }

    // 4. Delete Marea
    const mareasDeleted = await prisma.marea.deleteMany({
        where: { id: { in: mareaIds } }
    });
    console.log(`Deleted ${mareasDeleted.count} mareas.`);

    console.log('\n✅ Cleanup complete!');
}

main()
    .catch(console.error)
    .finally(async () => await prisma.$disconnect());
