# Sistema de Gestão Escolar - Frontend

Este projeto é o frontend do Sistema de Gestão Escolar, desenvolvido em Vue.js. Ele complementa a API construída em Spring Boot, oferecendo uma interface amigável para usuários administradores, professores, alunos e responsáveis gerenciarem suas atividades escolares.

## Funcionalidades

### Gestão de Usuários

- **Autenticação de usuários**: login seguro para administradores, professores, alunos e responsáveis.
- **Gerenciamento de perfis**: atualização de informações pessoais, fotos de perfil e preferências de contato.

### Gestão Acadêmica

- **Matrículas e transferências**:
  - Interface para cadastro de novos alunos.
  - Processamento de transferências entre escolas.
  - Visualização de histórico acadêmico.

- **Gestão de turmas e cursos**:
  - Criação e gerenciamento de turmas.
  - Alocação de alunos e professores às turmas.
  - Visualização de horários de aula.

- **Calendário acadêmico e eventos escolares**:
  - Planificação e visualização do calendário escolar.
  - Gestão de eventos escolares como reuniões de pais, feiras científicas e outros eventos.
  - Notificações automáticas de eventos.

### Gestão de Notas e Frequência

- **Lançamento e consulta de notas**:
  - Inserção de notas por professores.
  - Consulta de notas por alunos e responsáveis.
  - Emissão de boletins e relatórios de desempenho.

- **Controle de frequência**:
  - Registro de presença/ausência de alunos.
  - Relatórios de frequência para alunos e turmas.
  - Notificações para responsáveis sobre faltas.

### Gestão de Disciplinas e Currículo

- **Cadastro e gerenciamento de disciplinas**:
  - Criação e edição de disciplinas.
  - Atribuição de disciplinas aos cursos e turmas.
  - Definição de pré-requisitos e equivalências.

- **Definição de currículo escolar**:
  - Estruturação de currículos para diferentes níveis de ensino.
  - Acompanhamento do progresso do currículo.

- **Planificação e organização de horários de aulas**:
  - Criação de horários de aula.
  - Ajuste e reprogramação de horários conforme necessário.
  - Visualização de horários por alunos, professores e turmas.

### Comunicação

- **Envio de mensagens e notificações**:
  - Mensagens internas entre usuários.
  - Notificações automáticas e manuais para eventos, notas, faltas, etc.
  - Integração com e-mail e SMS para notificações externas.

- **Mural de avisos e comunicados**:
  - Publicação de avisos gerais para toda a escola.
  - Comunicados específicos para turmas ou grupos de usuários.

### Gestão Financeira

- **Controle de mensalidades e pagamentos**:
  - Cadastro de planos de pagamento e mensalidades.
  - Emissão e acompanhamento de faturas.
  - Registro de pagamentos e débitos.

- **Emissão de boletos e faturas**:
  - Geração automática de boletos bancários.
  - Envio de faturas por e-mail.

- **Relatórios financeiros**:
  - Relatórios detalhados de receitas e despesas.
  - Análise financeira por período, turma, etc.

### Biblioteca

- **Gerenciamento de acervo bibliográfico**:
  - Cadastro e catalogação de livros e outros materiais.
  - Consulta ao acervo disponível.

- **Empréstimo e devolução de livros**:
  - Registro de empréstimos e devoluções.
  - Controle de prazos e multas por atraso.

- **Consulta de disponibilidade de títulos**:
  - Sistema de busca e reserva de livros.

### Infraestrutura e Manutenção

- **Gestão de patrimônio escolar**:
  - Cadastro e controle de bens patrimoniais.
  - Registro de localização e estado dos bens.

- **Solicitações de manutenção e reparos**:
  - Registro e acompanhamento de pedidos de manutenção.
  - Prioritização e histórico de reparos.

- **Controle de inventário**:
  - Gestão de estoque de materiais e equipamentos.
  - Relatórios de consumo e necessidade de reposição.

## Tecnologias Utilizadas

- **Vue.js**: Framework principal para o desenvolvimento do frontend.
- **Vue Router**: Para gerenciamento de rotas.
- **Vuex**: Para gerenciamento de estado.
- **Axios**: Para requisições HTTP.
- **Vuetify**: Para componentes de interface.

## Pré-requisitos

- **Node.js**: Versão 14 ou superior.
- **npm**: Versão 6 ou superior.

## Configuração e Instalação

### Clone o Repositório

```bash
git clone https://github.com/mmaunze/xicola-frontend.git
cd xicola-frontend
```

### Instalação das Dependências

Instale as dependências do projeto utilizando o npm:

```bash
npm install
```

### Configuração da API

Crie um arquivo `.env` na raiz do projeto com as informações de configuração da API:

```
VITE_APP_API_URL=http://localhost:8080
```

### Executando a Aplicação

Inicie o servidor de desenvolvimento com o seguinte comando:

```bash
npm run dev
```

A aplicação estará disponível em `http://localhost:5173`.

### Build para Produção

Para criar um build otimizado para produção, execute:

```bash
npm run build
```

Os arquivos prontos para produção serão gerados na pasta `dist`.

## Estrutura do Projeto

```
src/
├── assets/         # Arquivos estáticos como imagens e fontes
├── components/     # Componentes Vue.js reutilizáveis
├── pages/          # Páginas da aplicação
├── router/         # Configuração das rotas
├── store/          # Gerenciamento de estado com Vuex
├── plugins/        # Plugins Vue.js
└── App.vue         # Componente raiz
```


