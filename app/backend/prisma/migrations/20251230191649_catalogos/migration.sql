-- AlterTable
ALTER TABLE "users" ALTER COLUMN "roles" SET DEFAULT ARRAY['asistente_administrativo']::TEXT[];

-- CreateTable
CREATE TABLE "tipos_flota" (
    "id" UUID NOT NULL,
    "codigo" TEXT NOT NULL,
    "nombre" TEXT NOT NULL,
    "descripcion" TEXT,
    "orden" INTEGER,
    "activo" BOOLEAN NOT NULL DEFAULT true,

    CONSTRAINT "tipos_flota_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "buques" (
    "id" UUID NOT NULL,
    "nombre_buque" TEXT NOT NULL,
    "matricula" TEXT NOT NULL,
    "codigo_interno" INTEGER,
    "id_tipo_flota" UUID,
    "id_arte_habitual" UUID,
    "id_pesqueria_habitual" UUID,
    "dias_marea_estimada" INTEGER,
    "eslora_m" DECIMAL(6,2),
    "potencia_hp" INTEGER,
    "id_puerto_base" UUID,
    "empresa_nombre" TEXT,
    "empresa_localidad" TEXT,
    "empresa_telefono" TEXT,
    "empresa_fax" TEXT,
    "empresa_correo_principal" TEXT,
    "empresa_correo_secundario" TEXT,
    "armador_nombre" TEXT,
    "armador_telefono" TEXT,
    "agencia_maritima_nombre" TEXT,
    "activo" BOOLEAN NOT NULL DEFAULT true,
    "fecha_alta" DATE,
    "fecha_baja" DATE,
    "observaciones" TEXT,

    CONSTRAINT "buques_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "artes_pesca" (
    "id" UUID NOT NULL,
    "codigo_numerico" INTEGER NOT NULL,
    "descripcion" TEXT NOT NULL,
    "activo" BOOLEAN NOT NULL DEFAULT true,

    CONSTRAINT "artes_pesca_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "pesquerias" (
    "id" UUID NOT NULL,
    "codigo" TEXT NOT NULL,
    "nombre" TEXT NOT NULL,
    "descripcion" TEXT,
    "grupo" TEXT,
    "orden" INTEGER,
    "activo" BOOLEAN NOT NULL DEFAULT true,

    CONSTRAINT "pesquerias_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "puertos" (
    "id" UUID NOT NULL,
    "nombre" TEXT NOT NULL,
    "provincia" TEXT,
    "pais" TEXT,
    "codigo_interno" TEXT,
    "codigo_externo" TEXT,
    "es_local" BOOLEAN NOT NULL DEFAULT false,
    "activo" BOOLEAN NOT NULL DEFAULT true,
    "orden" INTEGER,
    "observaciones" TEXT,

    CONSTRAINT "puertos_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "especies" (
    "id" UUID NOT NULL,
    "codigo" TEXT NOT NULL,
    "nombre_cientifico" TEXT NOT NULL,
    "nombre_vulgar" TEXT NOT NULL,
    "activo" BOOLEAN NOT NULL DEFAULT true,
    "observaciones" TEXT,

    CONSTRAINT "especies_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "observadores" (
    "id" UUID NOT NULL,
    "codigo_interno" INTEGER NOT NULL,
    "nombre" TEXT NOT NULL,
    "apellido" TEXT NOT NULL,
    "foto_url" TEXT,
    "tipo_observador" TEXT NOT NULL,
    "tipo_contrato" TEXT NOT NULL,
    "activo" BOOLEAN NOT NULL DEFAULT true,
    "disponible" BOOLEAN NOT NULL DEFAULT true,
    "fecha_proxima_disponibilidad" TIMESTAMPTZ,
    "observaciones" TEXT,

    CONSTRAINT "observadores_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "observador_pesquerias" (
    "id" UUID NOT NULL,
    "id_observador" UUID NOT NULL,
    "id_pesqueria" UUID NOT NULL,
    "modo" TEXT NOT NULL,
    "activo" BOOLEAN NOT NULL DEFAULT true,
    "motivo" TEXT,
    "fecha_desde" TIMESTAMPTZ,
    "fecha_hasta" TIMESTAMPTZ,
    "especieId" UUID,

    CONSTRAINT "observador_pesquerias_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "estados_marea" (
    "id" UUID NOT NULL,
    "codigo" TEXT NOT NULL,
    "nombre" TEXT NOT NULL,
    "descripcion" TEXT,
    "categoria" TEXT NOT NULL,
    "orden" INTEGER NOT NULL,
    "es_inicial" BOOLEAN NOT NULL DEFAULT false,
    "es_final" BOOLEAN NOT NULL DEFAULT false,
    "permite_carga_archivos" BOOLEAN NOT NULL DEFAULT false,
    "permite_correccion" BOOLEAN NOT NULL DEFAULT false,
    "permite_informe" BOOLEAN NOT NULL DEFAULT false,
    "activo" BOOLEAN NOT NULL DEFAULT true,

    CONSTRAINT "estados_marea_pkey" PRIMARY KEY ("id")
);

-- CreateIndex
CREATE UNIQUE INDEX "tipos_flota_codigo_key" ON "tipos_flota"("codigo");

-- CreateIndex
CREATE UNIQUE INDEX "buques_matricula_key" ON "buques"("matricula");

-- CreateIndex
CREATE UNIQUE INDEX "artes_pesca_codigo_numerico_key" ON "artes_pesca"("codigo_numerico");

-- CreateIndex
CREATE UNIQUE INDEX "pesquerias_codigo_key" ON "pesquerias"("codigo");

-- CreateIndex
CREATE UNIQUE INDEX "especies_codigo_key" ON "especies"("codigo");

-- CreateIndex
CREATE INDEX "observador_pesquerias_id_observador_idx" ON "observador_pesquerias"("id_observador");

-- CreateIndex
CREATE INDEX "observador_pesquerias_id_pesqueria_idx" ON "observador_pesquerias"("id_pesqueria");

-- CreateIndex
CREATE UNIQUE INDEX "observador_pesquerias_id_observador_id_pesqueria_modo_key" ON "observador_pesquerias"("id_observador", "id_pesqueria", "modo");

-- CreateIndex
CREATE UNIQUE INDEX "estados_marea_codigo_key" ON "estados_marea"("codigo");

-- AddForeignKey
ALTER TABLE "buques" ADD CONSTRAINT "buques_id_tipo_flota_fkey" FOREIGN KEY ("id_tipo_flota") REFERENCES "tipos_flota"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "buques" ADD CONSTRAINT "buques_id_arte_habitual_fkey" FOREIGN KEY ("id_arte_habitual") REFERENCES "artes_pesca"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "buques" ADD CONSTRAINT "buques_id_pesqueria_habitual_fkey" FOREIGN KEY ("id_pesqueria_habitual") REFERENCES "pesquerias"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "buques" ADD CONSTRAINT "buques_id_puerto_base_fkey" FOREIGN KEY ("id_puerto_base") REFERENCES "puertos"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "observador_pesquerias" ADD CONSTRAINT "observador_pesquerias_id_observador_fkey" FOREIGN KEY ("id_observador") REFERENCES "observadores"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "observador_pesquerias" ADD CONSTRAINT "observador_pesquerias_id_pesqueria_fkey" FOREIGN KEY ("id_pesqueria") REFERENCES "pesquerias"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "observador_pesquerias" ADD CONSTRAINT "observador_pesquerias_especieId_fkey" FOREIGN KEY ("especieId") REFERENCES "especies"("id") ON DELETE SET NULL ON UPDATE CASCADE;
