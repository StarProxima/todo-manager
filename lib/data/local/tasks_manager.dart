import 'dart:convert';
import 'dart:developer';

import 'package:hive_flutter/hive_flutter.dart';
import 'package:todo_manager/data/models/response_data.dart';
import 'package:todo_manager/data/models/task_model.dart';
import 'package:todo_manager/data/repositories/task_repository.dart';

abstract class TasksManager {
  static TaskRepository repository = TaskRepository();

  static int _revision = 0;

  static int get revision => _revision;
  static set revision(int r) {
    if (r > _revision) {
      _revision = r;
    }
  }

  static List<Task>? _tasks;
  static List<Task> get tasks {
    return _tasks ?? _getLocalTasks();
  }

  static List<Task> _getLocalTasks() {
    return (Hive.box('tasks').get('tasks') as Iterable)
        .map((e) => e as Task)
        .toList();
  }

  static bool checkLocalChanges(List<Task> serverTasks) {
    bool localChanges = tasks.length != serverTasks.length;

    if (!localChanges) {
      for (int i = 0; i < tasks.length; i++) {
        if (!tasks.contains(serverTasks[i])) {
          localChanges = true;
        }
      }
    }
    log(localChanges ? 'unsync data' : 'sync data');

    return localChanges;
  }

  static Future<void> localSaveTasks() async {
    await Hive.box('tasks').put('tasks', tasks);
  }

  static Future<ResponseData<List<Task>>> checkRevision(
    ResponseData<List<Task>> response,
  ) async {
    if (response.isSuccesful) {
      bool localChanges = checkLocalChanges(response.data!);

      if (!localChanges) {
        _tasks = response.data!;
        localSaveTasks();
        revision = jsonDecode(response.message!)['revision'];
        return response.copyWith(data: _tasks);
      } else if (localChanges && repository.activeRequests == 0) {
        var patchResponce = await repository.patchTasks(tasks, revision);

        if (patchResponce.isSuccesful) {
          _tasks = patchResponce.data!;
          localSaveTasks();
          revision = jsonDecode(patchResponce.message!)['revision'];
          localChanges = checkLocalChanges(response.data!);
          return patchResponce.copyWith(data: _tasks);
        }
      }
    }
    return response;
  }

  static ResponseData<List<Task>> getLocalTasks() {
    return ResponseData(
      isSuccesful: true,
      data: tasks,
    );
  }

  static Future<ResponseData<List<Task>>> getTasks() async {
    var response = await repository.getTasks();
    response = await checkRevision(response);
    return response.copyWith(data: tasks);
  }

  static Future<ResponseData> addTask(Task task) async {
    tasks.add(task);
    localSaveTasks();

    var response = await repository.addTask(task, revision);

    if (response.isSuccesful) {
      revision = jsonDecode(response.message!)['revision'];
      var t = tasks.firstWhere((element) => element.id == task.id);
      var index = tasks.indexOf(t);

      tasks[index] = response.data!;
      localSaveTasks();
    }

    return const ResponseData(
      isSuccesful: true,
    );
  }

  static Future<ResponseData> editTask(Task task) async {
    var t = tasks.firstWhere((element) => element.id == task.id);
    var index = tasks.indexOf(t);

    tasks[index] = task.copyWith();
    localSaveTasks();

    var response = await repository.editTask(task, revision);

    if (response.isSuccesful) {
      revision = jsonDecode(response.message!)['revision'];

      tasks[index] = response.data!;
      localSaveTasks();
    }

    return const ResponseData(
      isSuccesful: true,
    );
  }

  static Future<ResponseData> deleteTask(Task task) async {
    var isSuccesRemove = tasks.remove(task);
    localSaveTasks();

    var response = await repository.deleteTask(task, revision);

    if (response.isSuccesful) {
      revision = jsonDecode(response.message!)['revision'];
    }

    return ResponseData(
      isSuccesful: isSuccesRemove,
    );
  }
}
