import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:todo_manager/styles/app_theme.dart';

void applySupportSettings() {
  AppColors.red = Color(
    Hive.box<int>('support').get('importanceColor') ?? AppColors.red.value,
  );
}
