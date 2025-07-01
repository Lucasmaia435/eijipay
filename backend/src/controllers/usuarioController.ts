/**
 * Este arquivo conterá as funções que serão ligadas às rotas da sua API Express.
 * Elas receberão as requisições HTTP, chamarão as funções apropriadas do usuarioService
 * e enviarão as respostas HTTP. É a camada responsável por lidar com as requisições e respostas da web.
 */
import { Request, Response } from 'express';
import { usuarioService } from '../services/usuarioService'; // Importa o serviço de usuário

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

};