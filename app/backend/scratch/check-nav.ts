
import { NestFactory } from '@nestjs/core';
import { AppModule } from '../src/app.module';
import { PrismaService } from '../src/prisma/prisma.service';

async function checkNavLogs() {
    const app = await NestFactory.createApplicationContext(AppModule);
    const prisma = app.get(PrismaService);
    
    const events = await (prisma as any).auditoriaEvento.findMany({
        where: { timestamp: { gte: new Date('2026-04-29T00:00:00Z') } },
        orderBy: { timestamp: 'desc' },
        take: 10
    });
    console.log('Recent Event Logs:', JSON.stringify(events, null, 2));

    await app.close();
}

checkNavLogs().catch(console.error);
