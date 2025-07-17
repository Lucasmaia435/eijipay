import { PrismaClient } from "@prisma/client";
const prisma = new PrismaClient();

export const getAll = async () => {
  return await prisma.empregador.findMany();
};

export const getByCnpj = async (cnpj: string) => {
  return await prisma.empregador.findUnique({ where: { cnpj } });
};

export const create = async (cnpj: string, razao_social: string) => {
  return await prisma.empregador.create({
    data: { cnpj, razao_social },
  });
};

export const update = async (cnpj: string, razao_social: string) => {
  return await prisma.empregador.update({
    where: { cnpj },
    data: { razao_social },
  });
};

export const remove = async (cnpj: string) => {
  return await prisma.empregador.delete({ where: { cnpj } });
};
