/**
 * Este arquivo conterá as funções que serão ligadas às rotas da sua API Express.
 * Elas receberão as requisições HTTP, chamarão as funções apropriadas do usuarioService
 * e enviarão as respostas HTTP. É a camada responsável por lidar com as requisições e respostas da web.
 */
import { Request, Response } from 'express';
import { usuarioService } from '../services/usuarioService'; // Importa o serviço de usuário
import jwt from 'jsonwebtoken';
import bcrypt from 'bcryptjs';

const SECRET_KEY = process.env.JWT_SECRET || 'chave-secreta-padrao';

export const usuarioController = {

  /**
   * [GET /users] Busca todos os usuários.
   */
  async getAllUsers(req: Request, res: Response): Promise<Response> {
    try {
      const usuarios = await usuarioService.getAllUsers();
      // Remova a senha de cada usuário antes de enviar a resposta
      const usuariosSemSenha = usuarios.map(usuario => {
        const { senha, ...usuarioSemSenha } = usuario;
        return usuarioSemSenha;
      });
      return res.status(200).json(usuariosSemSenha);
    } catch (error) {
      console.error('Erro ao buscar todos os usuários:', error);
      return res.status(500).json({ message: 'Erro interno do servidor ao buscar usuários.' });
    }
  },

  /**
   * [GET /users/:id] Busca um usuário pelo ID.
   */
  async getUserById(req: Request, res: Response): Promise<Response> {
    try {
      const id = parseInt(req.params.id);
      if (isNaN(id)) {
        return res.status(400).json({ message: 'ID de usuário inválido.' });
      }

      const usuario = await usuarioService.findUserById(id);
      if (usuario) {
        // Remova a senha antes de enviar a resposta por segurança
        // Omitir explicitamente a propriedade "senha" é uma boa prática
        const { senha, ...usuarioSemSenha } = usuario;
        return res.status(200).json(usuarioSemSenha);
      } else {
        return res.status(404).json({ message: 'Usuário não encontrado.' });
      }
    } catch (error) {
      console.error('Erro ao buscar usuário por ID:', error);
      // Em um ambiente de produção, evite enviar detalhes do erro diretamente ao cliente.
      // Apenas uma mensagem genérica de erro interno do servidor é suficiente.
      return res.status(500).json({ message: 'Erro interno do servidor ao buscar usuário.' });
    }
  },

  /**
   * [POST /users/new] Cria um novo usuário
   */
  async createNewUser(req: Request, res: Response): Promise<Response> {
    try {
      const { email, senha, nome, papel } = req.body;

      // Verificação dos dados fornecidos
      if (!email || !senha || !nome || !papel) {
        return res.status(400).json({ message: 'E-mail, senha, nome e papel são obrigatórios.' });
      }

      // Verificar se já existe um usuário com o mesmo email
      const existingUser = await usuarioService.findUserByEmail(email);
      if (existingUser) {
        return res.status(409).json({ message: 'Já existe um usuário com este email.' });
      }

      // const hashedPassword = await bcrypt.hash(senha, 8);  // Salva o hash bcrypt 

      // Criação do usuário com a senha hasheada com bcrypt
      const newUser = await usuarioService.createNewUser({ email, senha, nome, papel });

      // Remova a senha antes de enviar a resposta
      const { senha: newPassword, ...usuarioSemSenha } = newUser;
      return res.status(201).json(usuarioSemSenha);
    } catch (error) {
      console.error('Erro ao criar novo usuário:', error);
      return res.status(500).json({ message: 'Erro interno do servidor ao criar usuário.' });
    }
  },

  /**
   * [POST /users/login] Autentica um usuário.
   */
  async login(req: Request, res: Response): Promise<Response> {
    try {
      const { email, senha } = req.body;

      console.log(`[LOGIN] Tentativa de login para o email: ${email}`);

      if (!email || !senha) {
        console.warn('[LOGIN] Email ou senha não fornecidos.');
        return res.status(400).json({ message: 'Email e senha são obrigatórios para o login.' });
      }

      const usuario = await usuarioService.findUserByEmail(email);
      if (!usuario) {
        console.warn(`[LOGIN] Usuário não encontrado para o email: ${email}`);
        return res.status(401).json({ message: 'Credenciais inválidas.' });
      }

      // **Depois**, compara com o hash bcrypt da senha
      const isPasswordValid = await bcrypt.compare(senha, usuario.senha);
      if (!isPasswordValid) {
        console.warn(`[LOGIN] Senha inválida para o email: ${email}`);
        return res.status(401).json({ message: 'Creden inválidas.' });
      }

      // Geração do token JWT
      const token = jwt.sign(
        { id: usuario.id, email: usuario.email, papel: usuario.papel },
        SECRET_KEY,
        { expiresIn: '1h' }
      );

      console.log(`[LOGIN] Login bem-sucedido para o email: ${email}`);

      const { senha: _, ...usuarioSemSenha } = usuario;
      return res.status(200).json({
        message: 'Login bem-sucedido!',
        token,
        usuario: usuarioSemSenha,
      });
    } catch (error) {
      console.error('Erro durante o login:', error);
      return res.status(500).json({ message: 'Erro interno do servidor durante o login.' });
    }
  },

  /**
   * [PUT /users/update] Altera os dados de um usuário pelo email.
   */
  async updateUserByEmail(req: Request, res: Response): Promise<Response> {
    try {
      const { email, senha, nome, papel } = req.body;

      if (!email) {
        return res.status(400).json({ message: 'O campo email é obrigatório para atualização.' });
      }

      // Verifica se o usuário existe antes de tentar atualizar
      const usuarioExistente = await usuarioService.findUserByEmail(email);
      if (!usuarioExistente) {
        return res.status(404).json({ message: 'Usuário não encontrado.' });
      }

      // Verifica se pelo menos um campo foi enviado para atualização (exceto email)
      if (!senha && !nome && !papel) {
        return res.status(400).json({ message: 'Informe ao menos um campo para atualizar.' });
      }

      const usuarioAtualizado = await usuarioService.updateUserByEmail({
        email,
        senha,
        nome,
        papel,
      });

      // Remove a senha antes de enviar a resposta
      const { senha: _, ...usuarioSemSenha } = usuarioAtualizado;
      return res.status(200).json(usuarioSemSenha);
    } catch (error) {
      console.error('Erro ao atualizar usuário:', error);
      return res.status(500).json({ message: 'Erro interno do servidor ao atualizar usuário.' });
    }
  },

  /**
   * [DELETE /users/delete] Remove um usuário pelo email.
   */
  async deleteUserByEmail(req: Request, res: Response): Promise<Response> {
    try {
      const { email } = req.body;

      if (!email) {
        return res.status(400).json({ message: 'O campo email é obrigatório para exclusão.' });
      }

      const usuarioExistente = await usuarioService.findUserByEmail(email);
      if (!usuarioExistente) {
        return res.status(404).json({ message: 'Usuário não encontrado.' });
      }

      await usuarioService.deleteUserByEmail(email);
      return res.status(200).json({ message: 'Usuário excluído com sucesso.' });
    } catch (error) {
      console.error('Erro ao excluir usuário:', error);
      return res.status(500).json({ message: 'Erro interno do servidor ao excluir usuário.' });
    }
  },
};