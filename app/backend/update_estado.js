require('dotenv').config();
const { PrismaClient } = require('@prisma/client');
const prisma = new PrismaClient();

async function main() {
    await prisma.$executeRawUnsafe(`UPDATE "public"."estados_marea" SET "mostrar_en_panel" = true WHERE "codigo" = 'A_REASIGNAR';`);
    console.log("Estado A_REASIGNAR actualizado para mostrar_en_panel = true");
}

main()
    .then(async () => {
        await prisma.$disconnect()
    })
    .catch(async (e) => {
        console.error(e)
        await prisma.$disconnect()
        process.exit(1)
    })
