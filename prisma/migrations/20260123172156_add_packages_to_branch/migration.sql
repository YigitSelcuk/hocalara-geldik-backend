-- AlterEnum
-- This migration adds more than one value to an enum.
-- With PostgreSQL versions 11 and earlier, this is not possible
-- in a single migration. This can be worked around by creating
-- multiple migrations, each migration adding only one value to
-- the enum.


ALTER TYPE "ChangeType" ADD VALUE 'PACKAGE_CREATE';
ALTER TYPE "ChangeType" ADD VALUE 'PACKAGE_UPDATE';
ALTER TYPE "ChangeType" ADD VALUE 'PACKAGE_DELETE';

-- AlterTable
ALTER TABLE "EducationPackage" ADD COLUMN     "branchId" TEXT;

-- CreateIndex
CREATE INDEX "EducationPackage_branchId_idx" ON "EducationPackage"("branchId");

-- AddForeignKey
ALTER TABLE "EducationPackage" ADD CONSTRAINT "EducationPackage_branchId_fkey" FOREIGN KEY ("branchId") REFERENCES "Branch"("id") ON DELETE SET NULL ON UPDATE CASCADE;
