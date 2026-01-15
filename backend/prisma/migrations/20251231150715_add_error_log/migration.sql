-- CreateTable
CREATE TABLE "error_logs" (
    "id" UUID NOT NULL,
    "timestamp" TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "level" TEXT NOT NULL,
    "source" TEXT NOT NULL,
    "context" TEXT,
    "userId" UUID,
    "userEmail" TEXT,
    "message" TEXT NOT NULL,
    "stack" TEXT,
    "detail" JSONB,
    "path" TEXT,
    "method" TEXT,
    "ip" TEXT,

    CONSTRAINT "error_logs_pkey" PRIMARY KEY ("id")
);
