/**
 * Rotas que conecta os controladores às URIs da API
 */
import { verificarToken } from '../middlewares/authMiddleware';
import { Router } from 'express';
import { usuarioController } from '../controllers/usuarioController';

const router = Router();

// Rotas públicas
router.post('/login', usuarioController.login);                     // POST /users/login
router.post('/new', usuarioController.createNewUser);               // POST /users/new

// Rotas protegidas
router.get('/', verificarToken, usuarioController.getAllUsers);             // GET /users
router.get('/:id', verificarToken, usuarioController.getUserById);          // GET /users/:id;                  // GET /users/:id
router.put('/update', verificarToken, usuarioController.updateUserByEmail);         // PUT /users/update
router.delete('/delete', verificarToken, usuarioController.deleteUserByEmail);      // DELETE /users/delete

export default router;