# API Eijipay

API backend desenvolvido como parte do curso de Processos de Software da UFRN.

## 🚀 Tecnologias

- Node.js 22.14.0
- Framework Express.js 5.1.0
- TypeScript 5.8.3
- Prisma ORM
- Banco de Dados Prisma Postgre (online)
- Prisma Data Platform

# 🛠️ Antes de executar a API
1. Criar um arquivo "backend/.env" na pasta **backend**
2. Adicionar a chave URL/Api Key no arquivo **.env**
3. No terminal: instalar as dependências: **npm install**
4. Executar a API conforme abaixo
5. No terminal: visualizar/manipular o banco de dados (caso deseje):
   - **npx prisma studio** ou via navegador

# 📦 Executar a API

## Rodar em desenvolvimento

Use durante o desenvolvimento para ter recarregamento automático e execução direta do TypeScript.

    > npm run dev

## Rodar antes do deploy

Antes de implantar em produção, sempre execute para compilar seu código.

    > npm run build

## Rodar em produção

Em produção, execute este comando, que executará a versão compilada em JavaScript do seu aplicativo.

    > npm run start

## 🌐 Acessar a API via navegador

    http://localhost:3000/

