import { PrismaClient } from '@prisma/client';
import bcrypt from 'bcryptjs';

const prisma = new PrismaClient();

async function main() {
  // Criptografa a senha padrão
  const senhaHash = await bcrypt.hash('12345678', 8);

  // Cria usuário admin
  const usuario = await prisma.usuario.upsert({
    where: { email: 'admin@ifrn.edu.br' },
    update: {},
    create: {
      nome: 'Administrador',
      email: 'admin@ifrn.edu.br',
      senha: senhaHash,
      papel: 'admin',
    },
  });

  // Cria empregador
  const empregador = await prisma.empregador.upsert({
    where: { cnpj: '12345678000199' },
    update: {},
    create: {
      cnpj: '12345678000199',
      razao_social: 'IFRN - Instituto Federal',
    },
  });

  // Cria lotação
  const lotacao = await prisma.lotacao.upsert({
    where: { codigo: 'TI' },
    update: {},
    create: {
      codigo: 'TI',
      nome: 'Tecnologia da Informação',
    },
  });

  // Cria funcionário vinculado ao empregador e à lotação
  const funcionario = await prisma.funcionario.upsert({
    where: { cpf: '11122233344' },
    update: {},
    create: {
      nome: 'João da Silva',
      sobrenome: 'Silva',
      cargo: 'Analista de Sistemas',
      cpf: '11122233344',
      data_admissao: new Date('2022-01-15'),
      matricula: 12345,
      empregadorCnpj: empregador.cnpj,
      lotacaoCodigo: lotacao.codigo,
    },
  });

  console.log('Seed concluído com sucesso!');
}

main()
  .catch((e) => {
    console.error('Erro no seed:', e);
    process.exit(1);
  })
  .finally(async () => {
    await prisma.$disconnect();
  });
