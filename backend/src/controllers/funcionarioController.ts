import { Request, Response } from "express";
import { criarFuncionario } from "../services/funcionarioService";

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
