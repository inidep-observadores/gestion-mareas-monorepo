
import { PrismaClient } from '@prisma/client';
import * as dotenv from 'dotenv';
dotenv.config();

const prisma = new PrismaClient();

async function main() {
    const activeMarea = await prisma.marea.findFirst({
        where: {
            estadoActualId: 'EN_EJECUCION'
        },
        include: {
            etapas: true
        }
    });

    if (!activeMarea) {
        console.log("No active marea found.");
    } else {
        console.log("Active Marea found:", activeMarea.id, activeMarea.nroMarea);
        console.log("Stages:", JSON.stringify(activeMarea.etapas, null, 2));
    }
}

main()
    .catch((e) => {
        console.error(e);
        process.exit(1);
    })
    .finally(async () => {
        await prisma.$disconnect();
    });
