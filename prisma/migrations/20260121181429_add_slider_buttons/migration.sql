/*
  Warnings:

  - You are about to drop the column `subtitleColor` on the `Slider` table. All the data in the column will be lost.
  - You are about to drop the column `subtitleSize` on the `Slider` table. All the data in the column will be lost.
  - You are about to drop the column `titleColor` on the `Slider` table. All the data in the column will be lost.
  - You are about to drop the column `titleSize` on the `Slider` table. All the data in the column will be lost.

*/
-- AlterTable
ALTER TABLE "Slider" DROP COLUMN "subtitleColor",
DROP COLUMN "subtitleSize",
DROP COLUMN "titleColor",
DROP COLUMN "titleSize",
ADD COLUMN     "primaryButtonLink" TEXT,
ADD COLUMN     "primaryButtonText" TEXT,
ADD COLUMN     "secondaryButtonLink" TEXT,
ADD COLUMN     "secondaryButtonText" TEXT;
