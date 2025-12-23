import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_ui_localizations/firebase_ui_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/foundation.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:portifolio/core/utils/pt_br_firebase_ui_labels.dart';
import 'firebase_options.dart';
import 'package:portifolio/app/providers/theme_provider.dart';
import 'package:portifolio/core/utils/ui_helpers.dart';
import 'package:url_strategy/url_strategy.dart';

import 'app/router/app_router.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'app/theme/app_theme.dart';

void main() async {
  // Garante que os bindings do Flutter sejam inicializados
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  if (kIsWeb) {
    await FirebaseAuth.instance.setPersistence(Persistence.LOCAL);
  }

  FirebaseFirestore.instance.settings = const Settings(
    persistenceEnabled: true,
    cacheSizeBytes: Settings.CACHE_SIZE_UNLIMITED,
  );

  setPathUrlStrategy();

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
      title: 'Portfólio',
      debugShowCheckedModeBanner: false,
      scaffoldMessengerKey: UiHelpers.messageGlobalKey,
      localizationsDelegates: [
        FirebaseUILocalizations.withDefaultOverrides(
          const PtBrFirebaseUILocalizations(),
        ),
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('pt', 'BR'), // Português do Brasil
        Locale('en', 'US'), // Inglês (opcional, como fallback)
      ],
      theme: AppTheme.theme(context, themeColor),
      routerConfig: router,
    );
  }
}
