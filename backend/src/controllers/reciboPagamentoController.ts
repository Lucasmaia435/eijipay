import { Request, Response } from "express";
import * as service from "../services/reciboPagamentoService";

export const getAll = async (req: Request, res: Response) => {
  const { cnpj, comp } = req.query;
  const recibos = await service.getAll(cnpj as string, comp as string);
  res.json(recibos);
};

export const getByFuncionario = async (req: Request, res: Response) => {
  const { comp } = req.params;
  const { funcCpf, cnpj } = req.query;
  const recibo = await service.getByFuncionario(
    funcCpf as string,
    cnpj as string,
    comp
  );
  if (!recibo) return res.status(404).json({ error: "Recibo não encontrado" });
  res.json(recibo);
};

export const create = async (req: Request, res: Response) => {
  const { funcionarioCpf, empregadorCnpj, competencia } = req.body;
  try {
    const recibo = await service.create({
      funcionarioCpf,
      empregadorCnpj,
      competencia,
    });
    res.status(201).json({ competencia: recibo.competencia });
  } catch (err) {
    res.status(400).json({ error: "Erro ao criar recibo" });
  }
};

export const update = async (req: Request, res: Response) => {
  const { comp } = req.params;
  const { funcCpf, cnpj } = req.query;
  const { competencia } = req.body;
  try {
    const result = await service.update(
      funcCpf as string,
      cnpj as string,
      comp,
      { competencia }
    );
    res.json({ message: "Atualizado com sucesso" });
  } catch {
    res.status(404).json({ error: "Recibo não encontrado" });
  }
};

export const remove = async (req: Request, res: Response) => {
  const { comp } = req.params;
  const { funcCpf, cnpj } = req.query;
  try {
    await service.remove(funcCpf as string, cnpj as string, comp);
    res.json({ message: "Removido com sucesso" });
  } catch {
    res.status(404).json({ error: "Recibo não encontrado" });
  }
};
