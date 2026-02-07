-- CreateTable JobQueue
CREATE TABLE IF NOT EXISTS "public"."job_queue" (
    "id" TEXT NOT NULL,
    "type" TEXT NOT NULL,
    "payload" JSONB,
    "status" TEXT NOT NULL DEFAULT 'PENDING',
    "attempts" INTEGER NOT NULL DEFAULT 0,
    "maxAttempts" INTEGER NOT NULL DEFAULT 3,
    "next_run_at" TIMESTAMP(3) DEFAULT CURRENT_TIMESTAMP,
    "last_run_at" TIMESTAMP(3),
    "last_error" TEXT,
    "priority" INTEGER NOT NULL DEFAULT 0,
    "created_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "job_queue_pkey" PRIMARY KEY ("id")
);

-- CreateIndex
CREATE INDEX IF NOT EXISTS "job_queue_status_next_run_at_idx" ON "public"."job_queue"("status", "next_run_at");
