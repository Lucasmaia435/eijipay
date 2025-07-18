/**
 * Este arquivo conterá toda a lógica de interação com o banco de dados via Prisma
 * Client para a entidade 'usuario'. Funções como createUser, findUserByEmail,
 * updateUser, etc., morarão aqui. É a camada responsável por manipular os dados.
 */
import bcrypt from 'bcryptjs' // Importação do bcrypt para hash de senhas
import { PrismaBetterSQLite3 } from '@prisma/adapter-better-sqlite3';
import { PrismaClient } from '@prisma/client';

const adapter = new PrismaBetterSQLite3({
  url: "file:./prisma/dev.db"
});
const prisma = new PrismaClient();

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
    const hashedPassword = await bcrypt.hash(userData.senha, 8); // Hash da senha
    return prisma.usuario.create({
      data: {
        ...userData,
        senha: hashedPassword, // Armazena a senha hasheada
      },
    });
  },

  /**
   * Busca todos os usuários.
   */
  async getAllUsers() {
    return prisma.usuario.findMany();
  },

  /**
   * Atualiza os dados de um usuário pelo email.
   */
  async updateUserByEmail(userData: {email: string, senha?: string, nome?: string, papel?: string}) {
    const { email, ...data } = userData;
    return prisma.usuario.update({
      where: { email },
      data,
    });
  },

  /**
   * Remove um usuário pelo email.
   */
  async deleteUserByEmail(email: string) {
    return prisma.usuario.delete({
      where: { email },
    });
  },

  /**
   * Desconecta o Prisma Client (útil para encerramento da aplicação ou testes).
   */
  async disconnect() {
    await prisma.$disconnect();
  },
};