# Portfólio Flutter

Portfólio pessoal desenvolvido em Flutter com sistema de gerenciamento de conteúdo (CMS) integrado ao Firebase. Permite edição em tempo real através de um painel administrativo protegido.

**Status:** 🟢 Produção | [Demo ao vivo](https://samuelgfdias.github.io/portifolio)

---

## 📋 Índice

- [Funcionalidades](#-funcionalidades)
- [Início Rápido](#-início-rápido)
- [Modos de Execução](#-modos-de-execução)
- [Configuração Firebase](#-configuração-firebase)
- [Painel Admin](#-painel-admin)
- [Deploy](#-deploy)
- [Problemas Comuns](#-problemas-comuns)
- [Documentação Técnica](#-documentação-técnica)
- [Contribuindo](#-contribuindo)

---

## 🚀 Funcionalidades

### Para Visitantes

- ✅ Interface responsiva (web e mobile)
- ✅ Temas claro/escuro dinâmicos
- ✅ Navegação fluída entre seções
- ✅ Formulário de contato funcional
- ✅ Links para redes sociais

### Para Administradores

- ✅ Painel admin protegido por autenticação
- ✅ Edição de conteúdo em tempo real
- ✅ Importar/Exportar JSON
- ✅ Prévia instantânea das mudanças
- ✅ Verificação de permissões em múltiplas camadas

---

## ⚡ Início Rápido

### 1. Clone o Projeto

```bash
git clone https://github.com/samuelgfdias/portifolio.git
cd portifolio
flutter pub get
```

### 2. Escolha um Modo de Execução

#### 🔹 Modo Local (Offline - Recomendado para desenvolvimento UI)

```bash
flutter run -d chrome
```

**OU** clique duas vezes em: `rodar_local.bat`

**O que faz:**

- Usa dados de `assets/contents/home.json`
- Funciona sem internet
- **NÃO** conecta ao Firebase
- Admin **NÃO** consegue salvar

**Quando usar:** Desenvolvimento de UI, testes offline, demo sem Firebase

---

#### 🔹 Modo Firestore (Online - Recomendado para produção)

```bash
flutter run -d chrome --dart-define=USE_FIRESTORE=true
```

**OU** clique duas vezes em: `rodar_firestore.bat`

**O que faz:**

- ✅ Conecta ao Firestore em tempo real
- ✅ Admin pode salvar dados
- ✅ Home atualiza automaticamente
- ✅ Fallback para assets se Firestore vazio

**Quando usar:** Desenvolvimento completo, produção, testes com Firebase

---

#### 🔹 Modo Firestore + Functions (Avançado)

```bash
flutter run -d chrome --dart-define=USE_FIRESTORE=true --dart-define=USE_FUNCTIONS=true
```

**OU** clique duas vezes em: `rodar_funcoes.bat`

**O que faz:**

- ✅ Usa Cloud Functions para validação server-side
- ✅ Camada extra de segurança
- ⚠️ Requer plano Blaze (pago) e Functions deployadas

**Quando usar:** Produção com máxima segurança

---

## 🔐 Configuração Firebase

### Passo 1: Criar Projeto Firebase

1. Acesse [Firebase Console](https://console.firebase.google.com)
2. Crie um novo projeto
3. Ative **Authentication** (Email/Password)
4. Ative **Firestore Database**

### Passo 2: Configurar no Projeto

```bash
# Instale FlutterFire CLI
dart pub global activate flutterfire_cli

# Configure o projeto
flutterfire configure --project=SEU_PROJETO_ID --platforms=web
```

### Passo 3: Configurar Regras do Firestore

No Firebase Console > Firestore > Regras:

```javascript
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    match /cms/home {
      allow read: if true;
      allow write: if request.auth != null && request.auth.token.admin == true;
    }
  }
}
```

**Publique as regras!**

### Passo 4: Popular Dados Iniciais

1. Firestore > Adicionar coleção: `cms`
2. Adicionar documento ID: `home`
3. Copiar conteúdo de `assets/contents/home.json`
4. Colar como campos do documento

---

## 👨‍💼 Painel Admin

### Criar Usuário Administrador

#### Opção 1: Via Script (Recomendado)

```bash
# 1. Crie um usuário no Firebase Console
# 2. Copie o UID
# 3. Execute:
node scripts/grantAdmin.js SEU_USER_UID
```

#### Opção 2: Via Firebase Console

1. Authentication > Crie usuário
2. Copie o UID
3. Firestore > Crie documento em `users/{UID}`
4. Adicione campo: `admin: true`

### Acessar Painel

1. Rode o app: `flutter run -d chrome --dart-define=USE_FIRESTORE=true`
2. Acesse: `http://localhost:PORT/admin`
3. Faça login com as credenciais admin
4. Edite o conteúdo e clique em **Publicar**
5. A home atualiza automaticamente! 🎉

### ⚠️ Problema: "Home não atualiza após publicar"

**Causa:** Você está rodando em **Modo Local** (sem flag)

**Solução:** Rode com a flag `--dart-define=USE_FIRESTORE=true`

```bash
# ❌ Errado (usa assets)
flutter run -d chrome

# ✅ Correto (usa Firestore)
flutter run -d chrome --dart-define=USE_FIRESTORE=true
```

---

## 🚀 Deploy

### Build para Produção

```bash
flutter build web --dart-define=USE_FIRESTORE=true
```

### Deploy no Firebase Hosting

```bash
firebase deploy --only hosting
```

### Deploy no GitHub Pages (Automático)

O projeto tem CI/CD configurado. A cada push na `main`:

1. GitHub Actions faz build automático
2. Deploy no GitHub Pages
3. Site atualizado em ~2 minutos

---

## ❗ Problemas Comuns

### 1. "Home não atualiza após publicar no admin"

**Causa:** Rodando em Modo Local

**Solução:**

```bash
flutter run -d chrome --dart-define=USE_FIRESTORE=true
```

### 2. "Permission denied ao salvar"

**Causa:** Usuário não tem claim `admin: true`

**Solução:** Execute o script de grant admin:

```bash
node scripts/grantAdmin.js SEU_USER_UID
```

### 3. "Failed to load asset: home.json"

**Causa:** Arquivo assets não configurado

**Solução:** Verifique `pubspec.yaml`:

```yaml
flutter:
  assets:
    - assets/contents/
```

### 4. "Multiple widgets used the same GlobalKey"

**Causa:** Bug já corrigido

**Solução:** Faça hot restart (R) ou reinicie o app

### 5. "TypeError: null is not a subtype of Map"

**Causa:** Bug já corrigido

**Solução:** Atualize para última versão do código

---

## 📚 Documentação Técnica

Para desenvolvedores que desejam entender a arquitetura e decisões técnicas:

- [Arquitetura do Projeto](docs/ARCHITECTURE.md)
- [Changelog Completo](docs/CHANGELOG.md)
- [Bugs Corrigidos](docs/BUGS_CORRIGIDOS.md)
- [Guia de Contribuição](docs/CONTRIBUTING.md)
- [Runbook Técnico](docs/RUNBOOK.md)

---

## 🛠️ Stack Tecnológico

| Categoria | Tecnologia |
|-----------|-----------|
| Framework | Flutter 3.8.1+ |
| Linguagem | Dart 3.8.1+ |
| State Management | Riverpod 2.5.1 |
| Roteamento | GoRouter 16.1.0 |
| Backend | Firebase (Auth, Firestore, Functions) |
| UI | Lucide Icons, Material Design 3 |
| Deploy | GitHub Actions, Firebase Hosting |

---

## 🤝 Contribuindo

Contribuições são bem-vindas! Por favor:

1. Fork o projeto
2. Crie uma branch: `git checkout -b feature/NovaFeature`
3. Commit: `git commit -m 'Add: Nova feature incrível'`
4. Push: `git push origin feature/NovaFeature`
5. Abra um Pull Request

Veja [CONTRIBUTING.md](docs/CONTRIBUTING.md) para guidelines detalhados.

---

## 📄 Licença

Este projeto está sob a licença MIT. Veja [LICENSE](LICENSE) para mais detalhes.

---

## 👤 Autor

**Samuel Dias**

- 💼 LinkedIn: [@SamuelGFDias](https://www.linkedin.com/in/SamuelGFDias)
- 💻 GitHub: [@samuelgfdias](https://github.com/samuelgfdias)
- 📧 Email: <samudias48@gmail.com>

---

## ⭐ Apoie o Projeto

Se este projeto foi útil para você, considere dar uma estrela! ⭐

Para dúvidas ou sugestões, abra uma [issue](https://github.com/samuelgfdias/portifolio/issues) ou entre em contato.

---

**Última atualização:** 2025-10-21
