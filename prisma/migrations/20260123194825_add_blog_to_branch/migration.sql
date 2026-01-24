-- AlterEnum
-- This migration adds more than one value to an enum.
-- With PostgreSQL versions 11 and earlier, this is not possible
-- in a single migration. This can be worked around by creating
-- multiple migrations, each migration adding only one value to
-- the enum.


ALTER TYPE "ChangeType" ADD VALUE 'BLOG_CREATE';
ALTER TYPE "ChangeType" ADD VALUE 'BLOG_UPDATE';
ALTER TYPE "ChangeType" ADD VALUE 'BLOG_DELETE';

-- AlterTable
ALTER TABLE "BlogPost" ADD COLUMN     "branchId" TEXT;

-- CreateIndex
CREATE INDEX "BlogPost_branchId_idx" ON "BlogPost"("branchId");

-- AddForeignKey
ALTER TABLE "BlogPost" ADD CONSTRAINT "BlogPost_branchId_fkey" FOREIGN KEY ("branchId") REFERENCES "Branch"("id") ON DELETE SET NULL ON UPDATE CASCADE;
