import express from "express";
import { postFuncionario } from "../controllers/funcionarioController";

const router = express.Router();

router.post("/new", postFuncionario);

export default router;
