-- 1. Crear tabla temporal para agrupar los datos
CREATE TEMP TABLE tmp_experiencia_agrupada AS
SELECT 
    observador_id,
    pesqueria_id,
    SUM(experiencia) AS experiencia_total,
    MAX(valor) AS valor_maximo
FROM "experiencia_observadores"
GROUP BY observador_id, pesqueria_id;

-- 2. Vaciar la tabla original
DELETE FROM "experiencia_observadores";

-- 3. Dejamos que Prisma ejecute los DROP destructivos
-- DropForeignKey
ALTER TABLE "experiencia_observadores" DROP CONSTRAINT "experiencia_observadores_tipo_flota_id_fkey";

-- DropIndex
DROP INDEX "experiencia_observadores_observador_id_pesqueria_id_tipo_flota_";

-- AlterTable
ALTER TABLE "experiencia_observadores" DROP COLUMN "tipo_flota_id";

-- CreateIndex
CREATE UNIQUE INDEX "experiencia_observadores_observador_id_pesqueria_id_unique" ON "experiencia_observadores"("observador_id", "pesqueria_id");

-- 4. Reinsertar los datos agrupados
INSERT INTO "experiencia_observadores" (observador_id, pesqueria_id, experiencia, valor, fecha_actualizacion)
SELECT 
    observador_id,
    pesqueria_id,
    experiencia_total,
    valor_maximo,
    NOW()
FROM tmp_experiencia_agrupada;
