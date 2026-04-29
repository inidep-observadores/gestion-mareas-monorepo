-- CreateTable
CREATE TABLE "public"."protocolizacion_lotes" (
    "id" UUID NOT NULL,
    "fecha_envio" TIMESTAMPTZ(6) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "id_usuario" UUID,
    "canal" TEXT NOT NULL DEFAULT 'EMAIL',

    CONSTRAINT "protocolizacion_lotes_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "public"."protocolizacion_lote_items" (
    "id" UUID NOT NULL,
    "id_lote" UUID NOT NULL,
    "id_marea" UUID NOT NULL,

    CONSTRAINT "protocolizacion_lote_items_pkey" PRIMARY KEY ("id")
);

-- CreateIndex
CREATE UNIQUE INDEX "protocolizacion_lote_items_id_lote_id_marea_key" ON "public"."protocolizacion_lote_items"("id_lote", "id_marea");

-- AddForeignKey
ALTER TABLE "public"."protocolizacion_lotes" ADD CONSTRAINT "protocolizacion_lotes_id_usuario_fkey" FOREIGN KEY ("id_usuario") REFERENCES "public"."users"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "public"."protocolizacion_lote_items" ADD CONSTRAINT "protocolizacion_lote_items_id_lote_fkey" FOREIGN KEY ("id_lote") REFERENCES "public"."protocolizacion_lotes"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "public"."protocolizacion_lote_items" ADD CONSTRAINT "protocolizacion_lote_items_id_marea_fkey" FOREIGN KEY ("id_marea") REFERENCES "public"."mareas"("id") ON DELETE RESTRICT ON UPDATE CASCADE;
