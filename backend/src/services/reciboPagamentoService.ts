import { PrismaClient } from "@prisma/client";
const prisma = new PrismaClient();

export const getAll = async (cnpj: string, competencia: string) => {
  return prisma.reciboPagamento.findMany({
    where: { empregadorCnpj: cnpj, competencia },
  });
};

export const getByFuncionario = async (
  funcionarioCpf: string,
  cnpj: string,
  competencia: string
) => {
  return prisma.reciboPagamento.findUnique({
    where: {
      funcionarioCpf_empregadorCnpj_competencia: {
        funcionarioCpf,
        empregadorCnpj: cnpj,
        competencia,
      },
    },
  });
};

export const create = async (data: {
  funcionarioCpf: string;
  empregadorCnpj: string;
  competencia: string;
}) => {
  return prisma.reciboPagamento.create({ data });
};

export const update = async (
  funcionarioCpf: string,
  cnpj: string,
  competencia: string,
  novosDados: { competencia?: string }
) => {
  return prisma.reciboPagamento.update({
    where: {
      funcionarioCpf_empregadorCnpj_competencia: {
        funcionarioCpf,
        empregadorCnpj: cnpj,
        competencia,
      },
    },
    data: novosDados,
  });
};

export const remove = async (
  funcionarioCpf: string,
  cnpj: string,
  competencia: string
) => {
  return prisma.reciboPagamento.delete({
    where: {
      funcionarioCpf_empregadorCnpj_competencia: {
        funcionarioCpf,
        empregadorCnpj: cnpj,
        competencia,
      },
    },
  });
};
