# Segurança do Portfólio

## Sobre as Chaves Firebase no Código

### ⚠️ Informação Importante

As chaves de API do Firebase para Web (encontradas em `lib/firebase_options.dart`) **NÃO são secretas** por design do Firebase. Elas são intencionalmente públicas e expostas no código do cliente.

### Por que as chaves Firebase Web são públicas?

1. **Arquitetura Client-Side**: Aplicações web Firebase rodam inteiramente no navegador do usuário
2. **Visíveis no DevTools**: Qualquer pessoa pode ver essas chaves abrindo as ferramentas de desenvolvedor do navegador
3. **Segurança por Design**: O Firebase não depende da ocultação dessas chaves para segurança

### Como o Firebase Protege Seus Dados?

A segurança no Firebase é garantida através de:

1. **Firebase Security Rules** (`firestore.rules`)
   - Controlam quem pode ler/escrever no Firestore
   - São aplicadas no servidor, não no cliente
   - Exemplo do projeto:
   ```
   allow read: if true;  // Qualquer um pode ler
   allow write: if request.auth != null && request.auth.token.admin == true;  // Só admins podem escrever
   ```

2. **Firebase Authentication**
   - Controle de acesso baseado em usuários autenticados
   - Claims personalizadas (como `admin: true`)

3. **Firebase App Check** (Recomendado para produção)
   - Protege contra acesso não autorizado de bots e scripts
   - Valida que as requisições vêm de uma app legítima

### Rotação das Chaves Firebase (Opcional)

Se mesmo assim você deseja trocar as chaves por razões organizacionais:

#### Passos para Rotar as Chaves:

1. **Criar Novo Projeto Firebase** (Recomendado)
   ```bash
   # No Firebase Console (https://console.firebase.google.com)
   # 1. Criar novo projeto
   # 2. Configurar Firestore
   # 3. Configurar Authentication
   # 4. Adicionar aplicação Web
   ```

2. **Atualizar Configuração Local**
   ```bash
   # Instalar flutterfire CLI se ainda não tiver
   dart pub global activate flutterfire_cli
   
   # Configurar novo projeto
   flutterfire configure --project=<NOVO_PROJECT_ID> --platforms=web
   ```

3. **Migrar Dados** (se necessário)
   - Exportar dados do Firestore antigo
   - Importar para o novo projeto
   - Recriar usuários no Authentication

4. **Atualizar Regras de Segurança**
   ```bash
   firebase deploy --only firestore:rules
   ```

5. **Atualizar Functions** (se aplicável)
   ```bash
   cd functions
   npm install
   cd ..
   firebase deploy --only functions
   ```

6. **Testar Completamente**
   - Verificar login
   - Verificar leitura/escrita de dados
   - Testar painel admin

#### Após Rotação:

- O projeto antigo pode ser desativado/deletado no Firebase Console
- As chaves antigas no histórico do git ficam inválidas automaticamente
- Sem necessidade de reescrever histórico git (que causaria problemas)

### Recomendações de Segurança

✅ **Faça:**
- Mantenha suas Firebase Security Rules restritivas
- Use Firebase Authentication para funcionalidades sensíveis
- Considere Firebase App Check para produção
- Proteja o `serviceAccount.json` (nunca commite!)
- Use claims personalizadas para controle de acesso (como `admin: true`)

❌ **Não faça:**
- Não commite `serviceAccount.json` ou outras chaves privadas
- Não commite arquivos `.env` com secrets reais
- Não tente "esconder" as chaves Firebase Web do código (é inútil)
- Não dependa apenas da API key para segurança

### Arquivos que NUNCA devem ser commitados

Estes já estão no `.gitignore`:

```
.env
.env.local
.env.*.local
scripts/serviceAccount.json
.firebaserc
firebase-debug.log
firestore-debug.log
```

### Verificando Segurança

Execute regularmente:

```bash
# Verificar se não há secrets no código
git grep -i "password\|secret\|private.*key" 

# Verificar .gitignore
git check-ignore -v scripts/serviceAccount.json

# Testar regras do Firestore
# Use o Firebase Console > Firestore > Rules > Playground
```

### Em Caso de Exposição de Secrets REAIS

Se você acidentalmente commitou um **secret real** (como `serviceAccount.json`):

1. **Rotacione imediatamente** as credenciais no Firebase Console
2. **Delete o arquivo** do repositório
3. **Adicione ao .gitignore**
4. **Notifique a equipe**
5. **Considere usar git-filter-repo** para remover do histórico (requer force push)

### Recursos Adicionais

- [Firebase Security Rules Documentation](https://firebase.google.com/docs/rules)
- [Firebase App Check](https://firebase.google.com/docs/app-check)
- [Firebase Authentication](https://firebase.google.com/docs/auth)
- [Restricting API Keys](https://cloud.google.com/docs/authentication/api-keys#api_key_restrictions)

## Conclusão

As chaves Firebase no `firebase_options.dart` são seguras por design. O histórico git contendo essas chaves não representa um risco de segurança real, pois:

1. Elas são públicas por natureza
2. Estão visíveis em qualquer app web Firebase em produção
3. A segurança é garantida pelas Firebase Security Rules

Se ainda desejar rotacionar por razões organizacionais, siga os passos acima.
