import 'package:flutter/material.dart';

import 'package:hive_flutter/hive_flutter.dart';
import 'package:todo_manager/ui/home_page/home_page.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'generated/l10n.dart';
import 'models/importance.dart';
import 'models/task_model.dart';
import 'styles/app_theme.dart';

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
