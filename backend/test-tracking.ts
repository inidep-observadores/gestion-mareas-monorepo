
import { NestFactory } from '@nestjs/core';
import { AppModule } from './src/app.module';
import { TrackingService } from './src/mareas/tracking.service';
import * as fs from 'fs';
import * as path from 'path';

async function bootstrap() {
    const app = await NestFactory.createApplicationContext(AppModule);
    const trackingService = app.get(TrackingService);

    const csvPath = path.join(__dirname, 'old_data', 'tack_miss_tide.csv');
    console.log(`Leyendo archivo: ${csvPath}`);

    if (!fs.existsSync(csvPath)) {
        console.error('El archivo no existe.');
        process.exit(1);
    }

    const fileBuffer = fs.readFileSync(csvPath);

    try {
        console.log('Iniciando importación...');
        const result = await trackingService.importTrackingData(fileBuffer);
        console.log('Resultado:', result);

        // Aquí podríamos consultar la DB para ver si se crearon alertas
        // const prisma = app.get(PrismaService);
        // const alerts = await prisma.alerta.findMany({...})

    } catch (error) {
        console.error('Error durante la importación:', error);
    } finally {
        await app.close();
    }
}

bootstrap();
