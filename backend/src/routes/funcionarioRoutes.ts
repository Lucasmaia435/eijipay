import express from "express";
import { postFuncionario } from "../controllers/funcionarioController";

const router = express.Router();

router.post("/funcionarios/new", postFuncionario);

export default router;
