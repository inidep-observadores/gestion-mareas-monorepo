-- CreateExtension
CREATE EXTENSION IF NOT EXISTS "pgcrypto";

-- CreateTable
CREATE TABLE IF NOT EXISTS "public"."experiencia_observadores" (
    "id" UUID NOT NULL DEFAULT gen_random_uuid(),
    "observador_id" UUID NOT NULL,
    "pesqueria_id" UUID NOT NULL,
    "tipo_flota_id" UUID NOT NULL,
    "valor" SMALLINT,
    "experiencia" INTEGER,
    "fecha_actualizacion" TIMESTAMPTZ(6) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "experiencia_observadores_pkey" PRIMARY KEY ("id")
);

-- CreateIndex
CREATE UNIQUE INDEX IF NOT EXISTS "experiencia_observadores_observador_id_pesqueria_id_tipo_flota_key" ON "public"."experiencia_observadores"("observador_id", "pesqueria_id", "tipo_flota_id");

-- AddForeignKey
DO $$
BEGIN
    IF NOT EXISTS (SELECT 1 FROM pg_constraint WHERE conname = 'experiencia_observadores_observador_id_fkey') THEN
        ALTER TABLE "public"."experiencia_observadores" ADD CONSTRAINT "experiencia_observadores_observador_id_fkey" FOREIGN KEY ("observador_id") REFERENCES "public"."observadores"("id") ON DELETE CASCADE ON UPDATE CASCADE;
    END IF;
END $$;

-- AddForeignKey
DO $$
BEGIN
    IF NOT EXISTS (SELECT 1 FROM pg_constraint WHERE conname = 'experiencia_observadores_pesqueria_id_fkey') THEN
        ALTER TABLE "public"."experiencia_observadores" ADD CONSTRAINT "experiencia_observadores_pesqueria_id_fkey" FOREIGN KEY ("pesqueria_id") REFERENCES "public"."pesquerias"("id") ON DELETE CASCADE ON UPDATE CASCADE;
    END IF;
END $$;

-- AddForeignKey
DO $$
BEGIN
    IF NOT EXISTS (SELECT 1 FROM pg_constraint WHERE conname = 'experiencia_observadores_tipo_flota_id_fkey') THEN
        ALTER TABLE "public"."experiencia_observadores" ADD CONSTRAINT "experiencia_observadores_tipo_flota_id_fkey" FOREIGN KEY ("tipo_flota_id") REFERENCES "public"."tipos_flota"("id") ON DELETE CASCADE ON UPDATE CASCADE;
    END IF;
END $$;
