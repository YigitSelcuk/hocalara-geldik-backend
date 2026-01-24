/*
  Warnings:

  - A unique constraint covering the columns `[year,branchId]` on the table `YearlySuccess` will be added. If there are existing duplicate values, this will fail.

*/
-- CreateIndex
CREATE UNIQUE INDEX "YearlySuccess_year_branchId_key" ON "YearlySuccess"("year", "branchId");
