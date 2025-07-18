import express from "express";
import usuarioRoutes from "./routes/usuarioRoutes"; // Importa as rotas de usuário
import funcionarioRoutes from "./routes/funcionarioRoutes";
import empregadorRoutes from "./routes/empregadorRoutes";
import reciboPagamentoRouter from "./routes/reciboPagamentoRoutes";
import lotacaoRpoutes from "./routes/lotacaoRoutes"; // Importa as rotas de lotação
import dotenv from "dotenv";

dotenv.config(); // Carrega as variáveis de ambiente do arquivo .env

/**
 *  Responsável por configurar a aplicação Express (middlewares, rotas, etc.)
 */

const app = express();

// Middleware para parsear JSON no corpo das requisições
app.use(express.json());

app.use("/rec-pagto", reciboPagamentoRouter);

// Rotas a serem usadas (montar roteadores)
app.use("/users", usuarioRoutes);
app.use("/funcionarios", funcionarioRoutes);
app.use("/empregador", empregadorRoutes);

app.use("/lotacoes", lotacaoRpoutes);
// Rota de teste
app.get("/", (req, res) => {
  res.send("TESTE: API de Usuários com Prisma ORM e Express!");
});

// Mensagem mais específica para o que este arquivo faz
console.log("Aplicação Express configurada.");

// Exporta a instância 'app' como a exportação padrão do módulo
export default app;
