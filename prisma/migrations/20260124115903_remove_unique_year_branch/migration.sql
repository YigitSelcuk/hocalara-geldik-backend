-- DropIndex
DROP INDEX "YearlySuccess_year_branchId_key";

-- CreateIndex
CREATE INDEX "YearlySuccess_year_idx" ON "YearlySuccess"("year");
