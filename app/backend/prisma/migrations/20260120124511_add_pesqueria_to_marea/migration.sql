-- AlterTable
ALTER TABLE "mareas" ADD COLUMN     "id_pesqueria" UUID;

-- AddForeignKey
ALTER TABLE "mareas" ADD CONSTRAINT "mareas_id_pesqueria_fkey" FOREIGN KEY ("id_pesqueria") REFERENCES "pesquerias"("id") ON DELETE SET NULL ON UPDATE CASCADE;
