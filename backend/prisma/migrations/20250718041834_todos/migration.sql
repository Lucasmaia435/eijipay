/*
  Warnings:

  - Added the required column `empregador_cnpj` to the `funcionario` table without a default value. This is not possible if the table is not empty.
  - Added the required column `lotacao_codigo` to the `funcionario` table without a default value. This is not possible if the table is not empty.

*/
-- AlterTable
ALTER TABLE "funcionario" ADD COLUMN     "empregador_cnpj" TEXT NOT NULL,
ADD COLUMN     "lotacao_codigo" TEXT NOT NULL;

-- CreateTable
CREATE TABLE "lotacoes" (
    "codigo" TEXT NOT NULL,
    "nome" TEXT NOT NULL,

    CONSTRAINT "lotacoes_pkey" PRIMARY KEY ("codigo")
);

-- CreateTable
CREATE TABLE "recibos_pagamento" (
    "funcionario_cpf" TEXT NOT NULL,
    "empregador_cnpj" TEXT NOT NULL,
    "competencia" TEXT NOT NULL,

    CONSTRAINT "recibos_pagamento_pkey" PRIMARY KEY ("funcionario_cpf","empregador_cnpj","competencia")
);

-- CreateTable
CREATE TABLE "verbas" (
    "codigo" TEXT NOT NULL,
    "descricao" TEXT NOT NULL,
    "referencia_pai_codigo" TEXT,

    CONSTRAINT "verbas_pkey" PRIMARY KEY ("codigo")
);

-- CreateTable
CREATE TABLE "itens_recibo" (
    "recibo_funcionario_cpf" TEXT NOT NULL,
    "recibo_empregador_cnpj" TEXT NOT NULL,
    "recibo_competencia" TEXT NOT NULL,
    "verba_codigo" TEXT NOT NULL,
    "valor_provento" DECIMAL(65,30),
    "valor_desconto" DECIMAL(65,30),

    CONSTRAINT "itens_recibo_pkey" PRIMARY KEY ("recibo_funcionario_cpf","recibo_empregador_cnpj","recibo_competencia","verba_codigo")
);

-- CreateIndex
CREATE UNIQUE INDEX "lotacoes_codigo_key" ON "lotacoes"("codigo");

-- CreateIndex
CREATE UNIQUE INDEX "verbas_codigo_key" ON "verbas"("codigo");

-- AddForeignKey
ALTER TABLE "funcionario" ADD CONSTRAINT "funcionario_empregador_cnpj_fkey" FOREIGN KEY ("empregador_cnpj") REFERENCES "empregador"("cnpj") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "funcionario" ADD CONSTRAINT "funcionario_lotacao_codigo_fkey" FOREIGN KEY ("lotacao_codigo") REFERENCES "lotacoes"("codigo") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "recibos_pagamento" ADD CONSTRAINT "recibos_pagamento_funcionario_cpf_fkey" FOREIGN KEY ("funcionario_cpf") REFERENCES "funcionario"("cpf") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "recibos_pagamento" ADD CONSTRAINT "recibos_pagamento_empregador_cnpj_fkey" FOREIGN KEY ("empregador_cnpj") REFERENCES "empregador"("cnpj") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "verbas" ADD CONSTRAINT "verbas_referencia_pai_codigo_fkey" FOREIGN KEY ("referencia_pai_codigo") REFERENCES "verbas"("codigo") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "itens_recibo" ADD CONSTRAINT "itens_recibo_recibo_funcionario_cpf_recibo_empregador_cnpj_fkey" FOREIGN KEY ("recibo_funcionario_cpf", "recibo_empregador_cnpj", "recibo_competencia") REFERENCES "recibos_pagamento"("funcionario_cpf", "empregador_cnpj", "competencia") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "itens_recibo" ADD CONSTRAINT "itens_recibo_verba_codigo_fkey" FOREIGN KEY ("verba_codigo") REFERENCES "verbas"("codigo") ON DELETE RESTRICT ON UPDATE CASCADE;
