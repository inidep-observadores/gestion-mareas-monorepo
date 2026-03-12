-- Migración segura y no destructiva: agrega DAILY_BACKUP al enum JobType.
-- ADD VALUE IF NOT EXISTS evita errores si se re-aplica la migración.
ALTER TYPE "JobType" ADD VALUE IF NOT EXISTS 'DAILY_BACKUP';
