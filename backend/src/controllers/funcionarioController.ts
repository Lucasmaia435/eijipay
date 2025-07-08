import { Request, Response } from "express";
import { criarFuncionario } from "../services/funcionarioService";
import { buscarFuncionarioPorId } from "../services/funcionarioService";
import { atualizarFuncionario } from "../services/funcionarioService";
import { deletarFuncionario } from "../services/funcionarioService";

export const postFuncionario = async (req: Request, res: Response) => {
  try {
    const { nome, sobrenome, cpf, cargo, data_admissao, usuario_id } = req.body;

    if (
      !nome ||
      !sobrenome ||
      !cpf ||
      !cargo ||
      !data_admissao ||
      !usuario_id
    ) {
      return res.status(400).json({ error: "Campos obrigatórios ausentes." });
    }

    const novo = await criarFuncionario({
      nome,
      sobrenome,
      cpf,
      cargo,
      data_admissao: new Date(data_admissao),
      usuario_id,
    });

    return res.status(201).json({ id: novo.id });
  } catch (error) {
    console.error(error);
    return res.status(500).json({ error: "Erro ao criar funcionário." });
  }
};

export const getFuncionarioPorId = async (req: Request, res: Response) => {
  const id = Number(req.params.id);

  if (isNaN(id)) {
    return res.status(400).json({ error: "ID inválido." });
  }

  const funcionario = await buscarFuncionarioPorId(id);

  if (!funcionario) {
    return res.status(404).json({ error: "Funcionário não encontrado." });
  }

  return res.status(200).json(funcionario);
};

export const putFuncionario = async (req: Request, res: Response) => {
  const id = Number(req.params.id);
  const { nome, sobrenome, cpf, cargo, data_admissao } = req.body;

  if (isNaN(id)) {
    return res.status(400).json({ error: "ID inválido." });
  }

  try {
    const funcionarioAtualizado = await atualizarFuncionario(id, {
      nome,
      sobrenome,
      cpf,
      cargo,
      data_admissao: data_admissao ? new Date(data_admissao) : undefined,
    });

    return res.status(200).json(funcionarioAtualizado);
  } catch (error: any) {
    if (error.code === "P2025") {
      return res.status(404).json({ error: "Funcionário não encontrado." });
    }
    console.error(error);
    return res.status(500).json({ error: "Erro ao atualizar funcionário." });
  }
};

export const deleteFuncionario = async (req: Request, res: Response) => {
  const id = Number(req.params.id);

  if (isNaN(id)) {
    return res.status(400).json({ error: "ID inválido." });
  }

  try {
    await deletarFuncionario(id);
    return res.sendStatus(204); // Sucesso: sem conteúdo
  } catch (error: any) {
    if (error.code === "P2025") {
      return res.status(404).json({ error: "Funcionário não encontrado." });
    }
    console.error(error);
    return res.status(500).json({ error: "Erro ao deletar funcionário." });
  }
};
