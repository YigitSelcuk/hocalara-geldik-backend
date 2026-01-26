-- AlterTable
ALTER TABLE "Branch" ADD COLUMN     "weekdayHours" TEXT DEFAULT '08:30 - 19:30',
ADD COLUMN     "weekendHours" TEXT DEFAULT '09:00 - 18:00';
