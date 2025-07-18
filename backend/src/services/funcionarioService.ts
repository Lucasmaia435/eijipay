import { PrismaClient } from "@prisma/client";
const prisma = new PrismaClient();

export const listarFuncionarios = async () => {
  return await prisma.funcionario.findMany()
};

export const criarFuncionario = async (dados: {
  nome: string;
  sobrenome: string;
  cargo: string;
  cpf: string;
  data_admissao: Date;
  matricula: number;
}) => {
  return await prisma.funcionario.create({
    data: dados,
  });
};

export const buscarFuncionarioPorId = async (id: number) => {
  return await prisma.funcionario.findUnique({
    where: { id },
  });
};

export const atualizarFuncionario = async (
  id: number,
  dados: {
    nome?: string;
    sobrenome?: string;
    cargo?: string;
    cpf?: string;
    data_admissao?: Date;
    matricula?: number;
  }
) => {
  return await prisma.funcionario.update({
    where: { id },
    data: dados,
  });
};

export const deletarFuncionario = async (id: number) => {
  return await prisma.funcionario.delete({
    where: { id },
  });
};
