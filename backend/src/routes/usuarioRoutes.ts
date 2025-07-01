/**
 * Rotas que conecta os controladores às URIs da API
 */

import { Router } from 'express';
import { usuarioController } from '../controllers/usuarioController';

const router = Router();

// Rotas para CRUD de usuários
router.post('/new', usuarioController.createNewUser);       // POST /users/new
router.get('/', usuarioController.getAllUsers);             // GET /users

export default router;