import express from "express";
import { getAllFuncionarios } from "../controllers/funcionarioController";
import { postFuncionario } from "../controllers/funcionarioController";
import { getFuncionarioPorId } from "../controllers/funcionarioController";
import { putFuncionario } from "../controllers/funcionarioController";
import { deleteFuncionario } from "../controllers/funcionarioController";

const router = express.Router();
//todos os funcinarios de um usuario
router.get("/", getAllFuncionarios);

router.post("/new", postFuncionario);

router.get("/:id", getFuncionarioPorId);

router.put("/:id", putFuncionario);

router.delete("/:id", deleteFuncionario);

export default router;
