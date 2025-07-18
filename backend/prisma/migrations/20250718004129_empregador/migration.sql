-- AlterTable
ALTER TABLE "funcionario" ALTER COLUMN "cpf" SET DATA TYPE CHAR(11);

-- CreateTable
CREATE TABLE "empregador" (
    "cnpj" CHAR(14) NOT NULL,
    "razao_social" TEXT NOT NULL,

    CONSTRAINT "empregador_pkey" PRIMARY KEY ("cnpj")
);

-- CreateIndex
CREATE UNIQUE INDEX "empregador_cnpj_key" ON "empregador"("cnpj");
