import { Request, Response } from "express";
import * as service from "../services/empregadorService";

export const getAll = async (req: Request, res: Response) => {
  const empregadores = await service.getAll();
  res.json(empregadores);
};

export const getByCnpj = async (req: Request, res: Response) => {
  const { cnpj } = req.params;
  const empregador = await service.getByCnpj(cnpj);
  if (!empregador)
    return res.status(404).json({ error: "Empregador não encontrado" });
  res.json(empregador);
};

export const create = async (req: Request, res: Response) => {
  const { cnpj, razao_social } = req.body;
  try {
    const novo = await service.create(cnpj, razao_social);
    res.status(201).json({ cnpj: novo.cnpj });
  } catch (err) {
    res.status(400).json({ error: "Erro ao criar empregador" });
  }
};

export const update = async (req: Request, res: Response) => {
  const { cnpj } = req.params;
  const { razao_social } = req.body;
  try {
    await service.update(cnpj, razao_social);
    res.json({ message: "Empregador atualizado com sucesso" });
  } catch {
    res.status(404).json({ error: "Empregador não encontrado" });
  }
};

export const remove = async (req: Request, res: Response) => {
  const { cnpj } = req.params;
  try {
    await service.remove(cnpj);
    res.json({ message: "Empregador removido com sucesso" });
  } catch {
    res.status(404).json({ error: "Empregador não encontrado" });
  }
};
