import 'package:flutter/material.dart';
import 'package:flutter_flavor/flutter_flavor.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../generated/l10n.dart';
import '../providers/app_providers.dart';
import '../router/app_route_information_parser.dart';
import '../router/app_router_delegate.dart';
import '../styles/app_theme.dart';

class MyApp extends ConsumerWidget {
  MyApp({Key? key, this.supportedLocales}) : super(key: key);

  final List<Locale>? supportedLocales;

  final routerDelegate = AppRouterDelegate();

  final routeInformationParser = AppRouteInformationParser();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return FlavorBanner(
      child: MaterialApp.router(
        debugShowCheckedModeBanner:
            FlavorConfig.instance.variables['showDefaultDebugBanner'] ?? true,
        backButtonDispatcher: RootBackButtonDispatcher(),
        routerDelegate: routerDelegate,
        routeInformationParser: routeInformationParser,
        localizationsDelegates: const [
          S.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: supportedLocales?.where(
              (element) => S.delegate.supportedLocales.contains(element),
            ) ??
            S.delegate.supportedLocales,
        theme: AppTheme.lightTheme,
        darkTheme: AppTheme.darkTheme,
        themeMode: ref.watch(appThemeMode),
      ),
    );
  }
}
