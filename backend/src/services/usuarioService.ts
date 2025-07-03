/**
 * Este arquivo conterá toda a lógica de interação com o banco de dados via Prisma
 * Client para a entidade 'usuario'. Funções como createUser, findUserByEmail,
 * updateUser, etc., morarão aqui. É a camada responsável por manipular os dados.
 */
import { PrismaClient } from '@prisma/client'              // Importação padrão do PrismaClient
import { withAccelerate } from '@prisma/extension-accelerate'

// Instancia o Prisma Client, passando a extensão Accelerate
const prisma = new PrismaClient().$extends(withAccelerate());

export const usuarioService = {

  /**
   * Busca um usuário pelo ID.
   */
  async findUserById(id: number) {
    return prisma.usuario.findUnique({
      where: { id },
    });
  },

  /**
   * Busca um usuário pelo email.
   */
  async findUserByEmail(email: string) {
    return prisma.usuario.findUnique({
      where: { email },
    });
  },

  /**
   * Cria um novo usuário.
   */
  async createNewUser(userData: {email: string, senha: string, nome:  string, papel: string}) {
    return prisma.usuario.create({
      data: userData,
    });
  },

  /**
   * Busca todos os usuários.
   */
  async getAllUsers() {
    return prisma.usuario.findMany();
  },
  
  /**
   * Desconecta o Prisma Client (útil para encerramento da aplicação ou testes).
   */
  async disconnect() {
    await prisma.$disconnect();
  },
};