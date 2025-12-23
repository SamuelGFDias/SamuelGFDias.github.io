import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:portifolio/app/providers/user_provider.dart';
import 'package:portifolio/app/providers/auth_provider.dart';
import 'package:portifolio/core/utils/app_colors.dart';
import 'package:portifolio/features/1_home/presentation/screens/home_screen.dart';
import 'package:portifolio/features/admin/presentation/screens/login_screen.dart';
import 'package:portifolio/features/admin/presentation/screens/admin_screen.dart';

final GlobalKey<NavigatorState> rootNavigatorKey = GlobalKey<NavigatorState>();

class GoRouterRefreshStream extends ChangeNotifier {
  GoRouterRefreshStream(Stream<dynamic> stream) {
    notifyListeners();
    stream.asBroadcastStream().listen((_) => notifyListeners());
  }
}

final routerProvider = Provider<GoRouter>((ref) {
  final auth = ref.watch(firebaseAuthProvider);
  final _ = ref.watch(authStateProvider);
  final isAdminState = ref.watch(isAdminProvider);

  return GoRouter(
    navigatorKey: rootNavigatorKey,
    initialLocation: '/',
    refreshListenable: GoRouterRefreshStream(auth.idTokenChanges()),
    routes: [
      GoRoute(
        path: '/',
        builder: (context, state) => const _TitleWrapper(child: HomeScreen()),
      ),
      GoRoute(
        path: '/sobre',
        builder: (context, state) => const _TitleWrapper(child: HomeScreen()),
      ),
      GoRoute(
        path: '/login',
        builder: (context, state) => const _TitleWrapper(child: LoginScreen()),
      ),
      GoRoute(
        path: '/admin',
        builder: (context, state) => const _TitleWrapper(child: AdminScreen()),
      ),
    ],
    redirect: (context, state) {
      final location = state.matchedLocation;
      final loggedIn = auth.currentUser != null;
      
      // Rota /admin: verificação rigorosa
      if (location == '/admin') {
        // Não está logado: redirecionar para login
        if (!loggedIn) {
          return '/login';
        }
        
        // Está logado: verificar se é admin (aguardar se estiver carregando)
        if (isAdminState.isLoading) {
          // Durante loading, permitir continuar (verificação será feita na tela)
          return null;
        }
        
        final isAdmin = isAdminState.valueOrNull ?? false;
        if (!isAdmin) {
          // Usuário autenticado mas SEM permissão de admin
          return '/';
        }
        
        // Tudo OK: é admin
        return null;
      }

      // Rota /login: redirecionar se já estiver logado E for admin
      if (location == '/login') {
        if (loggedIn && !isAdminState.isLoading) {
          final isAdmin = isAdminState.valueOrNull ?? false;
          if (isAdmin) {
            return '/admin';
          }
        }
        return null;
      }

      // Rotas públicas (/, /sobre) não bloqueiam
      return null;
    },
  );
});

class _TitleWrapper extends ConsumerWidget {
  final Widget child;
  const _TitleWrapper({required this.child});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userName = ref.watch(userProfileProvider.select((u) => u?.name));
    return Title(
      title: 'Portifólio${userName != null ? ' - $userName' : ''}',
      color: AppColors.textLight,
      child: child,
    );
  }
}
