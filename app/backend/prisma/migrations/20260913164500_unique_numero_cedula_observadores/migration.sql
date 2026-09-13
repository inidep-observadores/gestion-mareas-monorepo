-- CreateIndex: Asegurar unicidad de numero_cedula de forma segura y no destructiva
CREATE UNIQUE INDEX IF NOT EXISTS "observadores_numero_cedula_key" ON "public"."observadores"("numero_cedula");
