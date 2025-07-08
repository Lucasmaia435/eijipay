import express from "express";
import { postFuncionario } from "../controllers/funcionarioController";
import { getFuncionarioPorId } from "../controllers/funcionarioController";

const router = express.Router();

router.post("/new", postFuncionario);

router.get("/:id", getFuncionarioPorId);

export default router;
