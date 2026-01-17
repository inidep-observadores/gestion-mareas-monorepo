-- AlterTable
ALTER TABLE "mareas" ADD COLUMN     "id_observador_principal" UUID;

-- AddForeignKey
ALTER TABLE "mareas" ADD CONSTRAINT "mareas_id_observador_principal_fkey" FOREIGN KEY ("id_observador_principal") REFERENCES "observadores"("id") ON DELETE SET NULL ON UPDATE CASCADE;
