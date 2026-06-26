import { NestFactory } from '@nestjs/core';
import { AppModule } from './src/app.module';
import { NovedadesEmailProcessor } from './src/jobs/processors/novedades-email.processor';

async function bootstrap() {
  console.log('Inicializando contexto de NestJS para prueba...');
  const app = await NestFactory.createApplicationContext(AppModule);
  const processor = app.get(NovedadesEmailProcessor);
  
  console.log('Iniciando procesamiento de prueba...');
  try {
      const result = await processor.process({});
      console.log('\n✅ Resultado final:', result);
  } catch (e) {
      console.error('\n❌ Excepción principal:', e);
  }
  await app.close();
}
bootstrap();
