-- DropIndex
DROP INDEX "Lead_createdAt_idx";

-- DropIndex
DROP INDEX "Lead_status_idx";

-- CreateTable
CREATE TABLE "FranchiseApplication" (
    "id" TEXT NOT NULL,
    "name" TEXT NOT NULL,
    "surname" TEXT NOT NULL,
    "phone" TEXT NOT NULL,
    "email" TEXT NOT NULL,
    "city" TEXT,
    "message" TEXT,
    "status" TEXT NOT NULL DEFAULT 'NEW',
    "notes" TEXT,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "FranchiseApplication_pkey" PRIMARY KEY ("id")
);

-- CreateIndex
CREATE INDEX "FranchiseApplication_status_idx" ON "FranchiseApplication"("status");

-- CreateIndex
CREATE INDEX "FranchiseApplication_createdAt_idx" ON "FranchiseApplication"("createdAt");
