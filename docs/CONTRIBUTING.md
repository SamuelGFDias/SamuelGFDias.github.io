# Guia de Contribuição

Obrigado por considerar contribuir com este projeto! Este documento fornece diretrizes para contribuições.

## 🚀 Como Contribuir

### 1. Fork e Clone

```bash
# Fork o repositório no GitHub
# Clone seu fork
git clone https://github.com/SEU_USUARIO/portifolio.git
cd portifolio

# Adicione o repositório original como upstream
git remote add upstream https://github.com/samuelgfdias/portifolio.git
```

### 2. Configuração do Ambiente

```bash
# Instale as dependências
flutter pub get

# Configure o Firebase (se necessário)
flutterfire configure --project=portifolio-f7554 --platforms=web

# Rode os testes para garantir que tudo está funcionando
flutter test

# Execute o app
flutter run -d chrome
```

### 3. Crie uma Branch

```bash
# Crie uma branch descritiva
git checkout -b feature/minha-nova-feature
# ou
git checkout -b fix/correcao-de-bug
```

### 4. Faça suas Alterações

#### Padrões de Código

- Use **análise estática**: `flutter analyze` deve passar sem erros
- Siga as **regras do linter** definidas em `analysis_options.yaml`
- Mantenha **trailing commas** para melhor formatação
- Use **const constructors** sempre que possível
- Prefira **single quotes** para strings

#### Estrutura de Commits

Use commits semânticos:

```
feat: adiciona nova funcionalidade X
fix: corrige bug na tela Y
docs: atualiza documentação
style: formatação de código
refactor: refatora componente Z
test: adiciona testes para W
chore: atualiza dependências
```

#### Testes

- Adicione testes para novas funcionalidades
- Garanta que todos os testes passem: `flutter test`
- Mantenha coverage acima de 70% (recomendado)

```bash
# Rodar testes com coverage
flutter test --coverage

# Ver relatório (se tiver lcov instalado)
genhtml coverage/lcov.info -o coverage/html
```

### 5. Commit e Push

```bash
# Adicione suas alterações
git add .

# Commit com mensagem descritiva
git commit -m "feat: adiciona funcionalidade X"

# Push para seu fork
git push origin feature/minha-nova-feature
```

### 6. Abra um Pull Request

1. Vá para o repositório original no GitHub
2. Clique em "New Pull Request"
3. Selecione sua branch
4. Preencha o template:
   - **Descrição**: O que foi alterado e por quê
   - **Tipo**: Feature, Bug Fix, Docs, etc.
   - **Testes**: Como testar suas alterações
   - **Screenshots**: Se aplicável

## 📋 Checklist de PR

Antes de abrir um PR, verifique:

- [ ] O código segue os padrões do projeto
- [ ] `flutter analyze` passa sem erros
- [ ] `flutter test` passa com sucesso
- [ ] Documentação foi atualizada (se necessário)
- [ ] Commits seguem o padrão semântico
- [ ] Branch está atualizada com `main`

## 🏗️ Estrutura do Projeto

```
lib/
├── app/              # Configurações globais
├── core/             # Código compartilhado
├── features/         # Features por domínio
└── shared/           # Componentes reutilizáveis
```

### Onde Adicionar Código

- **Nova feature completa**: `lib/features/nome_feature/`
- **Componente reutilizável**: `lib/shared/`
- **Utilitário**: `lib/core/utils/`
- **Provider global**: `lib/app/providers/`
- **Repositório**: `lib/core/repositories/` ou `lib/features/X/data/`

## 🎨 Padrões de Desenvolvimento

### Gerenciamento de Estado

Use **Riverpod**:

```dart
// Provider simples
final counterProvider = StateProvider<int>((ref) => 0);

// Provider com lógica
final userProvider = FutureProvider<User>((ref) async {
  return await fetchUser();
});

// StreamProvider
final messagesProvider = StreamProvider<List<Message>>((ref) {
  return messagesStream();
});
```

### Roteamento

Use **GoRouter**:

```dart
GoRoute(
  path: '/feature',
  builder: (context, state) => const FeatureScreen(),
),
```

### Organização de Widgets

```dart
// Widgets pequenos e focados
class MyWidget extends ConsumerWidget {
  const MyWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container();
  }
}
```

## 🐛 Reportando Bugs

Use as Issues do GitHub com as seguintes informações:

1. **Descrição clara** do problema
2. **Passos para reproduzir**
3. **Comportamento esperado** vs **atual**
4. **Screenshots** (se aplicável)
5. **Ambiente**:
   - Versão do Flutter
   - Sistema operacional
   - Navegador (para web)

## 💡 Sugestões de Features

Abra uma Issue com:

1. **Descrição** da feature
2. **Problema que resolve**
3. **Proposta de solução**
4. **Mockups** ou exemplos (se tiver)

## 📞 Contato

Dúvidas? Entre em contato:

- **Email**: samudias48@gmail.com
- **LinkedIn**: [Samuel Dias](https://www.linkedin.com/in/SamuelGFDias)
- **Issues**: Use as Issues do GitHub

## 📄 Código de Conduta

Seja respeitoso e profissional. Contribuições de todos são bem-vindas!

---

Obrigado por contribuir! 🎉
