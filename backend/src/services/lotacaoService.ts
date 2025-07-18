import { PrismaClient } from '@prisma/client/edge'
import { withAccelerate } from '@prisma/extension-accelerate'
import { v4 as uuidv4 } from "uuid";

// Instancia o Prisma Client, passando a extensão Accelerate
const prisma = new PrismaClient().$extends(withAccelerate());

export const lotacaoService = {
  async listarTodas() {
    return await prisma.lotacao.findMany();
  },

  async buscarPorCodigo(codigo: string) {
    return await prisma.lotacao.findUnique({
      where: { codigo },
    });
  },

  async criar(nome: string) {
    const codigo = uuidv4(); // gera código único
    return await prisma.lotacao.create({
      data: {
        codigo,
        nome,
      },
    });
  },

  async atualizar(codigo: string, nome: string) {
    return await prisma.lotacao.update({
      where: { codigo },
      data: { nome },
    });
  },

  async deletar(codigo: string) {
    return await prisma.lotacao.delete({
      where: { codigo },
    });
  },
};
