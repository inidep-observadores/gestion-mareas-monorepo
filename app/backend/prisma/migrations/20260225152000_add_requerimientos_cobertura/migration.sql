-- CreateTable
CREATE TABLE "public"."requerimientos_cobertura" (
    "id" UUID NOT NULL,
    "anio_operativo" INTEGER NOT NULL,
    "mes" INTEGER NOT NULL,
    "cantidad" INTEGER DEFAULT 0,
    "id_pesqueria" UUID NOT NULL,
    "id_tipo_flota" UUID NOT NULL,

    CONSTRAINT "requerimientos_cobertura_pkey" PRIMARY KEY ("id")
);

-- CreateIndex
CREATE UNIQUE INDEX "requerimientos_cobertura_anio_operativo_mes_id_pesqueria_id_tp_key" ON "public"."requerimientos_cobertura"("anio_operativo", "mes", "id_pesqueria", "id_tipo_flota");

-- AddForeignKey
ALTER TABLE "public"."requerimientos_cobertura" ADD CONSTRAINT "requerimientos_cobertura_id_pesqueria_fkey" FOREIGN KEY ("id_pesqueria") REFERENCES "public"."pesquerias"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "public"."requerimientos_cobertura" ADD CONSTRAINT "requerimientos_cobertura_id_tipo_flota_fkey" FOREIGN KEY ("id_tipo_flota") REFERENCES "public"."tipos_flota"("id") ON DELETE RESTRICT ON UPDATE CASCADE;
