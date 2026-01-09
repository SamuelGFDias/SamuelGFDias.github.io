# Arquitetura do Projeto

Este documento descreve a arquitetura e as decisões técnicas do projeto.

## 🏗️ Visão Geral

O projeto segue uma arquitetura **Feature-First** com elementos de **Clean Architecture**, utilizando **Riverpod** para gerenciamento de estado e **Firebase** como backend.

## 📊 Diagrama de Arquitetura

```
┌─────────────────────────────────────────────────┐
│                   Presentation                   │
│  (Screens, Widgets, Controllers via Riverpod)   │
└─────────────┬───────────────────────────────────┘
              │
              ▼
┌─────────────────────────────────────────────────┐
│                  Domain/Logic                    │
│      (Providers, Use Cases, Business Logic)      │
└─────────────┬───────────────────────────────────┘
              │
              ▼
┌─────────────────────────────────────────────────┐
│                     Data                         │
│       (Repositories, Data Sources, Models)       │
└─────────────┬───────────────────────────────────┘
              │
              ▼
┌─────────────────────────────────────────────────┐
│              External Services                   │
│    (Firebase, APIs, Local Storage, Assets)       │
└─────────────────────────────────────────────────┘
```

## 📁 Estrutura de Pastas

### `/lib/app`
Configurações globais da aplicação.

```
app/
├── providers/        # Providers compartilhados (auth, theme, user)
├── router/           # Configuração do GoRouter
└── theme/            # Definições de tema (cores, tipografia)
```

**Responsabilidades:**
- Inicialização da aplicação
- Roteamento global
- Providers de estado global (autenticação, tema)

### `/lib/core`
Código compartilhado entre features.

```
core/
├── constants/        # Constantes da aplicação
├── errors/           # Classes de erro customizadas
├── presentation/     # Telas globais (splash, erro)
├── providers/        # Providers utilitários
├── repositories/     # Repositórios abstratos e implementações core
├── services/         # Serviços auxiliares (validators, formatters)
└── utils/            # Helpers, extensions, utilitários
```

**Responsabilidades:**
- Código reutilizável
- Abstrações e interfaces
- Utilitários gerais

### `/lib/features`
Features organizadas por domínio.

```
features/
├── 1_home/
│   ├── data/
│   │   └── repositories/      # Implementações específicas
│   └── presentation/
│       ├── providers/          # Providers da feature
│       ├── screens/            # Telas principais
│       └── widgets/            # Widgets específicos
└── admin/
    └── presentation/
        └── screens/
```

**Responsabilidades:**
- Cada feature é autônoma
- Comunicação entre features via providers
- Pode ter suas próprias camadas (data, domain, presentation)

### `/lib/shared`
Componentes UI reutilizáveis.

```
shared/
├── app_scaffold.dart         # Scaffold customizado
├── fab_action.dart           # FAB personalizado
├── project_card.dart         # Cards de projetos
└── ...
```

**Responsabilidades:**
- Widgets genéricos e reutilizáveis
- Componentes de UI sem lógica de negócio

## 🔄 Fluxo de Dados

### Leitura (Read)

```
UI Widget
  ↓ (ref.watch)
Provider (Riverpod)
  ↓ (via Repository)
Data Source (Firebase/Assets)
  ↓ (retorna dados)
Provider (transforma/valida)
  ↓ (notifica)
UI Widget (rebuild)
```

### Escrita (Write)

```
UI Widget
  ↓ (ação do usuário)
Provider Method
  ↓ (chama Repository)
Repository
  ↓ (valida e envia)
Firebase/API
  ↓ (confirma)
Provider (atualiza estado)
  ↓ (notifica)
UI Widget (feedback visual)
```

## 🎯 Padrões Utilizados

### 1. Repository Pattern

Abstrai a fonte de dados, permitindo trocar entre diferentes implementações.

```dart
// Abstração
abstract class ContentRepository {
  Future<Map<String, dynamic>?> getHome();
  Future<void> setHome(Map<String, dynamic> data);
}

// Implementação Local
class AssetsContentRepository implements ContentRepository {
  @override
  Future<Map<String, dynamic>?> getHome() async {
    return await loadFromAssets();
  }
}

// Implementação Remota
class FirestoreContentRepository implements ContentRepository {
  @override
  Future<Map<String, dynamic>?> getHome() async {
    return await firestore.doc('cms/home').get();
  }
}
```

### 2. Provider Pattern (Riverpod)

Gerenciamento de estado reativo e injeção de dependências.

```dart
// Provider de dados
final contentProvider = FutureProvider<HomeContent>((ref) async {
  final repo = ref.watch(contentRepositoryProvider);
  return await repo.getHome();
});

// Provider de estado
final themeProvider = StateProvider<ThemeMode>((ref) {
  return ThemeMode.light;
});

// Provider com lógica
final authProvider = Provider<AuthService>((ref) {
  return AuthService(FirebaseAuth.instance);
});
```

### 3. Strategy Pattern

Usado para alternar entre diferentes fontes de dados.

```dart
final contentRepositoryProvider = Provider<ContentRepository>((ref) {
  final useFirestore = ref.watch(useFirestoreProvider);
  
  if (useFirestore) {
    return ref.watch(firestoreContentRepositoryProvider);
  }
  
  return AssetsContentRepository();
});
```

## 🔐 Segurança

### Firebase Security Rules

```javascript
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    match /cms/home {
      allow read: if true;  // Público
      allow write: if request.auth != null 
                   && request.auth.token.admin == true;  // Apenas admins
    }
  }
}
```

### Custom Claims

Usuários admin possuem claim `admin: true` no token JWT.

```dart
final isAdminProvider = StreamProvider<bool>((ref) async* {
  await for (final user in FirebaseAuth.instance.idTokenChanges()) {
    if (user == null) {
      yield false;
    } else {
      final token = await user.getIdTokenResult();
      yield token.claims?['admin'] == true;
    }
  }
});
```

## 🚦 Roteamento

### Proteção de Rotas

```dart
redirect: (context, state) {
  final isLoading = authState.isLoading || isAdmin.isLoading;
  if (isLoading) return '/splash';
  
  final location = state.matchedLocation;
  final loggedIn = auth.currentUser != null;
  final admin = isAdmin.value ?? false;
  
  if (location == '/admin' && !admin) return '/';
  if (location == '/login' && loggedIn) return '/';
  
  return null;
}
```

## 📡 Integração Firebase

### Estratégias de Acesso

#### 1. Local (Assets)
```dart
USE_FIRESTORE=false
```
- Usa `assets/contents/home.json`
- Ideal para desenvolvimento offline
- Sem custos Firebase

#### 2. Firestore Direto
```dart
USE_FIRESTORE=true
USE_FUNCTIONS=false
```
- Acessa Firestore do cliente
- Regras de segurança aplicam
- Requer autenticação para escrita

#### 3. Cloud Functions
```dart
USE_FIRESTORE=true
USE_FUNCTIONS=true
```
- Validação server-side
- Lógica de negócio protegida
- Requer plano Firebase Blaze

### Realtime Updates

```dart
final homeContentStreamProvider = StreamProvider<HomeContent>((ref) {
  final useFirestore = ref.watch(useFirestoreProvider);
  
  if (!useFirestore) {
    return Stream.value(loadFromAssets());
  }
  
  return FirebaseFirestore.instance
    .doc('cms/home')
    .snapshots()
    .map((snap) => HomeContent.fromMap(snap.data()));
});
```

## 🎨 Tema e Estilo

### Tema Dinâmico

```dart
final themeColorProvider = StateProvider<Color>((ref) {
  return AppColors.primaryBlue;
});

final themeProvider = Provider<ThemeData>((ref) {
  final color = ref.watch(themeColorProvider);
  return AppTheme.theme(context, color);
});
```

### Responsive Design

```dart
class Responsive {
  static bool isMobile(BuildContext context) {
    return MediaQuery.of(context).size.width < 768;
  }
  
  static bool isTablet(BuildContext context) {
    return MediaQuery.of(context).size.width >= 768 
        && MediaQuery.of(context).size.width < 1024;
  }
  
  static bool isDesktop(BuildContext context) {
    return MediaQuery.of(context).size.width >= 1024;
  }
}
```

## 🧪 Testabilidade

### Providers Testáveis

```dart
// Em testes, podemos sobrescrever providers
final container = ProviderContainer(
  overrides: [
    contentRepositoryProvider.overrideWithValue(
      MockContentRepository(),
    ),
  ],
);

final repo = container.read(contentRepositoryProvider);
expect(repo, isA<MockContentRepository>());
```

### Testes de Widget

```dart
testWidgets('HomeScreen deve exibir conteúdo', (tester) async {
  await tester.pumpWidget(
    ProviderScope(
      overrides: [
        homeContentProvider.overrideWith((ref) => mockContent),
      ],
      child: MyApp(),
    ),
  );
  
  expect(find.text('Título'), findsOneWidget);
});
```

## 📊 Performance

### Otimizações Implementadas

1. **Const Constructors**: Widgets imutáveis
2. **Provider Caching**: Estados mantidos em cache
3. **Lazy Loading**: Providers carregados sob demanda
4. **Firestore Cache**: Persistência local habilitada
5. **StreamProvider**: Updates eficientes com streams

### Métricas Recomendadas

- **First Paint**: < 1s
- **Time to Interactive**: < 3s
- **Bundle Size**: < 2MB (após gzip)

## 🔄 CI/CD

### GitHub Actions

```yaml
on:
  push:
    branches: [main]

jobs:
  build:
    - flutter pub get
    - flutter analyze
    - flutter test
    - flutter build web
    - deploy to GitHub Pages
```

## 📈 Escalabilidade

### Adicionar Nova Feature

1. Criar pasta em `lib/features/nome_feature/`
2. Estruturar: `data/`, `domain/`, `presentation/`
3. Criar providers específicos
4. Adicionar rota no `app_router.dart`
5. Documentar no README

### Adicionar Novo Provider

```dart
// 1. Definir no arquivo apropriado
final myProvider = Provider<MyService>((ref) {
  return MyService();
});

// 2. Usar em widgets
class MyWidget extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final service = ref.watch(myProvider);
    return Container();
  }
}
```

## 🔍 Debugging

### Riverpod DevTools

```dart
void main() {
  runApp(
    ProviderScope(
      observers: [MyProviderObserver()],
      child: MyApp(),
    ),
  );
}

class MyProviderObserver extends ProviderObserver {
  @override
  void didUpdateProvider(
    ProviderBase provider,
    Object? previousValue,
    Object? newValue,
    ProviderContainer container,
  ) {
    print('Provider: ${provider.name}, New Value: $newValue');
  }
}
```

## 📚 Referências

- [Flutter Clean Architecture](https://resocoder.com/flutter-clean-architecture-tdd/)
- [Riverpod Documentation](https://riverpod.dev/)
- [GoRouter Guide](https://gorouter.dev/)
- [Firebase Flutter](https://firebase.flutter.dev/)

---

**Última atualização:** 2025-10-21
