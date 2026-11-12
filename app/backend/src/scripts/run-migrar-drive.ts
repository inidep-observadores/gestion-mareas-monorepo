import { NestFactory } from '@nestjs/core';
import { AppModule } from '../app.module';
import { MareasService } from '../mareas/mareas.service';

async function bootstrap() {
  console.log('Iniciando script de migración histórica de archivos locales a Drive...');
  const app = await NestFactory.createApplicationContext(AppModule);
  
  const mareasService = app.get(MareasService);
  
  try {
    const result = await mareasService.migrarInformesADrive();
    console.log('Migración iniciada con éxito. Revisa los logs de DriveSyncProcessor.');
    console.log('Resultado:', result);
  } catch (error) {
    console.error('Error al ejecutar la migración:', error);
  } finally {
    await app.close();
    process.exit(0);
  }
}

bootstrap();
