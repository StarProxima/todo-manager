import 'dart:convert';
import 'dart:developer';

import 'package:hive_flutter/hive_flutter.dart';
import 'package:todo_manager/data/models/response_data.dart';
import 'package:todo_manager/data/models/task_model.dart';
import 'package:todo_manager/data/repositories/task_repository.dart';

abstract class TasksManager {
  static int revision = 0;

  static TaskRepository repository = TaskRepository();

  static List<Task>? _tasks;
  static List<Task> get tasks {
    return _tasks ??= _getLocalTasks();
  }

  static List<Task> _getLocalTasks() {
    _tasks = (Hive.box('tasks').get('tasks') as Iterable)
        .map((e) => e as Task)
        .toList();
    return _tasks ?? [];
  }

  static Future<void> save() async {
    await Hive.box('tasks').put('tasks', _tasks);
  }

  static Future<void> checkRevision(ResponseData response) async {
    if (response.isSuccesful) {
      bool localChanges = tasks.length != response.data!.length;
      int? badIndex;
      for (int i = 0; i < tasks.length && !localChanges; i++) {
        if (tasks[i] != response.data![i]) {
          localChanges = true;
          badIndex = i;
        }
      }

      log('localChanges $localChanges');
      if (localChanges) {
        if (badIndex != null) {
          log('local: ${tasks[badIndex]}');
          log('online: ${response.data![badIndex]}');
        } else {
          log('local: $tasks');
          log('online: ${response.data!}');
        }
      }
      if (!localChanges) {
        _tasks = response.data!;
        save();
        revision = jsonDecode(response.message!)['revision'];
      } else if (localChanges) {
        var patchResponce = await repository.patchTasks(tasks, revision);
        if (patchResponce.isSuccesful) {
          _tasks = patchResponce.data!;
          save();
          revision = jsonDecode(patchResponce.message!)['revision'];
          localChanges = false;
        }
      }
    }
  }

  static ResponseData<List<Task>> getLocalTasks() {
    return ResponseData(
      isSuccesful: true,
      data: tasks,
    );
  }

  static Future<ResponseData<List<Task>>> getTasks() async {
    var response = await repository.getTasks();
    await checkRevision(response);
    return response.copyWith(data: _tasks);
  }

  static Future<ResponseData> addTask(Task task) async {
    var response = await repository.addTask(task, revision);

    if (response.isSuccesful) {
      revision = jsonDecode(response.message!)['revision'];
      tasks.add(response.data!);
      save();
    } else {
      tasks.add(task);
      save();
    }

    return const ResponseData(
      isSuccesful: true,
    );
  }

  static Future<ResponseData> editTask(Task task) async {
    var t = tasks.firstWhere((element) => element.id == task.id);
    var index = tasks.indexOf(t);
    tasks[index] = task.copyWith();
    save();
    var response = await repository.editTask(task, revision);

    if (response.isSuccesful) {
      revision = jsonDecode(response.message!)['revision'];

      tasks[index] = response.data!;
      save();
    }

    return const ResponseData(
      isSuccesful: true,
    );
  }

  static Future<ResponseData> deleteTask(Task task) async {
    var isSuccesful = tasks.remove(task);
    if (isSuccesful) {
      save();

      var response = await repository.deleteTask(task, revision);

      if (response.isSuccesful) {
        revision = jsonDecode(response.message!)['revision'];
      }
    }

    return ResponseData(
      isSuccesful: isSuccesful,
    );
  }
}
