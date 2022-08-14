import 'dart:convert';
import 'dart:developer';

import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:todo_manager/repositories/task_repository.dart';
import '../models/response_data.dart';
import '../models/task_filter.dart';
import '../models/task_model.dart';
import '../support/logger.dart';

final taskFilter = StateProvider<TaskFilter>((ref) => TaskFilter.all);

final taskList = StateNotifierProvider<TaskList, List<Task>>((ref) {
  return TaskList(_TaskController().getLocalTasks());
});

final filteredTaskList = Provider<List<Task>>((ref) {
  final filter = ref.watch(taskFilter);
  final tasks = ref.watch(taskList);

  switch (filter) {
    case TaskFilter.all:
      return tasks;
    case TaskFilter.uncompleted:
      return tasks.where((element) => !element.done).toList();
  }
});

final completedTaskCount = Provider<int>((ref) {
  log('completedTaskCount');
  return ref.watch(taskList).where((task) => task.done).length;
});

class TaskList extends StateNotifier<List<Task>> {
  TaskList(super.state);

  void add(Task task) {
    state = [
      ...state,
      task,
    ];
    _TaskController().addTask(task);
  }

  void edit(Task task) {
    state = [
      for (final element in state)
        if (element.id == task.id) task else element,
    ];
    _TaskController().editTask(task);
  }

  void remove(Task task) {
    // TODO: Возможно, найти лучшее решение.
    //Это нужно, чтобы ListView в HomePage не обновлялся при удалении,
    //иначе ломается Dismissible и нельзя удалить несколько тасков одновременно.
    state.remove(task);
    // state = state.where((element) => element.id != task.id).toList();
    _TaskController().deleteTask(task);
  }
}

class _TaskController {
  static final _TaskController _instance = _TaskController._();

  _TaskController._();

  factory _TaskController() {
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
  set tasks(List<Task> tasks) {
    __tasks = tasks;
  }

  List<Task> get tasks {
    __tasks ??= (Hive.box('tasks').get('tasks') as Iterable)
        .map((e) => e as Task)
        .toList();
    return __tasks!;
  }

  int getCompletedTaskCount() {
    int count = 0;
    for (var task in tasks) {
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
    bool localChanges = tasks.length != serverTasks.length;

    if (!localChanges) {
      for (int i = 0; i < tasks.length; i++) {
        if (!tasks.contains(serverTasks[i])) {
          localChanges = true;
          break;
        }
      }
    }
    log(localChanges ? 'unsync data' : 'sync data');

    for (int i = 0; i < tasks.length; i++) {
      for (int j = i + 1; j < tasks.length; j++) {
        if (tasks[i].id == tasks[j].id) {
          logger.e(tasks[i], tasks[j]);
        }
      }
    }

    return localChanges;
  }

  Future<void> localSaveTasks() async {
    await Hive.box('tasks').put('tasks', tasks);
    await Hive.box<int>('support').put('revision', _revision);
  }

  Future<ResponseData<List<Task>>> checkTasks(
    ResponseData<List<Task>> response,
  ) async {
    if (response.isSuccesful) {
      bool localChanges = checkLocalChanges(response.data!);

      if (!localChanges) {
        revision = jsonDecode(response.message!)['revision'];
        return response.copyWith(data: tasks);
      } else if (localChanges) {
        if (Hive.box<int>('support').get('revision') !=
            jsonDecode(response.message!)['revision']) {
          tasks = response.data!;
          revision = jsonDecode(response.message!)['revision'];
          localSaveTasks();
          logger.wtf(tasks);
        } else {
          var patchResponse = await _repository.patchTasks(tasks, revision);
          if (patchResponse.isSuccesful && _repository.activeRequests == 0) {
            tasks = patchResponse.data!;
            logger.e(tasks);
            localSaveTasks();
            revision = jsonDecode(patchResponse.message!)['revision'];
            checkLocalChanges(response.data!);
            return patchResponse.copyWith(data: tasks);
          }
        }
      }
    }
    return response;
  }

  List<Task> getLocalTasks() {
    getTasks();
    return tasks;
  }

  Future<ResponseData<List<Task>>> getTasks() async {
    var response = await _repository.getTasks();
    response = await checkTasks(response);
    // logger.d(response.data);
    return response.copyWith(data: tasks);
  }

  Future<ResponseData> addTask(Task task) async {
    tasks.add(task);
    localSaveTasks();

    var response = await _repository.addTask(task, revision);

    if (response.isSuccesful) {
      revision = jsonDecode(response.message!)['revision'];
      var t = tasks.firstWhere((element) => element.id == task.id);
      var index = tasks.indexOf(t);

      tasks[index] = response.data!;
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
    var t = tasks.firstWhere((element) => element.id == task.id);
    var index = tasks.indexOf(t);

    tasks[index] = task.editAndCopyWith();
    localSaveTasks();

    var response = await _repository.editTask(task, revision);

    if (response.isSuccesful) {
      revision = jsonDecode(response.message!)['revision'];

      tasks[index] = response.data!;
      //logger.v(response.data);
      localSaveTasks();
    } else {
      logger.w(response);
    }

    return const ResponseData(
      isSuccesful: true,
    );
  }

  Future<ResponseData> deleteTask(Task task) async {
    //logger.wtf(task);
    var isSuccesRemove = tasks.remove(task);

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
