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
    console.log('🔍 Checking Mareas data for progress calculation...\n');

    const mareas = await prisma.marea.findMany({
        where: {
            activo: true,
            estadoActual: {
                codigo: 'EN_EJECUCION'
            }
        },
        include: {
            estadoActual: true,
            buque: true,
            etapas: {
                orderBy: { nroEtapa: 'desc' },
                take: 1
            }
        },
        take: 5
    });

    console.log(`Found ${mareas.length} mareas in EN_EJECUCION state\n`);

    for (const marea of mareas) {
        console.log(`\n📊 Marea: ${marea.buque.nombreBuque} (${marea.nroMarea})`);
        console.log(`   Estado: ${marea.estadoActual.codigo}`);
        console.log(`   Días Estimados: ${marea.diasEstimados || 'NO CONFIGURADO'}`);
        console.log(`   Fecha Zarpada Estimada: ${marea.fechaZarpadaEstimada || 'NO CONFIGURADO'}`);
        console.log(`   Primera Etapa Fecha Zarpada: ${marea.etapas[0]?.fechaZarpada || 'NO CONFIGURADO'}`);

        if (marea.fechaZarpadaEstimada) {
            const now = new Date();
            const estimada = new Date(marea.fechaZarpadaEstimada);
            const diffTime = now.getTime() - estimada.getTime();
            const diffDays = Math.floor(diffTime / (1000 * 60 * 60 * 24)) + 1;
            console.log(`   Días transcurridos: ${diffDays}`);

            if (marea.diasEstimados && marea.diasEstimados > 0) {
                const progreso = Math.min(Math.round((diffDays / marea.diasEstimados) * 100), 100);
                console.log(`   Progreso calculado: ${progreso}%`);
            }
        }
    }
}

main()
    .catch(console.error)
    .finally(async () => await prisma.$disconnect());
