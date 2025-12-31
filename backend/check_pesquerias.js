const { PrismaClient } = require('@prisma/client');
const prisma = new PrismaClient();

async function check() {
    const pCount = await prisma.pesqueria.count();
    const eCount = await prisma.especie.count();
    console.log(`Total pesquerias in DB: ${pCount}`);
    console.log(`Total especies in DB: ${eCount}`);

    if (pCount > 0) {
        const ps = await prisma.pesqueria.findMany({ take: 5 });
        console.log('Sample pesquerias:', JSON.stringify(ps, null, 2));
    }
    if (eCount > 0) {
        const es = await prisma.especie.findMany({ take: 5 });
        console.log('Sample especies:', JSON.stringify(es, null, 2));
    }

    await prisma.$disconnect();
}

check();
