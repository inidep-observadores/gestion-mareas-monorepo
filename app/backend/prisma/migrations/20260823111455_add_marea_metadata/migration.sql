-- AddColumn metadata (JSONB) to mareas table
ALTER TABLE "public"."mareas" ADD COLUMN IF NOT EXISTS "metadata" JSONB;
