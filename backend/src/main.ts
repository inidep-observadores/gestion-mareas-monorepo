import { NestFactory } from '@nestjs/core';
import { ValidationPipe, Logger } from '@nestjs/common';
import { AppModule } from './app.module';

import * as cookieParser from 'cookie-parser';

async function bootstrap() {
  const app = await NestFactory.create(AppModule);
  const logger = new Logger('Bootstrap');
  console.log('>>> BACKEND STARTING - Build ID: ' + new Date().toISOString());

  app.setGlobalPrefix('api');

  app.useGlobalPipes(
    new ValidationPipe({
      whitelist: true,
      forbidNonWhitelisted: true,
      transform: true,
    })
  );

  app.use(cookieParser());

  const frontendUrl = process.env.FRONTEND_URL;
  const envOrigins = frontendUrl ? frontendUrl.split(',').map(o => o.trim().replace(/\/$/, '')) : [];

  const origins = [
    'http://localhost:5173',
    'http://127.0.0.1:5173',
    'http://localhost:5174',
    'http://127.0.0.1:5174',
    'https://mareas-obs.netlify.app',
    ...envOrigins
  ];

  // Limpiar posibles rutas en los orígenes para que sean orígenes puros (protocolo + dominio + puerto)
  const cleanOrigins = origins.map(url => {
    try {
      const parsed = new URL(url);
      return `${parsed.protocol}//${parsed.host}`;
    } catch {
      return url;
    }
  });

  app.enableCors({
    origin: cleanOrigins,
    credentials: true,
  });


  await app.listen(process.env.PORT || 3000);
  logger.log(`App running on port ${process.env.PORT || 3000}`);
}
bootstrap();
