# Guia: Remover Informações Sensíveis do Histórico Git

## 📋 Sumário Executivo

Este guia explica como lidar com informações sensíveis que foram commitadas no histórico do repositório.

**Status Atual:**
- ✅ Nenhuma chave privada (serviceAccount.json) foi commitada
- ✅ Nenhum arquivo .env com secrets foi commitado
- ⚠️ Chaves Firebase Web API estão no código (mas são públicas por design)

## 🔍 O Que Foi Encontrado

Após análise completa do histórico (23 commits), foi identificado:

### Informações no Código

**Arquivo: `lib/firebase_options.dart`**
```dart
apiKey: 'AIzaSyDIfAfBkktoisvdLb1pwWUfaiHlT9orTQk'
projectId: 'portifolio-f7554'
appId: '1:719357865435:web:a31b1f466cad012a654bfe'
```

**Contexto Importante:** Estas são chaves Firebase para Web, que são **intencionalmente públicas**. Veja `SECURITY.md` para detalhes.

## 🎯 Opções Disponíveis

### Opção 1: Rotação de Chaves (Recomendado)

**Vantagens:**
- ✅ Invalida as chaves antigas automaticamente
- ✅ Não requer reescrever histórico git
- ✅ Sem problemas de sincronização com equipe
- ✅ Menos risco de perder código

**Como fazer:**

1. **Criar novo projeto Firebase** ou **gerar novas chaves**

2. **Atualizar o código:**
   ```bash
   # Instalar flutterfire CLI
   dart pub global activate flutterfire_cli
   
   # Reconfigurar com novo projeto
   flutterfire configure --project=<NOVO_PROJECT_ID>
   ```

3. **Commitar as mudanças:**
   ```bash
   git add lib/firebase_options.dart
   git commit -m "chore: update Firebase configuration with new keys"
   git push
   ```

4. **Migrar dados** (se necessário)
   - Exportar do Firestore antigo
   - Importar para o novo
   - Recriar usuários admin

5. **Desativar projeto antigo** no Firebase Console

### Opção 2: Reescrever Histórico (Avançado - NÃO Recomendado)

⚠️ **ATENÇÃO:** Reescrever histórico é **destrutivo** e **complexo**. Só faça se:
- Você expôs um secret REAL (não é o caso aqui)
- Você entende completamente as implicações
- Você tem backup do repositório
- Você coordenou com toda a equipe

**Ferramentas disponíveis:**
- `git-filter-repo` (recomendado sobre filter-branch)
- `BFG Repo-Cleaner`

**Não recomendado porque:**
- ❌ Requer force push (reescreve histórico público)
- ❌ Quebra git history para todos os colaboradores
- ❌ Pode causar perda de dados se feito incorretamente
- ❌ Não resolve o problema (as chaves Firebase Web são públicas anyway)

#### Se REALMENTE precisar reescrever histórico:

```bash
# 1. Fazer backup completo
cp -r .git .git.backup
git clone --mirror <URL> backup-repo

# 2. Instalar git-filter-repo
pip install git-filter-repo

# 3. Remover arquivo do histórico (EXEMPLO - ajuste conforme necessário)
git filter-repo --path lib/firebase_options.dart --invert-paths

# 4. Force push (DESTRUTIVO!)
git push --force --all
git push --force --tags

# 5. Avisar TODA A EQUIPE para re-clonar:
git clone <URL>
```

### Opção 3: Aceitar a Situação (Válido neste caso)

**Por que esta é uma opção válida:**

1. **Firebase Web API keys são públicas** - Não são secrets
2. **Segurança é garantida por Firebase Rules** - Não pela ocultação
3. **Reescrever histórico traz mais riscos** - Do que benefícios neste caso
4. **Nenhum secret real foi exposto** - serviceAccount.json nunca foi commitado

**O que fazer:**
- ✅ Documentar que as chaves são públicas (já feito em SECURITY.md)
- ✅ Garantir que Firebase Security Rules estão corretas
- ✅ Adicionar Firebase App Check se preocupado com abuse
- ✅ Monitorar uso do Firebase no console

## 📊 Comparação das Opções

| Critério | Rotação | Reescrever | Aceitar |
|----------|---------|------------|---------|
| Complexidade | Baixa | Alta | Nenhuma |
| Risco | Baixo | Alto | Nenhum |
| Efetividade | Alta | Alta | N/A |
| Tempo | 30min | 2-4h | 0min |
| Colaboração | Fácil | Difícil | Fácil |
| Recomendado | ✅ | ❌ | ✅ |

## 🛠️ Implementação Detalhada - Rotação

### Passo a Passo Completo:

#### 1. Preparação (5 minutos)

```bash
# Garantir que você está na branch correta
git checkout main
git pull

# Criar branch para mudanças
git checkout -b chore/rotate-firebase-keys
```

#### 2. Firebase Console (10 minutos)

1. Acesse https://console.firebase.google.com
2. Opção A: Criar novo projeto
   - Click "Add project"
   - Dê um nome (ex: "portifolio-v2")
   - Configure Firestore e Authentication
   
3. Opção B: Regenerar chaves (mais simples)
   - Vá para Project Settings
   - Na seção "Your apps", delete a app web existente
   - Adicione nova app web
   - Copie as novas configurações

#### 3. Atualizar Código Local (5 minutos)

```bash
# Método automático (recomendado)
flutterfire configure --project=portifolio-f7554 --platforms=web

# Ou método manual: editar lib/firebase_options.dart
# Substitua os valores com as novas chaves
```

#### 4. Testar Localmente (5 minutos)

```bash
# Rodar app localmente
flutter run -d chrome --dart-define=USE_FIRESTORE=true

# Verificar:
# - App carrega corretamente
# - Dados aparecem
# - Login funciona
```

#### 5. Deploy (5 minutos)

```bash
# Commitar mudanças
git add lib/firebase_options.dart
git commit -m "chore: rotate Firebase configuration keys

- Updated Firebase Web API keys
- Previous keys in git history are now invalid
- See docs/SECURITY.md for security model explanation"

# Push e criar PR
git push -u origin chore/rotate-firebase-keys

# Após merge, fazer deploy
flutter build web --dart-define=USE_FIRESTORE=true --dart-define=USE_FUNCTIONS=true
```

#### 6. Verificação Final (5 minutos)

1. Testar site em produção
2. Verificar login admin
3. Verificar edição de conteúdo
4. Desativar projeto antigo (opcional)

## 🔐 Prevenção Futura

Para evitar commitar informações sensíveis:

### 1. Configurar git hooks

Criar `.git/hooks/pre-commit`:

```bash
#!/bin/bash

# Verificar por secrets
if git grep -q "serviceAccount\|PRIVATE.*KEY\|-----BEGIN" HEAD; then
    echo "❌ ERRO: Possível secret detectado!"
    echo "Verifique o que você está commitando."
    exit 1
fi

# Verificar por arquivos sensíveis
if git diff --cached --name-only | grep -qE "\.env$|serviceAccount\.json|\.pem$"; then
    echo "❌ ERRO: Tentando commitar arquivo sensível!"
    echo "Adicione ao .gitignore"
    exit 1
fi

exit 0
```

```bash
chmod +x .git/hooks/pre-commit
```

### 2. Usar git-secrets

```bash
# Instalar
brew install git-secrets  # macOS
# ou
apt-get install git-secrets  # Linux

# Configurar
git secrets --install
git secrets --register-aws
```

### 3. Revisar .gitignore regularmente

Arquivo `.gitignore` atual já protege:
```
.env
.env.local
scripts/serviceAccount.json
.firebaserc
```

### 4. Code Review

Sempre revisar PRs para:
- Chaves de API hardcoded
- Senhas em comentários
- URLs de produção com credenciais
- Tokens de acesso

## 📚 Recursos

- [Documentação Firebase Security](docs/SECURITY.md)
- [Firebase Console](https://console.firebase.google.com)
- [Git Filter Repo](https://github.com/newren/git-filter-repo)
- [BFG Repo Cleaner](https://rtyley.github.io/bfg-repo-cleaner/)

## ❓ FAQ

**P: Preciso remover as chaves Firebase do histórico?**
R: Não necessariamente. Elas são públicas por design. Veja SECURITY.md.

**P: E se eu já fiz force push acidental?**
R: Avise a equipe imediatamente para re-clonar o repositório.

**P: Como sei se um arquivo é sensível?**
R: Se contém: senhas, tokens privados, chaves privadas, serviceAccount.json.

**P: Firebase API keys são sensíveis?**
R: Para web, NÃO. Para mobile/server (serviceAccount), SIM.

**P: Posso usar git revert ao invés de filter?**
R: Não remove do histórico, apenas adiciona commit reverso.

## 📞 Próximos Passos

Escolha uma das opções acima baseado em:

1. **Se não há pressa e quer fazer "certo":** → Opção 1 (Rotação)
2. **Se não há secrets reais expostos:** → Opção 3 (Aceitar)
3. **Se há secret REAL (não é o caso):** → Consultar especialista + Opção 2

## ✅ Checklist de Ação

Depois de ler este documento:

- [ ] Entendi que Firebase Web API keys são públicas
- [ ] Li o documento SECURITY.md
- [ ] Decidi qual opção seguir (Rotação/Aceitar)
- [ ] Se rotar: seguir passos da seção "Implementação Detalhada"
- [ ] Configurar git hooks para prevenir futuros acidentes
- [ ] Verificar que .gitignore está correto
- [ ] Testar completamente após mudanças

---

**Última atualização:** Novembro 2025
**Autor:** GitHub Copilot Workspace Agent
