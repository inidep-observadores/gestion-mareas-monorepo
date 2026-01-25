/*
  Warnings:

  - You are about to drop the column `especieId` on the `observador_pesquerias` table. All the data in the column will be lost.
  - Added the required column `id_especie` to the `observador_pesquerias` table without a default value. This is not possible if the table is not empty.

*/
-- DropForeignKey
ALTER TABLE "observador_pesquerias" DROP CONSTRAINT "observador_pesquerias_especieId_fkey";

-- AlterTable
ALTER TABLE "observador_pesquerias" DROP COLUMN "especieId",
ADD COLUMN     "id_especie" UUID NOT NULL;

-- AlterTable
ALTER TABLE "users" ALTER COLUMN "roles" SET DEFAULT ARRAY['invitado']::TEXT[];

-- CreateTable
CREATE TABLE "mareas" (
    "id" UUID NOT NULL,
    "anio_marea" INTEGER NOT NULL,
    "nro_marea" INTEGER NOT NULL,
    "id_buque" UUID NOT NULL,
    "id_arte_principal" UUID,
    "id_estado_actual" UUID NOT NULL,
    "fecha_zarpada_estimada" TIMESTAMPTZ,
    "fecha_inicio_observador" TIMESTAMPTZ,
    "fecha_fin_observador" TIMESTAMPTZ,
    "dias_zona_austral" INTEGER,
    "tipo_calculo_zona_austral" TEXT NOT NULL DEFAULT 'AUTOMATICO',
    "titulo" TEXT,
    "descripcion" TEXT,
    "nro_protocolizacion" INTEGER,
    "anio_protocolizacion" INTEGER,
    "fecha_protocolizacion" TIMESTAMPTZ,
    "fecha_creacion" TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "fecha_ultima_actualizacion" TIMESTAMPTZ NOT NULL,
    "activo" BOOLEAN NOT NULL DEFAULT true,
    "observaciones" TEXT,

    CONSTRAINT "mareas_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "mareas_etapas" (
    "id" UUID NOT NULL,
    "id_marea" UUID NOT NULL,
    "nro_etapa" INTEGER NOT NULL,
    "id_pesqueria" UUID,
    "id_puerto_zarpada" UUID,
    "id_puerto_arribo" UUID,
    "fecha_zarpada" TIMESTAMPTZ,
    "fecha_arribo" TIMESTAMPTZ,
    "tipo_etapa" TEXT NOT NULL,
    "observaciones" TEXT,

    CONSTRAINT "mareas_etapas_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "mareas_movimientos" (
    "id" UUID NOT NULL,
    "id_marea" UUID NOT NULL,
    "fecha_hora" TIMESTAMPTZ NOT NULL,
    "id_usuario" UUID,
    "tipo_evento" TEXT NOT NULL,
    "id_estado_desde" UUID,
    "id_estado_hasta" UUID,
    "cantidad_muestras_otolitos" INTEGER,
    "detalle" TEXT,

    CONSTRAINT "mareas_movimientos_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "mareas_archivos" (
    "id" UUID NOT NULL,
    "id_marea" UUID NOT NULL,
    "id_movimiento_origen" UUID,
    "tipo_archivo" TEXT NOT NULL,
    "formato" TEXT,
    "version" TEXT,
    "ruta_archivo" TEXT NOT NULL,
    "fecha_subida" TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "id_usuario_subio" UUID,
    "descripcion" TEXT,

    CONSTRAINT "mareas_archivos_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "lances" (
    "id" UUID NOT NULL,
    "etapa_id" UUID NOT NULL,
    "numero_lance" INTEGER NOT NULL,
    "fecha" DATE NOT NULL,
    "cod_arte_pesca" INTEGER NOT NULL,
    "tipo_arte_pesca" INTEGER,
    "hora_inicio" DOUBLE PRECISION,
    "lat_inicio" DOUBLE PRECISION,
    "long_inicio" DOUBLE PRECISION,
    "prof_inicio" INTEGER,
    "hora_final" DOUBLE PRECISION,
    "lat_final" DOUBLE PRECISION,
    "long_final" DOUBLE PRECISION,
    "prof_final" INTEGER,
    "rumbo" INTEGER,
    "distancia_red" DOUBLE PRECISION,
    "velocidad_arrastre" DOUBLE PRECISION,
    "tiempo_red" INTEGER,
    "estacion_gral" INTEGER,
    "calador" TEXT,
    "fondo_min" INTEGER,
    "fondo_max" INTEGER,
    "tamiz" TEXT,
    "area_barrida" DOUBLE PRECISION,
    "captura_total_kg" DOUBLE PRECISION,
    "descarte_total_kg" DOUBLE PRECISION,
    "observaciones_lance" TEXT,
    "mus" INTEGER,
    "fuente_dato" INTEGER,

    CONSTRAINT "lances_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "capturas" (
    "id" UUID NOT NULL,
    "lance_id" UUID NOT NULL,
    "especie_id" UUID NOT NULL,
    "kg_captura" DOUBLE PRECISION NOT NULL,
    "kg_descarte" DOUBLE PRECISION NOT NULL,
    "observaciones_captura" TEXT,
    "indice_original" INTEGER NOT NULL,

    CONSTRAINT "capturas_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "muestras" (
    "id" UUID NOT NULL,
    "lance_id" UUID NOT NULL,
    "especie_id" UUID NOT NULL,
    "tipo_muestra" TEXT NOT NULL,
    "peso_muestra_kg" DOUBLE PRECISION,
    "fact_ponderacion" DOUBLE PRECISION,
    "unidad_largo" TEXT NOT NULL,
    "primera_talla" INTEGER,
    "ultima_talla" INTEGER,
    "intervalo_mm" INTEGER,
    "total_mediciones" INTEGER,
    "observaciones" TEXT,

    CONSTRAINT "muestras_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "muestras_detalle_talla" (
    "id" UUID NOT NULL,
    "muestra_id" UUID NOT NULL,
    "talla_mm" INTEGER NOT NULL,
    "cantidad_machos" INTEGER NOT NULL,
    "cantidad_hembras" INTEGER NOT NULL,
    "cantidad_indet" INTEGER NOT NULL,
    "cantidad_total" INTEGER NOT NULL,
    "indice_original" INTEGER NOT NULL,

    CONSTRAINT "muestras_detalle_talla_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "submuestras" (
    "id" UUID NOT NULL,
    "muestra_id" UUID NOT NULL,
    "numero_ejemplar" INTEGER NOT NULL,
    "largo_total" INTEGER,
    "largo_estandar" INTEGER,
    "peso_total_g" DOUBLE PRECISION,
    "peso_gonadas_g" DOUBLE PRECISION,
    "sexo" INTEGER,
    "estadio_madurez" INTEGER,
    "replecion" INTEGER,
    "contenido_estomacal" TEXT,
    "observaciones_ejemplar" TEXT,

    CONSTRAINT "submuestras_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "producciones" (
    "id" UUID NOT NULL,
    "marea_id" UUID NOT NULL,
    "especie_id" UUID NOT NULL,
    "fecha" DATE NOT NULL,
    "producto" TEXT,
    "categoria" TEXT,
    "factor_conversion" DOUBLE PRECISION,
    "kg_produccion" DOUBLE PRECISION NOT NULL,
    "operarios" INTEGER,

    CONSTRAINT "producciones_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "buque_trayectorias" (
    "id" UUID NOT NULL,
    "buque_id" UUID NOT NULL,
    "origen" TEXT,
    "metadata" JSONB,

    CONSTRAINT "buque_trayectorias_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "buque_trayectoria_puntos" (
    "id" UUID NOT NULL,
    "trayectoria_id" UUID NOT NULL,
    "buque_id" UUID NOT NULL,
    "timestamp" TIMESTAMPTZ NOT NULL,
    "lat" DOUBLE PRECISION NOT NULL,
    "lon" DOUBLE PRECISION NOT NULL,
    "velocidad" DOUBLE PRECISION,
    "rumbo" INTEGER,

    CONSTRAINT "buque_trayectoria_puntos_pkey" PRIMARY KEY ("id")
);

-- CreateIndex
CREATE UNIQUE INDEX "mareas_anio_marea_nro_marea_id_buque_key" ON "mareas"("anio_marea", "nro_marea", "id_buque");

-- CreateIndex
CREATE INDEX "mareas_etapas_id_marea_idx" ON "mareas_etapas"("id_marea");

-- CreateIndex
CREATE UNIQUE INDEX "mareas_etapas_id_marea_nro_etapa_key" ON "mareas_etapas"("id_marea", "nro_etapa");

-- CreateIndex
CREATE INDEX "mareas_movimientos_id_marea_idx" ON "mareas_movimientos"("id_marea");

-- CreateIndex
CREATE INDEX "mareas_archivos_id_marea_idx" ON "mareas_archivos"("id_marea");

-- CreateIndex
CREATE INDEX "lances_etapa_id_idx" ON "lances"("etapa_id");

-- CreateIndex
CREATE UNIQUE INDEX "lances_etapa_id_numero_lance_key" ON "lances"("etapa_id", "numero_lance");

-- CreateIndex
CREATE INDEX "capturas_lance_id_idx" ON "capturas"("lance_id");

-- CreateIndex
CREATE UNIQUE INDEX "capturas_lance_id_especie_id_key" ON "capturas"("lance_id", "especie_id");

-- CreateIndex
CREATE INDEX "muestras_lance_id_idx" ON "muestras"("lance_id");

-- CreateIndex
CREATE UNIQUE INDEX "muestras_lance_id_especie_id_tipo_muestra_key" ON "muestras"("lance_id", "especie_id", "tipo_muestra");

-- CreateIndex
CREATE INDEX "muestras_detalle_talla_muestra_id_idx" ON "muestras_detalle_talla"("muestra_id");

-- CreateIndex
CREATE UNIQUE INDEX "muestras_detalle_talla_muestra_id_talla_mm_key" ON "muestras_detalle_talla"("muestra_id", "talla_mm");

-- CreateIndex
CREATE INDEX "submuestras_muestra_id_idx" ON "submuestras"("muestra_id");

-- CreateIndex
CREATE UNIQUE INDEX "submuestras_muestra_id_numero_ejemplar_key" ON "submuestras"("muestra_id", "numero_ejemplar");

-- CreateIndex
CREATE INDEX "producciones_marea_id_idx" ON "producciones"("marea_id");

-- CreateIndex
CREATE UNIQUE INDEX "producciones_marea_id_especie_id_fecha_producto_categoria_key" ON "producciones"("marea_id", "especie_id", "fecha", "producto", "categoria");

-- CreateIndex
CREATE UNIQUE INDEX "buque_trayectorias_buque_id_key" ON "buque_trayectorias"("buque_id");

-- CreateIndex
CREATE INDEX "buque_trayectorias_buque_id_idx" ON "buque_trayectorias"("buque_id");

-- CreateIndex
CREATE INDEX "buque_trayectoria_puntos_trayectoria_id_timestamp_idx" ON "buque_trayectoria_puntos"("trayectoria_id", "timestamp");

-- CreateIndex
CREATE INDEX "buque_trayectoria_puntos_buque_id_timestamp_idx" ON "buque_trayectoria_puntos"("buque_id", "timestamp");

-- CreateIndex
CREATE UNIQUE INDEX "buque_trayectoria_puntos_buque_id_timestamp_key" ON "buque_trayectoria_puntos"("buque_id", "timestamp");

-- AddForeignKey
ALTER TABLE "observador_pesquerias" ADD CONSTRAINT "observador_pesquerias_id_especie_fkey" FOREIGN KEY ("id_especie") REFERENCES "especies"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "mareas" ADD CONSTRAINT "mareas_id_buque_fkey" FOREIGN KEY ("id_buque") REFERENCES "buques"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "mareas" ADD CONSTRAINT "mareas_id_arte_principal_fkey" FOREIGN KEY ("id_arte_principal") REFERENCES "artes_pesca"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "mareas" ADD CONSTRAINT "mareas_id_estado_actual_fkey" FOREIGN KEY ("id_estado_actual") REFERENCES "estados_marea"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "mareas_etapas" ADD CONSTRAINT "mareas_etapas_id_marea_fkey" FOREIGN KEY ("id_marea") REFERENCES "mareas"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "mareas_etapas" ADD CONSTRAINT "mareas_etapas_id_pesqueria_fkey" FOREIGN KEY ("id_pesqueria") REFERENCES "pesquerias"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "mareas_etapas" ADD CONSTRAINT "mareas_etapas_id_puerto_zarpada_fkey" FOREIGN KEY ("id_puerto_zarpada") REFERENCES "puertos"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "mareas_etapas" ADD CONSTRAINT "mareas_etapas_id_puerto_arribo_fkey" FOREIGN KEY ("id_puerto_arribo") REFERENCES "puertos"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "mareas_movimientos" ADD CONSTRAINT "mareas_movimientos_id_marea_fkey" FOREIGN KEY ("id_marea") REFERENCES "mareas"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "mareas_movimientos" ADD CONSTRAINT "mareas_movimientos_id_usuario_fkey" FOREIGN KEY ("id_usuario") REFERENCES "users"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "mareas_movimientos" ADD CONSTRAINT "mareas_movimientos_id_estado_desde_fkey" FOREIGN KEY ("id_estado_desde") REFERENCES "estados_marea"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "mareas_movimientos" ADD CONSTRAINT "mareas_movimientos_id_estado_hasta_fkey" FOREIGN KEY ("id_estado_hasta") REFERENCES "estados_marea"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "mareas_archivos" ADD CONSTRAINT "mareas_archivos_id_marea_fkey" FOREIGN KEY ("id_marea") REFERENCES "mareas"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "mareas_archivos" ADD CONSTRAINT "mareas_archivos_id_movimiento_origen_fkey" FOREIGN KEY ("id_movimiento_origen") REFERENCES "mareas_movimientos"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "mareas_archivos" ADD CONSTRAINT "mareas_archivos_id_usuario_subio_fkey" FOREIGN KEY ("id_usuario_subio") REFERENCES "users"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "lances" ADD CONSTRAINT "lances_etapa_id_fkey" FOREIGN KEY ("etapa_id") REFERENCES "mareas_etapas"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "lances" ADD CONSTRAINT "lances_cod_arte_pesca_fkey" FOREIGN KEY ("cod_arte_pesca") REFERENCES "artes_pesca"("codigo_numerico") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "capturas" ADD CONSTRAINT "capturas_lance_id_fkey" FOREIGN KEY ("lance_id") REFERENCES "lances"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "capturas" ADD CONSTRAINT "capturas_especie_id_fkey" FOREIGN KEY ("especie_id") REFERENCES "especies"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "muestras" ADD CONSTRAINT "muestras_lance_id_fkey" FOREIGN KEY ("lance_id") REFERENCES "lances"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "muestras" ADD CONSTRAINT "muestras_especie_id_fkey" FOREIGN KEY ("especie_id") REFERENCES "especies"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "muestras_detalle_talla" ADD CONSTRAINT "muestras_detalle_talla_muestra_id_fkey" FOREIGN KEY ("muestra_id") REFERENCES "muestras"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "submuestras" ADD CONSTRAINT "submuestras_muestra_id_fkey" FOREIGN KEY ("muestra_id") REFERENCES "muestras"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "producciones" ADD CONSTRAINT "producciones_marea_id_fkey" FOREIGN KEY ("marea_id") REFERENCES "mareas"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "producciones" ADD CONSTRAINT "producciones_especie_id_fkey" FOREIGN KEY ("especie_id") REFERENCES "especies"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "buque_trayectorias" ADD CONSTRAINT "buque_trayectorias_buque_id_fkey" FOREIGN KEY ("buque_id") REFERENCES "buques"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "buque_trayectoria_puntos" ADD CONSTRAINT "buque_trayectoria_puntos_trayectoria_id_fkey" FOREIGN KEY ("trayectoria_id") REFERENCES "buque_trayectorias"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "buque_trayectoria_puntos" ADD CONSTRAINT "buque_trayectoria_puntos_buque_id_fkey" FOREIGN KEY ("buque_id") REFERENCES "buques"("id") ON DELETE RESTRICT ON UPDATE CASCADE;
