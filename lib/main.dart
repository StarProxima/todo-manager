import 'package:flutter/material.dart';

import 'package:hive_flutter/hive_flutter.dart';
import 'package:todo_manager/data/models/importance.dart';
import 'package:todo_manager/data/models/task_model.dart';
import 'package:todo_manager/ui/pages/home_page.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
// ignore: unused_import
import 'ui/styles/app_theme.dart';

void main() async {
  await Hive.initFlutter();
  Hive.registerAdapter(TaskAdapter());
  Hive.registerAdapter(ImportanceAdapter());
  // await (await Hive.openBox('tasks')).deleteFromDisk();
  //debugPaintLayerBordersEnabled = true;
  //debugPaintSizeEnabled = true;
  //debugPaintBaselinesEnabled = true;

  await Hive.openBox('tasks');
  var tasks = Hive.box('tasks').get('tasks');
  if (tasks == null) {
    Hive.box('tasks').put('tasks', []);
  }
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [Locale('ru')],
      theme: AppTheme.themeData,
      home: const HomePage(),
    );
  }
}
