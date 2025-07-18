/*
  Warnings:

  - You are about to drop the column `usuario_id` on the `funcionario` table. All the data in the column will be lost.
  - You are about to alter the column `cpf` on the `funcionario` table. The data in that column could be lost. The data in that column will be cast from `Text` to `VarChar(11)`.
  - A unique constraint covering the columns `[matricula]` on the table `funcionario` will be added. If there are existing duplicate values, this will fail.
  - Added the required column `matricula` to the `funcionario` table without a default value. This is not possible if the table is not empty.

*/
-- DropForeignKey
ALTER TABLE "funcionario" DROP CONSTRAINT "funcionario_usuario_id_fkey";

-- AlterTable
ALTER TABLE "funcionario" DROP COLUMN "usuario_id",
ADD COLUMN     "matricula" INTEGER NOT NULL,
ALTER COLUMN "cpf" SET DATA TYPE VARCHAR(11);

-- CreateIndex
CREATE UNIQUE INDEX "funcionario_matricula_key" ON "funcionario"("matricula");
