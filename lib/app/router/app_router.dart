import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:portifolio/app/providers/user_provider.dart';
import 'package:portifolio/core/utils/app_colors.dart';
import 'package:portifolio/features/1_home/presentation/screens/home_screen.dart';

final GlobalKey<NavigatorState> rootNavigatorKey = GlobalKey<NavigatorState>();
final routerProvider = Provider<GoRouter>((ref) {
  final router = GoRouter(
    navigatorKey: rootNavigatorKey,
    initialLocation: '/',
    routes: [
      GoRoute(
        path: '/',
        builder: (context, state) => const _TitleWrapper(
          child: HomeScreen(), // troque por sua Home real
        ),
      ),
      GoRoute(
        path: '/sobre',
        builder: (context, state) => const _TitleWrapper(
          child: HomeScreen(), // troque por sua Home real
        ),
      ),
    ],
    // redirect: (context, state) {
    //   final isLoggedIn = ref.read(userProfileProvider) != null;
    //   final loggingIn = state.subloc == '/login';

    //   if (!isLoggedIn && !loggingIn) return '/login';
    //   if (isLoggedIn && loggingIn) return '/home';
    //   return null;
    // },
  );

  // Faz o router "reavaliar" redirects quando o usuário muda.
  ref.listen(userProfileProvider, (_, __) {
    router.refresh();
  });

  ref.onDispose(router.dispose);
  return router;
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
