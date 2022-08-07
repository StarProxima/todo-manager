import 'dart:convert';
import 'dart:developer';

import 'package:flutter/foundation.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:todo_manager/repositories/task_repository.dart';
import '../models/response_data.dart';
import '../models/task_model.dart';
import '../support/logger.dart';

class TasksController {
  static final TasksController _instance = TasksController._();

  TasksController._();

  factory TasksController() {
    return _instance;
  }

  final TaskRepository _repository = TaskRepository();

  int _revision = 0;

  int get revision => _revision;
  set revision(int r) {
    if (r > _revision) {
      _revision = r;
    }
  }

  List<Task>? __tasks;
  set _tasks(List<Task> tasks) {
    __tasks = tasks;
  }

  List<Task> get _tasks {
    __tasks ??= (Hive.box('tasks').get('tasks') as Iterable)
        .map((e) => e as Task)
        .toList();
    return __tasks!;
  }

  int getCompletedTaskCount() {
    int count = 0;
    for (var task in _tasks) {
      if (task.done) {
        count++;
      }
    }
    return count;
  }

  ValueListenable<Box> getListenableTasksBox() {
    return Hive.box('tasks').listenable();
  }

  bool checkLocalChanges(List<Task> serverTasks) {
    bool localChanges = _tasks.length != serverTasks.length;

    if (!localChanges) {
      for (int i = 0; i < _tasks.length; i++) {
        if (!_tasks.contains(serverTasks[i])) {
          localChanges = true;
          break;
        }
      }
    }
    log(localChanges ? 'unsync data' : 'sync data');

    return localChanges;
  }

  int count = 0;

  Future<void> localSaveTasks() async {
    count++;
    await Hive.box('tasks').put('tasks', _tasks);
    count--;
  }

  Future<ResponseData<List<Task>>> checkTasks(
    ResponseData<List<Task>> response,
  ) async {
    if (response.isSuccesful) {
      bool localChanges = checkLocalChanges(response.data!);

      if (!localChanges) {
        revision = jsonDecode(response.message!)['revision'];
        return response.copyWith(data: _tasks);
      } else if (localChanges &&
          _repository.activeRequests == 0 &&
          count == 0) {
        var patchResponse = await _repository.patchTasks(_tasks, revision);
        if (patchResponse.isSuccesful &&
            _repository.activeRequests == 0 &&
            count == 0) {
          _tasks = patchResponse.data!;
          localSaveTasks();
          revision = jsonDecode(patchResponse.message!)['revision'];
          checkLocalChanges(response.data!);
          return patchResponse.copyWith(data: _tasks);
        }
      }
    }
    return response;
  }

  List<Task> getLocalTasks() {
    return _tasks;
  }

  Future<ResponseData<List<Task>>> getTasks() async {
    var response = await _repository.getTasks();
    response = await checkTasks(response);
    // logger.d(response.data);
    return response.copyWith(data: _tasks);
  }

  Future<ResponseData> addTask(Task task) async {
    _tasks.add(task);
    localSaveTasks();

    var response = await _repository.addTask(task, revision);

    if (response.isSuccesful) {
      revision = jsonDecode(response.message!)['revision'];
      var t = _tasks.firstWhere((element) => element.id == task.id);
      var index = _tasks.indexOf(t);

      _tasks[index] = response.data!;
      logger.v(response.data);
      localSaveTasks();
    } else {
      logger.w(response);
    }
    return const ResponseData(
      isSuccesful: true,
    );
  }

  Future<ResponseData> editTask(Task task) async {
    var t = _tasks.firstWhere((element) => element.id == task.id);
    var index = _tasks.indexOf(t);

    _tasks[index] = task.editAndCopyWith();
    localSaveTasks();

    var response = await _repository.editTask(task, revision);

    if (response.isSuccesful) {
      revision = jsonDecode(response.message!)['revision'];

      _tasks[index] = response.data!;
      logger.v(response.data);
      localSaveTasks();
    } else {
      logger.w(response);
    }
    return const ResponseData(
      isSuccesful: true,
    );
  }

  Future<ResponseData> deleteTask(Task task) async {
    var isSuccesRemove = _tasks.remove(task);

    localSaveTasks();

    var response = await _repository.deleteTask(task, revision);

    if (response.isSuccesful) {
      revision = jsonDecode(response.message!)['revision'];
    }
    logger.i(response);
    return ResponseData(
      isSuccesful: isSuccesRemove,
    );
  }
}
