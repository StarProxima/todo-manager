import 'package:hive_flutter/hive_flutter.dart';
import 'package:todo_manager/data/models/responce_data.dart';
import 'package:todo_manager/data/models/task_model.dart';

abstract class TasksManager {
  static List<Task> _getLocalTasks() {
    return (Hive.box('tasks').get('tasks') as Iterable)
        .map((e) => e as Task)
        .toList();
  }

  static ResponseData<List<Task>> getLocalTasks() {
    try {
      return ResponseData(
        isSuccesful: true,
        data: _getLocalTasks(),
      );
    } catch (e) {
      return const ResponseData(
        message: 'Ошибка загрузки локальных данных',
        isSuccesful: false,
      );
    }
  }

  static Future<ResponseData> addTask(Task task) async {
    try {
      var tasks = _getLocalTasks();
      tasks.add(task);
      await Hive.box('tasks').put('tasks', tasks);

      return const ResponseData(
        isSuccesful: true,
      );
    } catch (e) {
      return const ResponseData(
        message: 'Ошибка загрузки локальных данных',
        isSuccesful: false,
      );
    }
  }

  static Future<ResponseData> editTask(Task task) async {
    try {
      var tasks = _getLocalTasks();
      var t = tasks.firstWhere((element) => element.id == task.id);
      var index = tasks.indexOf(t);
      tasks[index] = task;
      await Hive.box('tasks').put('tasks', tasks);
      return const ResponseData(
        isSuccesful: true,
      );
    } catch (e) {
      return const ResponseData(
        message: 'Ошибка загрузки локальных данных',
        isSuccesful: false,
      );
    }
  }

  static Future<ResponseData> deleteTask(Task task) async {
    try {
      var tasks = _getLocalTasks();

      var isSuccesful = tasks.remove(task);
      if (isSuccesful) {
        await Hive.box('tasks').put('tasks', tasks);
      }
      return ResponseData(
        isSuccesful: isSuccesful,
      );
    } catch (e) {
      return const ResponseData(
        message: 'Ошибка загрузки локальных данных',
        isSuccesful: false,
      );
    }
  }
}
