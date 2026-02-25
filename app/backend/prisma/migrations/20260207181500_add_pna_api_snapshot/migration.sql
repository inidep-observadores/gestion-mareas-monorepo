-- CreateTable
CREATE TABLE "pna_api_snapshots" (
    "id" UUID NOT NULL DEFAULT gen_random_uuid(),
    "id_costera" TEXT NOT NULL,
    "external_combo_id" TEXT NOT NULL,
    "source" TEXT NOT NULL DEFAULT 'API_PNA',
    "payload" JSONB NOT NULL,
    "processed_at" TIMESTAMPTZ(6) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "alert_id" UUID,
    "buque_id_mbpc" TEXT,
    "buque_nombre" TEXT,
    "estado" TEXT NOT NULL,
    "fecha" TIMESTAMPTZ(6) NOT NULL,

    CONSTRAINT "pna_api_snapshots_pkey" PRIMARY KEY ("id")
);

-- CreateIndex
CREATE UNIQUE INDEX "pna_api_snapshots_external_combo_id_key" ON "pna_api_snapshots"("external_combo_id");

-- CreateIndex
CREATE INDEX "pna_api_snapshots_buque_id_mbpc_idx" ON "pna_api_snapshots"("buque_id_mbpc");

-- CreateIndex
CREATE INDEX "pna_api_snapshots_fecha_idx" ON "pna_api_snapshots"("fecha");

-- CreateIndex
CREATE INDEX "pna_api_snapshots_estado_idx" ON "pna_api_snapshots"("estado");
