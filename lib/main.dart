import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:portifolio/app/providers/theme_provider.dart';
import 'package:portifolio/core/utils/ui_helpers.dart';
import 'package:url_strategy/url_strategy.dart';

import 'app/router/app_router.dart';
import 'app/theme/app_theme.dart';

void main() async {
  // Garante que os bindings do Flutter sejam inicializados
  WidgetsFlutterBinding.ensureInitialized();

  setPathUrlStrategy();

  // Inicializa o suporte a formatação de data para o locale 'pt_BR'
  await initializeDateFormatting('pt_BR', null);

  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(routerProvider);
    final themeColor = ref.watch(themeColorProvider);

    return MaterialApp.router(
      title: 'Portifólio',
      debugShowCheckedModeBanner: false,
      scaffoldMessengerKey: UiHelpers.messageGlobalKey,
      theme: AppTheme.theme(context, themeColor),
      routerConfig: router,
    );
  }
}
