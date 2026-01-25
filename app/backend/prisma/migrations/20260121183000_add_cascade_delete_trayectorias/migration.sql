-- DropForeignKey
ALTER TABLE "buque_trayectoria_puntos" DROP CONSTRAINT "buque_trayectoria_puntos_trayectoria_id_fkey";

-- AddForeignKey
ALTER TABLE "buque_trayectoria_puntos" ADD CONSTRAINT "buque_trayectoria_puntos_trayectoria_id_fkey" FOREIGN KEY ("trayectoria_id") REFERENCES "buque_trayectorias"("id") ON DELETE CASCADE ON UPDATE CASCADE;
