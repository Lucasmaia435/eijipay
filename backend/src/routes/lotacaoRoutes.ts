import { Router } from "express";
import { lotacaoController } from "../controllers/lotacaoController";
// import { verificarToken } from '../middlewares/authMiddleware'; // caso deseje proteger as rotas

const router = Router();

router.get("/", lotacaoController.listar);
router.get("/:codigo", lotacaoController.buscarPorCodigo);
router.post("/", lotacaoController.criar);
router.put("/:codigo", lotacaoController.atualizar);
router.delete("/:codigo", lotacaoController.deletar);

export default router;
