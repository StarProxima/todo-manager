import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'logger.dart';

class ErrorHandler {
  static void init() {
    FlutterError.onError = _recordFlutterError;
    logger.i('ErrorHandler init');
  }

  static void recordError(Object error, StackTrace stackTrace) {
    logger.e(
      error,
      error,
      stackTrace,
    );
  }

  static void _recordFlutterError(FlutterErrorDetails error) {
    logger.e(error, error.exception, error.stack);
  }

  const ErrorHandler._();
}
