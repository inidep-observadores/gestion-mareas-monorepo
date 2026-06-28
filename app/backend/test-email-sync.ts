import { NestFactory } from '@nestjs/core';
import { AppModule } from './src/app.module';
import { NovedadesEmailProcessor } from './src/jobs/processors/novedades-email.processor';
import * as dotenv from 'dotenv';
import { join } from 'path';

dotenv.config({ path: join(process.cwd(), '.env') });

async function bootstrap() {
  console.log('Inicializando NestJS Application Context...');
  const app = await NestFactory.createApplicationContext(AppModule);
  
  try {
    const processor = app.get(NovedadesEmailProcessor);
    
    console.log('Ejecutando el procesador de emails (NovedadesEmailProcessor)...');
    const result = await processor.process({});
    
    console.log('\n--- RESUMEN DE PROCESAMIENTO ---');
    console.log(`Total Emails Encontrados: ${result.total}`);
    console.log(`Procesados (Novedad Creada): ${result.processed}`);
    console.log(`Ignorados (Sin observador/tipo valido): ${result.ignored}`);
    console.log(`Errores: ${result.errors}`);
    console.log('--------------------------------\n');
    
  } catch (error) {
    console.error('Error durante el procesamiento:', error);
  } finally {
    await app.close();
    console.log('Contexto de NestJS cerrado.');
  }
}

bootstrap();
