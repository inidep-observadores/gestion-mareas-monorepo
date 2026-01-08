-- CreateTable
CREATE TABLE "alertas" (
    "id" UUID NOT NULL,
    "codigo_unico" TEXT NOT NULL,
    "referencia_id" TEXT,
    "tipo" TEXT NOT NULL,
    "titulo" TEXT NOT NULL,
    "descripcion" TEXT NOT NULL,
    "estado" TEXT NOT NULL,
    "prioridad" TEXT NOT NULL,
    "fecha_detectada" TIMESTAMPTZ(6) NOT NULL,
    "fecha_vencimiento" TIMESTAMPTZ(6),
    "fecha_cierre" TIMESTAMPTZ(6),
    "asignado_id" UUID,
    "creado_por_id" UUID,
    "ultima_actualizacion" TIMESTAMPTZ(6) NOT NULL,

    CONSTRAINT "alertas_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "alertas_eventos" (
    "id" UUID NOT NULL,
    "alerta_id" UUID NOT NULL,
    "fecha_hora" TIMESTAMPTZ(6) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "usuario_id" UUID,
    "tipo_evento" TEXT NOT NULL,
    "detalle" TEXT,

    CONSTRAINT "alertas_eventos_pkey" PRIMARY KEY ("id")
);

-- CreateIndex
CREATE UNIQUE INDEX "alertas_codigo_unico_key" ON "alertas"("codigo_unico");

-- CreateIndex
CREATE INDEX "alertas_referencia_id_idx" ON "alertas"("referencia_id");

-- CreateIndex
CREATE INDEX "alertas_estado_idx" ON "alertas"("estado");

-- CreateIndex
CREATE INDEX "alertas_asignado_id_idx" ON "alertas"("asignado_id");

-- CreateIndex
CREATE INDEX "alertas_eventos_alerta_id_idx" ON "alertas_eventos"("alerta_id");

-- AddForeignKey
ALTER TABLE "alertas" ADD CONSTRAINT "alertas_asignado_id_fkey" FOREIGN KEY ("asignado_id") REFERENCES "users"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "alertas" ADD CONSTRAINT "alertas_creado_por_id_fkey" FOREIGN KEY ("creado_por_id") REFERENCES "users"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "alertas_eventos" ADD CONSTRAINT "alertas_eventos_alerta_id_fkey" FOREIGN KEY ("alerta_id") REFERENCES "alertas"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "alertas_eventos" ADD CONSTRAINT "alertas_eventos_usuario_id_fkey" FOREIGN KEY ("usuario_id") REFERENCES "users"("id") ON DELETE SET NULL ON UPDATE CASCADE;
