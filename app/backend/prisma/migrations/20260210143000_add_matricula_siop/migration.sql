-- AlterTable
ALTER TABLE "public"."buques" ADD COLUMN "matricula_siop" TEXT;

-- UpdateData (Initialize with current matricula)
UPDATE "public"."buques" SET "matricula_siop" = "matricula";

-- CreateIndex
CREATE UNIQUE INDEX "buques_matricula_siop_key" ON "public"."buques"("matricula_siop");
