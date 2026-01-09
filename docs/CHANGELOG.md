# Changelog

Todas as mudanças notáveis neste projeto serão documentadas neste arquivo.

O formato é baseado em [Keep a Changelog](https://keepachangelog.com/pt-BR/1.0.0/),
e este projeto adere ao [Semantic Versioning](https://semver.org/lang/pt-BR/).

## [Unreleased]

### Added
- Documentação completa do projeto (README, CONTRIBUTING, ARCHITECTURE)
- Arquivo `.env.example` com documentação de variáveis de ambiente
- Lints adicionais no `analysis_options.yaml` para melhor qualidade de código
- Estrutura básica de testes (aguardando implementação completa)

### Changed
- README.md completamente reescrito com documentação profissional
- RUNBOOK.md atualizado com histórico de correções (2025-10-21)
- `.gitignore` expandido com mais padrões

### Fixed
- Corrigido encoding UTF-8 no título do app (`main.dart`)
- Corrigido bug no `firestoreContentRepositoryProvider` (flag incorreta)
- Adicionado provider separado `useFunctionsProvider` para controle de Cloud Functions

## [1.0.0] - Data do primeiro release

### Added
- Interface responsiva para web e mobile
- Sistema de navegação com GoRouter
- Gerenciamento de estado com Riverpod
- Tema claro/escuro dinâmico
- Seções: Hero, Sobre, Habilidades, Projetos, Contato
- Formulário de contato funcional
- Integração com Firebase (Auth, Firestore, Functions)
- Painel administrativo com autenticação
- Sistema de custom claims para controle de acesso
- Edição de conteúdo em tempo real
- Import/Export de conteúdo em JSON
- Atualização realtime via Firestore Streams
- Persistência de sessão Firebase
- Proteção de rotas baseada em autenticação
- Splash screen durante carregamento
- Suporte a múltiplas estratégias de fonte de dados:
  - Local (assets)
  - Firestore direto
  - Cloud Functions (quando disponível)
- CI/CD com GitHub Actions
- Deploy automático no GitHub Pages

### Technical
- Flutter 3.8.1+
- Dart 3.8.1+
- Riverpod 2.5.1
- GoRouter 16.1.0
- Firebase Core 3.6.0
- Firebase Auth 5.3.1
- Cloud Firestore 5.4.4
- Cloud Functions 5.1.3
- Arquitetura Feature-First com Clean Architecture
- Repository Pattern para abstração de dados
- Provider Pattern para gerenciamento de estado
- Strategy Pattern para alternância de fontes de dados

### Security
- Regras de segurança Firestore implementadas
- Autenticação Firebase com email/senha
- Custom claims para controle de permissões
- Proteção de rotas administrativas
- Validação server-side via Cloud Functions (opcional)

---

## Tipos de Mudanças

- `Added` - para novas funcionalidades
- `Changed` - para mudanças em funcionalidades existentes
- `Deprecated` - para funcionalidades que serão removidas
- `Removed` - para funcionalidades removidas
- `Fixed` - para correções de bugs
- `Security` - para correções de segurança

## Links

- [Keep a Changelog](https://keepachangelog.com/pt-BR/1.0.0/)
- [Semantic Versioning](https://semver.org/lang/pt-BR/)
