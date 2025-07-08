import express from "express";
import { postFuncionario } from "../controllers/funcionarioController";
import { getFuncionarioPorId } from "../controllers/funcionarioController";
import { putFuncionario } from "../controllers/funcionarioController";
import { deleteFuncionario } from "../controllers/funcionarioController";
import { getFuncionariosPorUsuario } from "../controllers/funcionarioController";

const router = express.Router();

router.get("/", getFuncionariosPorUsuario);

router.post("/new", postFuncionario);

router.get("/:id", getFuncionarioPorId);

router.put("/:id", putFuncionario);

router.delete("/:id", deleteFuncionario);

export default router;
