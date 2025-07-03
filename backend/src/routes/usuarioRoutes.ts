/**
 * Rotas que conecta os controladores às URIs da API
 */

import { Router } from 'express';
import { usuarioController } from '../controllers/usuarioController';

const router = Router();

// Rotas para CRUD de usuários
router.post('/login', usuarioController.login);             // POST /users/login
router.post('/new', usuarioController.createNewUser);       // POST /users/new
router.get('/', usuarioController.getAllUsers);             // GET /users
router.get('/:id', usuarioController.getUserById);          // GET /users/:id
router.put('/update', usuarioController.updateUserByEmail); // PUT /users/update

export default router;