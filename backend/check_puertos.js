const { PrismaClient } = require('@prisma/client');
const prisma = new PrismaClient();

async function check() {
    const count = await prisma.puerto.count();
    console.log(`Total puertos in DB: ${count}`);
    await prisma.$disconnect();
}

check();
