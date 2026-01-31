/*
  Warnings:

  - A unique constraint covering the columns `[nombre_buque]` on the table `buques` will be added. If there are existing duplicate values, this will fail.

*/
-- CreateTable
CREATE TABLE "tracking_event_snapshots" (
    "id" UUID NOT NULL,
    "buque_id" UUID NOT NULL,
    "event_type" TEXT NOT NULL,
    "timestamp" TIMESTAMPTZ(6) NOT NULL,
    "puerto_id" UUID,
    "hash" TEXT NOT NULL,
    "created_at" TIMESTAMPTZ(6) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "tracking_event_snapshots_pkey" PRIMARY KEY ("id")
);

-- CreateIndex
CREATE UNIQUE INDEX "tracking_event_snapshots_hash_key" ON "tracking_event_snapshots"("hash");

-- CreateIndex
CREATE INDEX "tracking_event_snapshots_buque_id_idx" ON "tracking_event_snapshots"("buque_id");

-- CreateIndex
CREATE INDEX "tracking_event_snapshots_hash_idx" ON "tracking_event_snapshots"("hash");

-- CreateIndex
CREATE UNIQUE INDEX "buques_nombre_buque_key" ON "buques"("nombre_buque");
