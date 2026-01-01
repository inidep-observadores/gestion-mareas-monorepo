
import { PrismaClient } from '@prisma/client';
const prisma = new PrismaClient();
async function main() {
    const count = await prisma.buque.count();
    console.log(`Buques count: ${count}`);
    const mareas = await prisma.marea.count();
    console.log(`Mareas count: ${mareas}`);
}
main()
    .catch(e => console.error(e))
    .finally(async () => await prisma.$disconnect());

