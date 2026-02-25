const { PrismaClient } = require('@prisma/client');
const prisma = new PrismaClient();

async function main() {
    try {
        const total = await prisma.jobQueue.count();
        console.log('TOTAL_RECORDS:' + total);

        const jobs = await prisma.jobQueue.findMany({
            take: 10,
            orderBy: { createdAt: 'desc' }
        });

        console.log('JOBS_JSON:' + JSON.stringify(jobs));
    } catch (err) {
        console.error('DB_ERROR:' + err.message);
    } finally {
        await prisma.$disconnect();
    }
}

main();
