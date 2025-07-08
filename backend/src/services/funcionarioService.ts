import { PrismaClient } from "@prisma/client";
const prisma = new PrismaClient();

export const criarFuncionario = async (dados: {
  nome: string;
  sobrenome: string;
  cpf: string;
  cargo: string;
  data_admissao: Date;
  usuario_id: number;
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
