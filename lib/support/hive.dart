import 'package:hive_flutter/adapters.dart';

import '../models/importance.dart';
import '../models/task_model.dart';

Future<void> initHive() async {
  await Hive.initFlutter();
  Hive.registerAdapter(TaskAdapter());
  Hive.registerAdapter(ImportanceAdapter());
  // await (await Hive.openBox('tasks')).deleteFromDisk();
  //debugPaintLayerBordersEnabled = true;
  //debugPaintSizeEnabled = true;
  //debugPaintBaselinesEnabled = true;
  await Hive.openBox('tasks');
  await Hive.openBox<int>('support');
  var tasks = Hive.box('tasks').get('tasks');
  if (tasks == null) {
    Hive.box('tasks').put('tasks', []);
  }
}
