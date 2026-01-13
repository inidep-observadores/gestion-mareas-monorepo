const { PrismaClient } = require('@prisma/client');
const prisma = new PrismaClient();

async function main() {
  try {
    const logs = await prisma.errorLog.findMany({
      orderBy: { timestamp: 'desc' },
      take: 20,
    });
    console.log(JSON.stringify(logs, null, 2));
  } catch (err) {
    console.error('Error querying logs:', err);
  } finally {
    await prisma.$disconnect();
  }
}

main();
