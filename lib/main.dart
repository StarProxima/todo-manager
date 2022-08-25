import 'dart:async';

import 'package:flutter/material.dart';

import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'router/app_route_information_parser.dart';
import 'router/app_router_delegate.dart';
import 'core/providers.dart';
import 'support/app_metrica.dart';
import 'support/hive.dart';
import 'support/provider_logger.dart';
import 'support/settings.dart';
import 'generated/l10n.dart';
import 'styles/app_theme.dart';
import 'support/error_handler.dart';
import 'support/firebase.dart';

//4294916912
//4286135512
void main() {
  runZonedGuarded(
    () async {
      WidgetsFlutterBinding.ensureInitialized();
      await initHive();
      await initFirebase();
      initErrorHandler();
      initAppMetrica();

      applySupportSettings();

      runApp(
        ProviderScope(
          observers: [
            ProviderLogger(),
          ],
          child: MyApp(),
        ),
      );
    },
    ErrorHandler.recordError,
  );
}

class MyApp extends ConsumerWidget {
  MyApp({Key? key}) : super(key: key);

  final routerDelegate = AppRouterDelegate();

  final routeInformationParser = AppRouteInformationParser();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MaterialApp.router(
      routerDelegate: routerDelegate,
      routeInformationParser: routeInformationParser,
      localizationsDelegates: const [
        S.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: S.delegate.supportedLocales,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ref.watch(appThemeMode),
    );
  }
}
