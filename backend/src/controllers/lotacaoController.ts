import { Request, Response } from "express";
import { lotacaoService } from "../services/lotacaoService";

export const lotacaoController = {
  async listar(req: Request, res: Response) {
    const lotacoes = await lotacaoService.listarTodas();
    return res.status(200).json(lotacoes);
  },

  async buscarPorCodigo(req: Request, res: Response) {
    const codigo = req.params.codigo; // agora é string
    const lotacao = await lotacaoService.buscarPorCodigo(codigo);
    if (!lotacao) {
      return res.status(404).json({ message: "Lotação não encontrada." });
    }
    return res.status(200).json(lotacao);
  },

  async criar(req: Request, res: Response) {
    const { nome } = req.body;
    if (!nome) {
      return res
        .status(400)
        .json({ message: "Nome da lotação é obrigatório." });
    }

    try {
      const nova = await lotacaoService.criar(nome);
      return res.status(201).json({ codigo: nova.codigo });
    } catch (err) {
      console.error(err);
      return res.status(500).json({ message: "Erro ao criar lotação." });
    }
  },

  async atualizar(req: Request, res: Response) {
    const codigo = req.params.codigo; // agora é string
    const { nome } = req.body;

    try {
      const atualizada = await lotacaoService.atualizar(codigo, nome);
      return res.status(200).json(atualizada);
    } catch (err) {
      return res.status(404).json({ message: "Lotação não encontrada." });
    }
  },

  async deletar(req: Request, res: Response) {
    const codigo = req.params.codigo; // agora é string

    try {
      await lotacaoService.deletar(codigo);
      return res.status(200).json({ message: "Lotação deletada com sucesso." });
    } catch (err) {
      return res.status(404).json({ message: "Lotação não encontrada." });
    }
  },
};
