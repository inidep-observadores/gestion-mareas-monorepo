-- AlterTable
ALTER TABLE "public"."mareas" ADD COLUMN     "anio_protocolizacion" INTEGER,
ADD COLUMN     "fecha_envio_protocolizacion" TIMESTAMPTZ(6),
ADD COLUMN     "fecha_protocolizacion" TIMESTAMPTZ(6),
ADD COLUMN     "nro_protocolizacion" TEXT;
