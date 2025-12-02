# 🚀 Gestão de Projetos — Flutter Web

Sistema de **gestão de projetos e tarefas** desenvolvido em **Flutter Web**, com foco em arquitetura, experiência de uso e visual profissional inspirado em dashboards SaaS modernos.

O projeto simula uma aplicação real de gestão, permitindo organizar projetos, acompanhar tarefas e visualizar o fluxo de trabalho de forma clara e intuitiva.

---

## 📸 Preview do Projeto

<img src="https://github.com/user-attachments/assets/3527f5cd-d0bc-444c-893e-e04e43d17681" />
<img src="https://github.com/user-attachments/assets/ebea5d8d-9d10-4fb2-b831-1b523217feee" />
<img src="https://github.com/user-attachments/assets/4c53ddd9-8995-4f5e-8ea7-0eb3852f53f3" />
<img src="https://github.com/user-attachments/assets/150d0b85-d50b-452e-be3c-f34d4a33bd69" />
<img src="https://github.com/user-attachments/assets/efbf9fcb-1e2a-4564-8c65-2689db902c48" />

---

## 🧩 O que é o projeto?

É uma aplicação web onde o usuário pode:

- Criar, editar e visualizar projetos
- Gerenciar tarefas vinculadas a cada projeto
- Organizar tarefas em um **board Kanban**
- Arrastar tarefas entre colunas (drag and drop)
- Acompanhar status, progresso e prioridades
- Utilizar a aplicação em modo claro ou escuro

O objetivo do projeto é consolidar boas práticas no desenvolvimento com Flutter Web, indo além de exemplos simples ou apps de estudo.

---

## ✨ Principais Funcionalidades

- ✅ Autenticação com API fake
- ✅ Persistência de sessão
- ✅ Proteção de rotas
- ✅ CRUD de projetos
- ✅ CRUD de tarefas
- ✅ Board Kanban com drag and drop
- ✅ Paginação, busca e filtros
- ✅ Layout em Shell (sidebar + conteúdo)
- ✅ Tema claro e escuro
- ✅ Design system próprio
- ✅ UI moderna e consistente

---

## 🛠️ Tecnologias Utilizadas

- **Flutter Web**
- **Dart**
- **Provider** (gerenciamento de estado)
- **go_router** (navegação)
- **Material 3 (customizado)**

---

## 🎨 Design & UI

O projeto utiliza um **design system próprio**, composto por:

- Paleta de cores personalizada
- Tokens de borda, espaçamento e tipografia
- Componentes flat e modernos
- Dark Mode pensado desde o início
- Visual inspirado em dashboards SaaS e produtos web reais

Todo o tema é centralizado em arquivos dedicados (`AppColors` e `AppTheme`), facilitando manutenção e evolução.

---

## 🧠 Arquitetura

A aplicação segue uma organização focada em separação de responsabilidades:

- **Pages**: telas da aplicação
- **ViewModels**: regras de negócio e estado
- **Services**: comunicação com API fake
- **Models**: entidades do domínio
- **Theme**: design system centralizado

Esse formato facilita testes, manutenção e escalabilidade do projeto.

---

## ▶️ Como rodar o projeto

```bash
# Clonar o repositório
git clone https://github.com/Biguelini/gestao-de-projetos-flutter.git

# Entrar na pasta
cd gestao-de-projetos-flutter

# Instalar dependências
flutter pub get

# Rodar no navegador
flutter run -d chrome
``` 
