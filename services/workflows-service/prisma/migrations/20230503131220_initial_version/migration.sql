-- CreateEnum
CREATE TYPE "ApprovalState" AS ENUM ('APPROVED', 'REJECTED', 'PROCESSING', 'NEW');

-- CreateTable
CREATE TABLE "User" (
    "id" TEXT NOT NULL,
    "firstName" TEXT NOT NULL,
    "lastName" TEXT NOT NULL,
    "email" TEXT NOT NULL,
    "phone" TEXT,
    "password" TEXT NOT NULL,
    "roles" JSONB NOT NULL,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "User_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "EndUser" (
    "id" TEXT NOT NULL,
    "correlationId" VARCHAR NOT NULL,
    "verificationId" VARCHAR,
    "endUserType" TEXT,
    "approvalState" "ApprovalState" NOT NULL DEFAULT 'NEW',
    "stateReason" VARCHAR,
    "jsonData" JSONB,
    "firstName" VARCHAR,
    "lastName" VARCHAR,
    "email" TEXT,
    "phone" VARCHAR,
    "dateOfBirth" TIMESTAMP(3),
    "avatarUrl" TEXT,
    "additionalInfo" JSONB,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "EndUser_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "EndUsersOnBusinesses" (
    "endUserId" TEXT NOT NULL,
    "businessId" TEXT NOT NULL,

    CONSTRAINT "EndUsersOnBusinesses_pkey" PRIMARY KEY ("endUserId","businessId")
);

-- CreateTable
CREATE TABLE "Business" (
    "id" TEXT NOT NULL,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,
    "companyName" TEXT NOT NULL,
    "registrationNumber" TEXT NOT NULL,
    "legalForm" TEXT NOT NULL,
    "countryOfIncorporation" TEXT NOT NULL,
    "dateOfIncorporation" TIMESTAMP(3),
    "address" TEXT NOT NULL,
    "phoneNumber" TEXT,
    "email" TEXT,
    "website" TEXT,
    "industry" TEXT NOT NULL,
    "taxIdentificationNumber" TEXT,
    "vatNumber" TEXT,
    "shareholderStructure" JSONB,
    "numberOfEmployees" INTEGER,
    "businessPurpose" TEXT,
    "documents" JSONB NOT NULL,
    "approvalState" "ApprovalState" NOT NULL DEFAULT 'NEW',

    CONSTRAINT "Business_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "WorkflowDefinition" (
    "id" TEXT NOT NULL,
    "reviewMachineId" TEXT,
    "name" TEXT NOT NULL,
    "version" INTEGER NOT NULL DEFAULT 1,
    "definitionType" TEXT NOT NULL,
    "definition" JSONB NOT NULL,
    "supportedPlatforms" JSONB,
    "extensions" JSONB,
    "backend" JSONB,
    "persistStates" JSONB,
    "submitStates" JSONB,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,
    "createdBy" TEXT NOT NULL DEFAULT 'SYSTEM',

    CONSTRAINT "WorkflowDefinition_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "WorkflowRuntimeData" (
    "id" TEXT NOT NULL,
    "endUserId" TEXT,
    "businessId" TEXT,
    "workflowDefinitionId" TEXT NOT NULL,
    "workflowDefinitionVersion" INTEGER NOT NULL,
    "context" JSONB NOT NULL,
    "state" TEXT,
    "status" TEXT NOT NULL DEFAULT 'created',
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,
    "createdBy" TEXT NOT NULL DEFAULT 'SYSTEM',

    CONSTRAINT "WorkflowRuntimeData_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "File" (
    "id" TEXT NOT NULL,
    "userId" TEXT NOT NULL,
    "fileNameOnDisk" TEXT NOT NULL,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "createdBy" TEXT NOT NULL DEFAULT 'SYSTEM',

    CONSTRAINT "File_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "Policy" (
    "id" TEXT NOT NULL,
    "name" TEXT NOT NULL,
    "version" INTEGER NOT NULL,
    "tasks" JSONB NOT NULL,
    "rulesSets" JSONB NOT NULL,

    CONSTRAINT "Policy_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "_BusinessToEndUser" (
    "A" TEXT NOT NULL,
    "B" TEXT NOT NULL
);

-- CreateIndex
CREATE UNIQUE INDEX "User_email_key" ON "User"("email");

-- CreateIndex
CREATE UNIQUE INDEX "User_phone_key" ON "User"("phone");

-- CreateIndex
CREATE UNIQUE INDEX "_BusinessToEndUser_AB_unique" ON "_BusinessToEndUser"("A", "B");

-- CreateIndex
CREATE INDEX "_BusinessToEndUser_B_index" ON "_BusinessToEndUser"("B");

-- AddForeignKey
ALTER TABLE "EndUsersOnBusinesses" ADD CONSTRAINT "EndUsersOnBusinesses_endUserId_fkey" FOREIGN KEY ("endUserId") REFERENCES "EndUser"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "EndUsersOnBusinesses" ADD CONSTRAINT "EndUsersOnBusinesses_businessId_fkey" FOREIGN KEY ("businessId") REFERENCES "Business"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "WorkflowRuntimeData" ADD CONSTRAINT "WorkflowRuntimeData_endUserId_fkey" FOREIGN KEY ("endUserId") REFERENCES "EndUser"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "WorkflowRuntimeData" ADD CONSTRAINT "WorkflowRuntimeData_businessId_fkey" FOREIGN KEY ("businessId") REFERENCES "Business"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "WorkflowRuntimeData" ADD CONSTRAINT "WorkflowRuntimeData_workflowDefinitionId_fkey" FOREIGN KEY ("workflowDefinitionId") REFERENCES "WorkflowDefinition"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "_BusinessToEndUser" ADD CONSTRAINT "_BusinessToEndUser_A_fkey" FOREIGN KEY ("A") REFERENCES "Business"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "_BusinessToEndUser" ADD CONSTRAINT "_BusinessToEndUser_B_fkey" FOREIGN KEY ("B") REFERENCES "EndUser"("id") ON DELETE CASCADE ON UPDATE CASCADE;