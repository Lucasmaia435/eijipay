import { Router } from "express";
import * as controller from "../controllers/empregadorController";

const router = Router();

router.get("/", controller.getAll);
router.get("/:cnpj", controller.getByCnpj);
router.post("/", controller.create);
router.put("/:cnpj", controller.update);
router.delete("/:cnpj", controller.remove);

export default router;
