import 'dart:convert';
import 'dart:developer';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:todo_manager/repositories/task_local_repository.dart';
import 'package:todo_manager/repositories/task_remote_repository.dart';
import '../models/response_data.dart';
import '../models/task_filter.dart';
import '../models/task_model.dart';
import '../support/logger.dart';

final taskFilter = StateProvider<TaskFilter>((ref) => TaskFilter.all);

final taskList = StateNotifierProvider<TaskList, List<Task>>((ref) {
  return TaskList([]);
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
  return ref.watch(taskList).where((task) => task.done).length;
});

class TaskList extends StateNotifier<List<Task>> {
  TaskList(super.state) {
    _controller = _TaskController();
    state = _controller.getLocalTasks();
    _init();
  }
  late final _TaskController _controller;

  Future<void> _init() async {
    final tasks = await _controller.getRemoteTasks();
    if (tasks != null) {
      state = tasks;
    }
  }

  Future<void> add(Task task) async {
    state = [
      ...state,
      task,
    ];
    final tasks = await _controller.addTask(task);
    if (tasks != null) {
      for (final task in state) {
        if (!tasks.contains(task)) {
          logger.e('DELETE TASK IN PATH REQUEST', 'ALERT');
        }
      }
      state = tasks;
    }
  }

  Future<void> edit(Task task) async {
    state = [
      for (final element in state)
        if (element.id == task.id) task else element,
    ];
    final tasks = await _controller.editTask(task);
    if (tasks != null) {
      state = tasks;
    }
  }

  Future<void> remove(Task task) async {
    state = state.where((element) => element.id != task.id).toList();

    final tasks = await _controller.deleteTask(task);
    if (tasks != null) {
      state = tasks;
    }
  }

  void removeWithoutNotifying(Task task) {
    // TODO: Возможно, найти лучшее решение.
    //Это нужно, чтобы ListView в HomePage не обновлялся при удалении,
    //иначе ломается Dismissible и нельзя удалить несколько тасков одновременно.
    state.remove(task);
    _controller.deleteTask(task);
  }
}

class _TaskController {
  final TaskRemoteRepository _remoteRepository = TaskRemoteRepository();
  final TaskLocalRepository _localRepository = TaskLocalRepository();

  bool checkLocalChanges(List<Task> serverTasks) {
    final tasks = _localRepository.getTasks();
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
          logger.e([tasks[i], tasks[j]]);
        }
      }
    }

    return localChanges;
  }

  Future<ResponseData<List<Task>>> checkTasks(
    ResponseData<List<Task>> response,
  ) async {
    if (response.isSuccesful) {
      final tasks = _localRepository.getTasks();
      bool localChanges = checkLocalChanges(response.data!);

      if (!localChanges) {
        _localRepository.saveRevision(
          jsonDecode(response.message!)['revision'],
        );

        return response.copyWith(data: tasks);
      } else {
        log(
          _remoteRepository.activeRequests.toString() +
              (_localRepository.getRevision() <
                      jsonDecode(response.message!)['revision'])
                  .toString(),
        );
        if (_remoteRepository.activeRequests == 0 &&
            _localRepository.getRevision() <
                jsonDecode(response.message!)['revision']) {
          _localRepository.saveTasks(response.data!);

          _localRepository.saveRevision(
            jsonDecode(response.message!)['revision'],
          );
          checkLocalChanges(response.data!);
          logger.wtf(response.data!);
          return response;
        } else {
          var patchResponse = await _remoteRepository.patchTasks(
            tasks,
            _localRepository.getRevision(),
          );
          if (patchResponse.isSuccesful &&
              _remoteRepository.activeRequests == 0) {
            _localRepository.saveTasks(patchResponse.data!);
            logger.e(tasks);

            _localRepository.saveRevision(
              jsonDecode(patchResponse.message!)['revision'],
            );
            checkLocalChanges(patchResponse.data!);
            return patchResponse.copyWith(data: tasks);
          }
        }
      }
    }
    return response.copyWith(isSuccesful: false);
  }

  List<Task> getLocalTasks() {
    return _localRepository.getTasks();
  }

  Future<List<Task>?> getRemoteTasks() async {
    var response = await _remoteRepository.getTasks();
    response = await checkTasks(response);
    // logger.d(response.data);
    if (response.isSuccesful) {
      return response.data!;
    } else {
      return null;
    }
  }

  Future<List<Task>?> addTask(Task task) async {
    _localRepository.add(task);

    var response = await _remoteRepository.addTask(
      task,
      _localRepository.getRevision(),
    );

    if (response.isSuccesful) {
      _localRepository.saveRevision(
        jsonDecode(response.message!)['revision'],
      );
    } else if (response.status == 400) {
      logger.w(response);
      return await getRemoteTasks();
    }
    return _localRepository.getTasks();
  }

  Future<List<Task>?> editTask(Task task) async {
    _localRepository.edit(task);

    var response = await _remoteRepository.editTask(
      task,
      _localRepository.getRevision(),
    );

    if (response.isSuccesful) {
      _localRepository.saveRevision(
        jsonDecode(response.message!)['revision'],
      );
    } else if (response.status == 400) {
      logger.w(response);
      return await getRemoteTasks();
    }
    return _localRepository.getTasks();
  }

  Future<List<Task>?> deleteTask(Task task) async {
    _localRepository.remove(task);

    var response = await _remoteRepository.deleteTask(
      task,
      _localRepository.getRevision(),
    );

    if (response.isSuccesful) {
      _localRepository.saveRevision(
        jsonDecode(response.message!)['revision'],
      );
    } else if (response.status == 400) {
      logger.i(response);
      return await getRemoteTasks();
    }
    return _localRepository.getTasks();
  }
}
