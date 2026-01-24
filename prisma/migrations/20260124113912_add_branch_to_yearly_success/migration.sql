/*
  Warnings:

  - A unique constraint covering the columns `[year,branchId]` on the table `YearlySuccess` will be added. If there are existing duplicate values, this will fail.

*/
-- AlterEnum
-- This migration adds more than one value to an enum.
-- With PostgreSQL versions 11 and earlier, this is not possible
-- in a single migration. This can be worked around by creating
-- multiple migrations, each migration adding only one value to
-- the enum.


ALTER TYPE "ChangeType" ADD VALUE 'SUCCESS_CREATE';
ALTER TYPE "ChangeType" ADD VALUE 'SUCCESS_UPDATE';
ALTER TYPE "ChangeType" ADD VALUE 'SUCCESS_DELETE';

-- DropIndex
DROP INDEX "YearlySuccess_year_key";

-- AlterTable
ALTER TABLE "YearlySuccess" ADD COLUMN     "branchId" TEXT;

-- CreateIndex
CREATE INDEX "YearlySuccess_branchId_idx" ON "YearlySuccess"("branchId");

-- CreateIndex
CREATE UNIQUE INDEX "YearlySuccess_year_branchId_key" ON "YearlySuccess"("year", "branchId");

-- AddForeignKey
ALTER TABLE "YearlySuccess" ADD CONSTRAINT "YearlySuccess_branchId_fkey" FOREIGN KEY ("branchId") REFERENCES "Branch"("id") ON DELETE SET NULL ON UPDATE CASCADE;
