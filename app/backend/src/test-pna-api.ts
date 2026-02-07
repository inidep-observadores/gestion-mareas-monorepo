import { NestFactory } from '@nestjs/core';
import { AppModule } from './app.module';
import { PnaApiService } from './pna-api/pna-api.service';
import { PrismaService } from './prisma/prisma.service';

async function bootstrap() {
    const app = await NestFactory.createApplicationContext(AppModule, { logger: ['error', 'warn', 'log'] });
    const pnaService = app.get(PnaApiService);
    const prisma = app.get(PrismaService);

    console.log('--- Iniciando Prueba de PnaApiService (con refinamiento) ---');

    try {
        // Clear snapshots for a clean test
        console.log('Limpiando snapshots previos...');
        await (prisma as any).pnaApiSnapshot.deleteMany();

        const result = await pnaService.processMovements();
        console.log('Prueba finalizada exitosamente:');
        console.log(JSON.stringify(result, null, 2));
    } catch (error) {
        console.error('Error durante la prueba:', error);
    } finally {
        await app.close();
    }
}

bootstrap();
