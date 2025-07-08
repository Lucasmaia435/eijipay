import { Request, Response } from "express";
import { criarFuncionario } from "../services/funcionarioService";
import { buscarFuncionarioPorId } from "../services/funcionarioService";

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
