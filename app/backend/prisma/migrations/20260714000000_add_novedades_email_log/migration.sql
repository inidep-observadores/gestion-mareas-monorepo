-- CreateTable
CREATE TABLE "public"."novedades_email_logs" (
    "id" UUID NOT NULL,
    "messageId" TEXT,
    "asunto" TEXT,
    "remitente" TEXT,
    "fechaRecepcion" TIMESTAMPTZ(6),
    "fecha_procesamiento" TIMESTAMPTZ(6) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "estado" TEXT NOT NULL,
    "extraccion_ai" JSONB,
    "id_novedad" UUID,
    "error_detalle" TEXT,

    CONSTRAINT "novedades_email_logs_pkey" PRIMARY KEY ("id")
);

-- CreateIndex
CREATE INDEX "novedades_email_logs_estado_idx" ON "public"."novedades_email_logs"("estado");
CREATE INDEX "novedades_email_logs_fecha_procesamiento_idx" ON "public"."novedades_email_logs"("fecha_procesamiento");

-- AddForeignKey
ALTER TABLE "public"."novedades_email_logs" ADD CONSTRAINT "novedades_email_logs_id_novedad_fkey" FOREIGN KEY ("id_novedad") REFERENCES "public"."observadores_novedades"("id") ON DELETE SET NULL ON UPDATE CASCADE;
