import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'package:todo_manager/ui/pages/home_page.dart';

import 'ui/styles/app_theme.dart';

void main() async {
  await Hive.initFlutter();
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: AppTheme.themeData,
      home: const HomePage(),
    );
  }
}
