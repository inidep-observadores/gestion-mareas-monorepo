@[line 1: -- CreateTable]
CREATE TABLE "experiencia_observadores" (
    "id" TEXT NOT NULL,
    "observadorId" TEXT NOT NULL,
    "pesqueriaId" TEXT NOT NULL,
    "valor" INTEGER,
    "fechaActualizacion" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "experiencia_observadores_pkey" PRIMARY KEY ("id")
);

-- CreateIndex]
CREATE INDEX "experiencia_observadores_observadorId_idx" ON "experiencia_observadores"("observadorId");

-- CreateIndex]
CREATE INDEX "experiencia_observadores_pesqueriaId_idx" ON "experiencia_observadores"("pesqueriaId");

-- CreateIndex]
CREATE UNIQUE INDEX "experiencia_observadores_observadorId_pesqueriaId_key" ON "experiencia_observadores"("observadorId", "pesqueriaId");

-- AddForeignKey]
ALTER TABLE "experiencia_observadores" ADD CONSTRAINT "experiencia_observadores_observadorId_fkey" FOREIGN KEY ("observadorId") REFERENCES "observadores"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey]
ALTER TABLE "experiencia_observadores" ADD CONSTRAINT "experiencia_observadores_pesqueriaId_fkey" FOREIGN KEY ("pesqueriaId") REFERENCES "pesquerias"("id") ON DELETE CASCADE ON UPDATE CASCADE;

