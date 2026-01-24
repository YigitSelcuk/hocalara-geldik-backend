/*
  Warnings:

  - You are about to drop the column `bgImage` on the `HomeSection` table. All the data in the column will be lost.
  - You are about to drop the column `image` on the `HomeSection` table. All the data in the column will be lost.
  - You are about to drop the column `key` on the `HomeSection` table. All the data in the column will be lost.
  - You are about to drop the column `link` on the `HomeSection` table. All the data in the column will be lost.
  - You are about to drop the column `linkText` on the `HomeSection` table. All the data in the column will be lost.
  - You are about to drop the column `topTitle` on the `HomeSection` table. All the data in the column will be lost.
  - A unique constraint covering the columns `[page,section]` on the table `HomeSection` will be added. If there are existing duplicate values, this will fail.
  - Added the required column `page` to the `HomeSection` table without a default value. This is not possible if the table is not empty.
  - Added the required column `section` to the `HomeSection` table without a default value. This is not possible if the table is not empty.

*/
-- DropIndex
DROP INDEX "HomeSection_key_idx";

-- DropIndex
DROP INDEX "HomeSection_key_key";

-- AlterTable
ALTER TABLE "HomeSection" DROP COLUMN "bgImage",
DROP COLUMN "image",
DROP COLUMN "key",
DROP COLUMN "link",
DROP COLUMN "linkText",
DROP COLUMN "topTitle",
ADD COLUMN     "buttonLink" TEXT,
ADD COLUMN     "buttonText" TEXT,
ADD COLUMN     "content" TEXT,
ADD COLUMN     "description" TEXT,
ADD COLUMN     "page" TEXT NOT NULL,
ADD COLUMN     "section" TEXT NOT NULL,
ALTER COLUMN "title" DROP NOT NULL;

-- CreateIndex
CREATE INDEX "HomeSection_page_idx" ON "HomeSection"("page");

-- CreateIndex
CREATE INDEX "HomeSection_section_idx" ON "HomeSection"("section");

-- CreateIndex
CREATE UNIQUE INDEX "HomeSection_page_section_key" ON "HomeSection"("page", "section");
