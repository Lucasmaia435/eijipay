/**
 * Rotas que conecta os controladores às URIs da API
 */
import { verificarToken } from '../middlewares/authMiddleware';
import { Router } from 'express';
import { usuarioController } from '../controllers/usuarioController';

const router = Router();

// Rotas para CRUD de usuários
router.post('/login', usuarioController.login);                     // POST /users/login
router.post('/new', usuarioController.createNewUser);               // POST /users/new
router.get('/', verificarToken, usuarioController.getAllUsers);             // GET /users
router.get('/:id', verificarToken, usuarioController.getUserById);          // GET /users/:id;                  // GET /users/:id
router.put('/update', usuarioController.updateUserByEmail);         // PUT /users/update
router.delete('/delete', usuarioController.deleteUserByEmail);      // DELETE /users/delete

export default router;