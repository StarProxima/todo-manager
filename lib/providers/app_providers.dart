// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final appThemeMode = StateNotifierProvider<AppThemeMode, ThemeMode>(
  (ref) {
    return AppThemeMode(ThemeMode.system);
  },
  name: 'appThemeMode',
);

class AppThemeMode extends StateNotifier<ThemeMode> {
  AppThemeMode(super.state);

  void switchTheme() {
    state = state == ThemeMode.light ? ThemeMode.dark : ThemeMode.light;
  }
}
