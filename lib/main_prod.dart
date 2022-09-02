import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'support/provider_logger.dart';

import 'ui/my_app.dart';
import 'support/app_metrica.dart';
import 'support/hive.dart';
import 'support/settings.dart';
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
            ProviderLogger(
              AppLogger(
                reportAppMetrica: true,
              ),
            ),
          ],
          child: MyApp(),
        ),
      );
    },
    ErrorHandler.recordError,
  );
}
