import { Router } from "express";
import * as controller from "../controllers/empregadorController";
import { verificarToken } from "../middlewares/authMiddleware";

const router = Router();

router.get("/", verificarToken, controller.getAll);
router.get("/:cnpj", verificarToken, controller.getByCnpj);
router.post("/", verificarToken, controller.create);
router.put("/:cnpj", verificarToken, controller.update);
router.delete("/:cnpj", verificarToken, controller.remove);

export default router;
