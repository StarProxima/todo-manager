import 'dart:convert';

import 'package:hive_flutter/hive_flutter.dart';
import 'package:todo_manager/data/models/response_data.dart';
import 'package:todo_manager/data/models/task_model.dart';
import 'package:todo_manager/data/repositories/task_repository.dart';

abstract class TasksManager {
  static int revision = 0;

  static bool localChanges = false;
  static TaskRepository repository = TaskRepository();

  static List<Task> _getLocalTasks() {
    return (Hive.box('tasks').get('tasks') as Iterable)
        .map((e) => e as Task)
        .toList();
  }

  static Future<void> save(List<Task> tasks) async {
    await Hive.box('tasks').put('tasks', tasks);
  }

  static Future<void> saveRevision() async {}

  static ResponseData<List<Task>> getLocalTasks() {
    try {
      return ResponseData(
        isSuccesful: true,
        data: _getLocalTasks(),
      );
    } catch (e) {
      rethrow;
      return const ResponseData(
        message: 'Ошибка загрузки локальных данных',
        isSuccesful: false,
      );
    }
  }

  static Future<ResponseData<List<Task>>> getTasks() async {
    try {
      var response = await repository.getTasks();
      if (response.isSuccesful) {
        revision = jsonDecode(response.message!)['revision'];
      }

      return response;
    } catch (e) {
      rethrow;
      return const ResponseData(
        isSuccesful: false,
      );
    }
  }

  static Future<ResponseData> addTask(Task task) async {
    try {
      var tasks = _getLocalTasks();
      tasks.add(task);
      await save(tasks);

      var response = await repository.addTask(task, revision);

      if (response.isSuccesful) {
        revision = jsonDecode(response.message!)['revision'];
      } else {
        localChanges = true;
      }

      return const ResponseData(
        isSuccesful: true,
      );
    } catch (e) {
      rethrow;
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
      await save(tasks);

      var response = await repository.editTask(t, revision);

      if (response.isSuccesful) {
        revision = jsonDecode(response.message!)['revision'];
      } else {
        localChanges = true;
      }

      return const ResponseData(
        isSuccesful: true,
      );
    } catch (e) {
      rethrow;
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
        await save(tasks);

        var response = await repository.deleteTask(task, revision);

        if (response.isSuccesful) {
          revision = jsonDecode(response.message!)['revision'];
        } else {
          localChanges = true;
        }
      }

      return ResponseData(
        isSuccesful: isSuccesful,
      );
    } catch (e) {
      rethrow;
      return const ResponseData(
        message: 'Ошибка загрузки локальных данных',
        isSuccesful: false,
      );
    }
  }
}
