// bin/www.ts
//#!/usr/bin/env ts-node-script
// ^^^ NOTA: Se você for executar este arquivo diretamente via shebang em sistemas Unix-like,
// e se 'ts-node-dev' estiver disponível no PATH, você pode mantê-lo.
// No entanto, para o uso via 'npm run dev', o shebang é desnecessário e pode ser removido.
// Mantenha-o apenas se for executar 'bin/www.ts' com permissão de execução diretamente.
// Para a maioria dos casos com 'npm run dev', a linha abaixo não é necessária.

/**
 * Module dependencies.
 */
import 'dotenv/config';         // Carrega as variáveis de ambiente antes da aplicação rodar
import app from '../app';   // Importa a instância do Express configurada
import debug from 'debug';
import http from 'http';

/**
 * responsável por iniciar o servidor HTTP usando a aplicação configurada e gerenciar seu ciclo
 * de vida (porta, tratamento de erros de servidor, desligamento gracioso).
 */

// Importa o serviço de usuário para desconectar o Prisma Client durante o desligamento
import { usuarioService } from '../services/usuarioService';

const debugServer = debug('test-node-express:server');

/**
 * Get port from environment and store in Express.
 */
const port = normalizePort(process.env.PORT || '3000');
app.set('port', port); // Define a porta na instância do Express

/**
 * Create HTTP server.
 */
const server = http.createServer(app);

/**
 * Listen on provided port, on all network interfaces.
 */
server.listen(port);
server.on('error', onError);
server.on('listening', onListening);

/**
 * Normalize a port into a number, string, or false.
 */
function normalizePort(val: string): number | string | boolean {
  const port = parseInt(val, 10);

  if (isNaN(port)) {
    // named pipe
    return val;
  }

  if (port >= 0) {
    // port number
    return port;
  }

  return false;
}

/**
 * Event listener for HTTP server "error" event.
 */
function onError(error: NodeJS.ErrnoException) {
  if (error.syscall !== 'listen') {
    throw error;
  }

  const bind = typeof port === 'string'
    ? 'Pipe ' + port
    : 'Port ' + port;

  // handle specific listen errors with friendly messages
  switch (error.code) {
    case 'EACCES':
      console.error(bind + ' requires elevated privileges');
      process.exit(1);
      break;
    case 'EADDRINUSE':
      console.error(bind + ' is already in use');
      process.exit(1);
      break;
    default:
      throw error;
  }
}

/**
 * Event listener for HTTP server "listening" event.
 */
function onListening() {
  const addr = server.address();
  let bind: string;

  if (addr === null) {
    bind = 'pipe (unknown address)';
    debugServer('Server is listening but address is null. This might indicate an issue.');
  } else if (typeof addr === 'string') {
    bind = 'pipe ' + addr;
  } else {
    bind = 'port ' + addr.port;
  }
  debugServer('Listening on ' + bind);
  console.log(`Servidor rodando em http://localhost:${addr ? (typeof addr === 'string' ? addr : addr.port) : port}`);
}

/**
 * Função para lidar com o desligamento gracioso.
 * Esta função centraliza a lógica de fechamento do servidor e desconexão do Prisma.
 */
const gracefulShutdown = async (signal: string) => {
  console.log(`Sinal de desligamento (${signal}) recebido. Desligando servidor...`);
  // Desconecta o Prisma Client antes de fechar o servidor
  await usuarioService.disconnect();

  // Fecha o servidor HTTP
  server.close(() => {
    console.log('Servidor Express e Prisma Client desconectados. Encerrando processo.');
    process.exit(0); // Encerra o processo com sucesso
  });

  // Opcional: Forçar o encerramento se o servidor não fechar em um tempo razoável
  setTimeout(() => {
    console.error('Forçando desligamento: Servidor não fechou a tempo.');
    process.exit(1); // Encerra o processo com erro
  }, 10000).unref(); // Desreferencia o timer para não impedir o encerramento se tudo já estiver pronto
};

// Lidar com o desligamento gracioso para diferentes sinais do sistema
process.on('SIGINT', () => gracefulShutdown('SIGINT')); // Captura Ctrl+C
process.on('SIGTERM', () => gracefulShutdown('SIGTERM')); // Captura sinais de término (ex: kill, orquestradores)

// Lidar com erros não capturados para um desligamento mais robusto
process.on('unhandledRejection', (reason, promise) => {
  console.error('Unhandled Rejection at:', promise, 'reason:', reason);
  // Não necessariamente um erro fatal, mas bom registrar. Pode-se optar por não sair aqui
  // para permitir que outros handlers capturem erros. Para casos críticos, pode-se sair.
  process.exit(1);
});

process.on('uncaughtException', (error) => {
  console.error('Uncaught Exception:', error);
  // Este é um erro grave, é crucial sair para evitar um estado inconsistente
  process.exit(1);
});

console.log('Aplicação iniciada com sucesso (processo de inicialização do www.ts).');