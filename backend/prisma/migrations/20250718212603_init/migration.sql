-- CreateTable
CREATE TABLE "usuario" (
    "id" INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,
    "email" TEXT NOT NULL,
    "senha" TEXT NOT NULL,
    "nome" TEXT NOT NULL,
    "papel" TEXT NOT NULL
);

-- CreateTable
CREATE TABLE "lotacoes" (
    "codigo" TEXT NOT NULL PRIMARY KEY,
    "nome" TEXT NOT NULL
);

-- CreateTable
CREATE TABLE "funcionario" (
    "id" INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,
    "nome" TEXT NOT NULL,
    "sobrenome" TEXT NOT NULL,
    "cargo" TEXT NOT NULL,
    "cpf" TEXT NOT NULL,
    "data_admissao" DATETIME NOT NULL,
    "matricula" INTEGER NOT NULL,
    "empregador_cnpj" TEXT NOT NULL,
    "lotacao_codigo" TEXT NOT NULL,
    CONSTRAINT "funcionario_empregador_cnpj_fkey" FOREIGN KEY ("empregador_cnpj") REFERENCES "empregador" ("cnpj") ON DELETE RESTRICT ON UPDATE CASCADE,
    CONSTRAINT "funcionario_lotacao_codigo_fkey" FOREIGN KEY ("lotacao_codigo") REFERENCES "lotacoes" ("codigo") ON DELETE RESTRICT ON UPDATE CASCADE
);

-- CreateTable
CREATE TABLE "recibos_pagamento" (
    "funcionario_cpf" TEXT NOT NULL,
    "empregador_cnpj" TEXT NOT NULL,
    "competencia" TEXT NOT NULL,

    PRIMARY KEY ("funcionario_cpf", "empregador_cnpj", "competencia"),
    CONSTRAINT "recibos_pagamento_empregador_cnpj_fkey" FOREIGN KEY ("empregador_cnpj") REFERENCES "empregador" ("cnpj") ON DELETE RESTRICT ON UPDATE CASCADE,
    CONSTRAINT "recibos_pagamento_funcionario_cpf_fkey" FOREIGN KEY ("funcionario_cpf") REFERENCES "funcionario" ("cpf") ON DELETE RESTRICT ON UPDATE CASCADE
);

-- CreateTable
CREATE TABLE "verbas" (
    "codigo" TEXT NOT NULL PRIMARY KEY,
    "descricao" TEXT NOT NULL,
    "referencia_pai_codigo" TEXT,
    CONSTRAINT "verbas_referencia_pai_codigo_fkey" FOREIGN KEY ("referencia_pai_codigo") REFERENCES "verbas" ("codigo") ON DELETE SET NULL ON UPDATE CASCADE
);

-- CreateTable
CREATE TABLE "itens_recibo" (
    "recibo_funcionario_cpf" TEXT NOT NULL,
    "recibo_empregador_cnpj" TEXT NOT NULL,
    "recibo_competencia" TEXT NOT NULL,
    "verba_codigo" TEXT NOT NULL,
    "valor_provento" DECIMAL,
    "valor_desconto" DECIMAL,

    PRIMARY KEY ("recibo_funcionario_cpf", "recibo_empregador_cnpj", "recibo_competencia", "verba_codigo"),
    CONSTRAINT "itens_recibo_recibo_funcionario_cpf_recibo_empregador_cnpj_recibo_competencia_fkey" FOREIGN KEY ("recibo_funcionario_cpf", "recibo_empregador_cnpj", "recibo_competencia") REFERENCES "recibos_pagamento" ("funcionario_cpf", "empregador_cnpj", "competencia") ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT "itens_recibo_verba_codigo_fkey" FOREIGN KEY ("verba_codigo") REFERENCES "verbas" ("codigo") ON DELETE RESTRICT ON UPDATE CASCADE
);

-- CreateTable
CREATE TABLE "empregador" (
    "cnpj" TEXT NOT NULL PRIMARY KEY,
    "razao_social" TEXT NOT NULL
);

-- CreateIndex
CREATE UNIQUE INDEX "usuario_email_key" ON "usuario"("email");

-- CreateIndex
CREATE UNIQUE INDEX "lotacoes_codigo_key" ON "lotacoes"("codigo");

-- CreateIndex
CREATE UNIQUE INDEX "funcionario_cpf_key" ON "funcionario"("cpf");

-- CreateIndex
CREATE UNIQUE INDEX "funcionario_matricula_key" ON "funcionario"("matricula");

-- CreateIndex
CREATE UNIQUE INDEX "verbas_codigo_key" ON "verbas"("codigo");

-- CreateIndex
CREATE UNIQUE INDEX "empregador_cnpj_key" ON "empregador"("cnpj");
