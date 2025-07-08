import express from 'express';
import usuarioRoutes from './routes/usuarioRoutes'; // Importa as rotas de usuário
import dotenv from 'dotenv';
dotenv.config(); // Carrega as variáveis de ambiente do arquivo .env

/**
 *  Responsável por configurar a aplicação Express (middlewares, rotas, etc.)
 */

const app = express();

// Middleware para parsear JSON no corpo das requisições
app.use(express.json());

// Usar as rotas de usuário (montar roteadores)
app.use('/users', usuarioRoutes);

// Rota de teste
app.get('/', (req, res) => {
  res.send('TESTE: API de Usuários com Prisma ORM e Express!');
});

// Mensagem mais específica para o que este arquivo faz
console.log('Aplicação Express configurada.');

// Exporta a instância 'app' como a exportação padrão do módulo
export default app;