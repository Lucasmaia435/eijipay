import { PrismaClient } from "@prisma/client";
const prisma = new PrismaClient();

export const lotacaoService = {
  async listarTodas() {
    return await prisma.lotacao.findMany();
  },

  async buscarPorCodigo(codigo: number) {
    return await prisma.lotacao.findUnique({
      where: { codigo },
    });
  },

  async criar(nome: string) {
    return await prisma.lotacao.create({
      data: { nome },
    });
  },

  async atualizar(codigo: number, nome: string) {
    return await prisma.lotacao.update({
      where: { codigo },
      data: { nome },
    });
  },

  async deletar(codigo: number) {
    return await prisma.lotacao.delete({
      where: { codigo },
    });
  },
};
