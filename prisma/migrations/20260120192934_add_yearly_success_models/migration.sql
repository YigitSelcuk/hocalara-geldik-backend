-- CreateTable
CREATE TABLE "YearlySuccess" (
    "id" TEXT NOT NULL,
    "year" TEXT NOT NULL,
    "totalDegrees" INTEGER NOT NULL DEFAULT 0,
    "placementCount" INTEGER NOT NULL DEFAULT 0,
    "successRate" DOUBLE PRECISION NOT NULL DEFAULT 0,
    "cityCount" INTEGER NOT NULL DEFAULT 0,
    "top100Count" INTEGER NOT NULL DEFAULT 0,
    "top1000Count" INTEGER NOT NULL DEFAULT 0,
    "yksAverage" DOUBLE PRECISION NOT NULL DEFAULT 0,
    "lgsAverage" DOUBLE PRECISION NOT NULL DEFAULT 0,
    "isActive" BOOLEAN NOT NULL DEFAULT true,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "YearlySuccess_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "SuccessBanner" (
    "id" TEXT NOT NULL,
    "yearlySuccessId" TEXT NOT NULL,
    "title" TEXT NOT NULL,
    "subtitle" TEXT NOT NULL,
    "description" TEXT NOT NULL,
    "image" TEXT NOT NULL,
    "highlightText" TEXT,
    "gradientFrom" TEXT NOT NULL DEFAULT '#2563eb',
    "gradientTo" TEXT NOT NULL DEFAULT '#1e40af',

    CONSTRAINT "SuccessBanner_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "TopStudent" (
    "id" TEXT NOT NULL,
    "yearlySuccessId" TEXT NOT NULL,
    "name" TEXT NOT NULL,
    "rank" TEXT NOT NULL,
    "exam" TEXT NOT NULL,
    "image" TEXT,
    "branch" TEXT,
    "university" TEXT,
    "score" DOUBLE PRECISION,
    "order" INTEGER NOT NULL DEFAULT 0,

    CONSTRAINT "TopStudent_pkey" PRIMARY KEY ("id")
);

-- CreateIndex
CREATE UNIQUE INDEX "YearlySuccess_year_key" ON "YearlySuccess"("year");

-- CreateIndex
CREATE UNIQUE INDEX "SuccessBanner_yearlySuccessId_key" ON "SuccessBanner"("yearlySuccessId");

-- AddForeignKey
ALTER TABLE "SuccessBanner" ADD CONSTRAINT "SuccessBanner_yearlySuccessId_fkey" FOREIGN KEY ("yearlySuccessId") REFERENCES "YearlySuccess"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "TopStudent" ADD CONSTRAINT "TopStudent_yearlySuccessId_fkey" FOREIGN KEY ("yearlySuccessId") REFERENCES "YearlySuccess"("id") ON DELETE CASCADE ON UPDATE CASCADE;
