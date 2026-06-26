-- CreateTable
CREATE TABLE "observadores_novedades_movimientos" (
    "id" UUID NOT NULL,
    "id_novedad" UUID NOT NULL,
    "fecha_hora" TIMESTAMPTZ(6) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "id_usuario" UUID,
    "tipo_evento" TEXT NOT NULL,
    "estado_anterior" TEXT,
    "estado_nuevo" TEXT,
    "comentarios" TEXT,

    CONSTRAINT "observadores_novedades_movimientos_pkey" PRIMARY KEY ("id")
);

-- CreateIndex
CREATE INDEX "observadores_novedades_movimientos_id_novedad_idx" ON "observadores_novedades_movimientos"("id_novedad");

-- AddForeignKey
ALTER TABLE "observadores_novedades_movimientos" ADD CONSTRAINT "observadores_novedades_movimientos_id_novedad_fkey" FOREIGN KEY ("id_novedad") REFERENCES "observadores_novedades"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "observadores_novedades_movimientos" ADD CONSTRAINT "observadores_novedades_movimientos_id_usuario_fkey" FOREIGN KEY ("id_usuario") REFERENCES "users"("id") ON DELETE SET NULL ON UPDATE CASCADE;
