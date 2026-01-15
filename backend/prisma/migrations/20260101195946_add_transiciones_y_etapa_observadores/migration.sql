-- DropIndex
DROP INDEX "mareas_anio_marea_nro_marea_id_buque_key";

-- AlterTable
ALTER TABLE "estados_marea" ADD COLUMN     "mostrar_en_panel" BOOLEAN NOT NULL DEFAULT false;

-- AlterTable
ALTER TABLE "mareas" ADD COLUMN     "dias_estimados" INTEGER;

-- CreateTable
CREATE TABLE "mareas_etapas_observadores" (
    "id" UUID NOT NULL,
    "id_etapa" UUID NOT NULL,
    "id_observador" UUID NOT NULL,
    "rol" TEXT NOT NULL DEFAULT 'PRINCIPAL',
    "es_designado" BOOLEAN NOT NULL DEFAULT true,

    CONSTRAINT "mareas_etapas_observadores_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "transiciones_estados" (
    "id" UUID NOT NULL,
    "id_estado_origen" UUID NOT NULL,
    "id_estado_destino" UUID NOT NULL,
    "accion" TEXT NOT NULL,
    "etiqueta" TEXT NOT NULL,
    "clase_boton" TEXT,
    "requiere_observaciones" BOOLEAN NOT NULL DEFAULT false,
    "activo" BOOLEAN NOT NULL DEFAULT true,

    CONSTRAINT "transiciones_estados_pkey" PRIMARY KEY ("id")
);

-- CreateIndex
CREATE INDEX "mareas_etapas_observadores_id_etapa_idx" ON "mareas_etapas_observadores"("id_etapa");

-- CreateIndex
CREATE INDEX "mareas_etapas_observadores_id_observador_idx" ON "mareas_etapas_observadores"("id_observador");

-- CreateIndex
CREATE UNIQUE INDEX "mareas_etapas_observadores_id_etapa_id_observador_key" ON "mareas_etapas_observadores"("id_etapa", "id_observador");

-- CreateIndex
CREATE UNIQUE INDEX "transiciones_estados_id_estado_origen_id_estado_destino_acc_key" ON "transiciones_estados"("id_estado_origen", "id_estado_destino", "accion");

-- CreateIndex
CREATE UNIQUE INDEX "mareas_anio_marea_nro_marea_id_buque_tipo_marea_key" ON "mareas"("anio_marea", "nro_marea", "id_buque", "tipo_marea");

-- AddForeignKey
ALTER TABLE "mareas_etapas_observadores" ADD CONSTRAINT "mareas_etapas_observadores_id_etapa_fkey" FOREIGN KEY ("id_etapa") REFERENCES "mareas_etapas"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "mareas_etapas_observadores" ADD CONSTRAINT "mareas_etapas_observadores_id_observador_fkey" FOREIGN KEY ("id_observador") REFERENCES "observadores"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "transiciones_estados" ADD CONSTRAINT "transiciones_estados_id_estado_origen_fkey" FOREIGN KEY ("id_estado_origen") REFERENCES "estados_marea"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "transiciones_estados" ADD CONSTRAINT "transiciones_estados_id_estado_destino_fkey" FOREIGN KEY ("id_estado_destino") REFERENCES "estados_marea"("id") ON DELETE RESTRICT ON UPDATE CASCADE;
