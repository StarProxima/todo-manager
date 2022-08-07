import 'dart:async';

import 'package:flutter/material.dart';

import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:todo_manager/support/hive.dart';
import 'package:todo_manager/support/settings.dart';
import 'generated/l10n.dart';
import 'styles/app_theme.dart';
import 'support/error_handler.dart';
import 'support/firebase.dart';
import 'ui/home_page/home_page.dart';

//4294916912
//4286135512
void main() async {
  runZonedGuarded(
    () async {
      await initHive();
      await initFirebase();
      initErrorHandler();

      applySupportSettings();

      runApp(const MyApp());
    },
    ErrorHandler.recordError,
  );
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      localizationsDelegates: const [
        S.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: S.delegate.supportedLocales,
      theme: AppTheme.themeData,
      home: const HomePage(),
    );
  }
}
