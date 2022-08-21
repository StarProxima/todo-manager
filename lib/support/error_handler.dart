import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'logger.dart';

void initErrorHandler() {
  FlutterError.onError = ErrorHandler._recordFlutterError;
  logger.i('initErrorHandler');
}

class ErrorHandler {
  static void recordError(Object error, StackTrace stackTrace) {
    //FirebaseCrashlytics.instance.recordError(error, stackTrace);
    //logger.e(error, error, stackTrace);
  }

  static void _recordFlutterError(FlutterErrorDetails error) {
    // FirebaseCrashlytics.instance.recordFlutterFatalError(error);
    //logger.e(error, error.exception, error.stack);
  }

  const ErrorHandler._();
}
