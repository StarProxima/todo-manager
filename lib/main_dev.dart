import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_flavor/flutter_flavor.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'support/provider_logger.dart';

import 'ui/my_app.dart';
import 'support/hive.dart';
import 'support/settings.dart';
import 'support/error_handler.dart';
import 'support/firebase.dart';

//4294916912
//4286135512
void main() {
  FlavorConfig(
    name: 'DEV',
    color: Colors.red,
    location: BannerLocation.topStart,
    variables: {
      'showDefaultDebugBanner': true,
    },
  );

  runZonedGuarded(
    () async {
      WidgetsFlutterBinding.ensureInitialized();
      await initHive();
      await initFirebase();
      initErrorHandler();

      applySupportSettings();

      runApp(
        ProviderScope(
          observers: [
            ProviderLogger(
              AppLogger(
                reportAppMetrica: false,
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
