import { NestFactory } from '@nestjs/core';
import { ValidationPipe, Logger } from '@nestjs/common';
import { AppModule } from './app.module';

import * as cookieParser from 'cookie-parser';
import { json, urlencoded } from 'express';

async function bootstrap() {
  const app = await NestFactory.create(AppModule);
  
  // Aumentar límites de payload para matrices grandes
  app.use(json({ limit: '10mb' }));
  app.use(urlencoded({ extended: true, limit: '10mb' }));

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
  const rawOrigins = [
    'http://localhost:5173',
    'http://127.0.0.1:5173',
    'http://localhost:5174',
    'http://127.0.0.1:5174',
    'https://mareas-obs.netlify.app',
  ];

  if (frontendUrl) {
    frontendUrl.split(',').forEach(url => {
      const trimmed = url.trim();
      if (trimmed) rawOrigins.push(trimmed);
    });
  }

  // Limpiar orígenes: quitar barra final y espacios
  const cleanOrigins = [...new Set(rawOrigins.map(url => url.replace(/\/$/, '')))];

  logger.log(`CORS enabled for origins: ${cleanOrigins.join(', ')}`);

  app.enableCors({
    origin: cleanOrigins,
    credentials: true,
    methods: 'GET,HEAD,PUT,PATCH,POST,DELETE,OPTIONS',
    allowedHeaders: 'Content-Type, Accept, Authorization',
    exposedHeaders: ['Content-Disposition'],
  });


  await app.listen(process.env.PORT || 3000);
  logger.log(`App running on port ${process.env.PORT || 3000}`);
}

bootstrap().catch(err => {
  console.error('CRITICAL ERROR DURING BOOTSTRAP:', err);
  process.exit(1);
});
