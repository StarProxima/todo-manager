import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import '../styles/app_theme.dart';
import 'logger.dart';

void applySupportSettings() {
  int? importanceColor = Hive.box<int>('support').get('importanceColor');
  AppColors.red = Color(importanceColor ?? AppColors.red.value);
  logger.i('applySupportSettings');
}
