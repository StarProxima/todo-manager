import 'dart:async';
import 'dart:convert';
import 'dart:developer';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'task_local_repository.dart';
import 'task_remote_repository.dart';
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

///This provider is not updated when a dismiss in taskList.
///
///This is necessary so that the Dismissed widgets with multiple dismissed do not break when rebuilding.
///
///Does not provide data.
final dismissibleTaskListController =
    StateNotifierProvider<DismissibleTaskListController, bool>(
  (ref) {
    return DismissibleTaskListController(ref);
  },
);

class DismissibleTaskListController extends StateNotifier<bool> {
  StateNotifierProviderRef ref;
  bool lastActionIsNotDismiss = true;

  DismissibleTaskListController(
    this.ref,
  ) : super(false) {
    ref.listen(filteredTaskList, (t0, t1) {
      if (lastActionIsNotDismiss) {
        state = !state;
      } else {
        lastActionIsNotDismiss = true;
      }
    });
  }

  void dismiss(Task task) {
    lastActionIsNotDismiss = false;
    ref.read(taskList.notifier).remove(task);
  }
}

class TaskList extends StateNotifier<List<Task>> {
  TaskList(super.state) {
    _init();
  }

  late final _TaskController _controller;

  Future<void> _init() async {
    _controller = _TaskController();
    state = _controller.getLocalTasks();
    state = await _controller.getTasks() ?? state;
  }

  Future<void> add(Task task) async {
    state = [
      ...state,
      task,
    ];
    final tasks = await _controller.addTask(task);
    if (tasks != null) {
      log('tasks != null');
      state = tasks;
    }
  }

  Future<void> edit(Task task) async {
    state = [
      for (final element in state)
        if (element.id == task.id) task else element,
    ];
    state = await _controller.editTask(task) ?? state;
  }

  Future<void> remove(Task task) async {
    state = state.where((element) => element.id != task.id).toList();

    state = await _controller.deleteTask(task) ?? state;
  }

  Future<void> updateFromRemoteServer() async {
    state = await _controller.getTasks() ?? state;
  }
}

class _TaskController {
  final TaskRemoteRepository _remoteRepository = TaskRemoteRepository();
  final TaskLocalRepository _localRepository = TaskLocalRepository();

  bool checkChanges(List<Task> localTasks, List<Task> serverTasks) {
    bool changes = localTasks.length != serverTasks.length;

    if (!changes) {
      for (int i = 0; i < localTasks.length; i++) {
        if (!localTasks.contains(serverTasks[i])) {
          changes = true;
          break;
        }
      }
    }

    log(changes ? 'unsync data' : 'sync data');

    for (int i = 0; i < localTasks.length; i++) {
      for (int j = i + 1; j < localTasks.length; j++) {
        if (localTasks[i].id == localTasks[j].id) {
          logger.e([localTasks[i], localTasks[j]]);
        }
      }
    }

    return changes;
  }

  Future<List<Task>?> checkTasks(
    List<Task> remoteTasks,
    int revision,
  ) async {
    final tasks = _localRepository.getTasks();

    List<Task> noChanges() {
      log('noChanges');
      _localRepository.saveRevision(revision);
      return remoteTasks;
    }

    List<Task> remoteChanges() {
      log('remoteChanges');
      _localRepository.saveTasks(remoteTasks);
      _localRepository.saveRevision(revision);
      checkChanges(tasks, remoteTasks);
      logger.wtf(remoteTasks);
      return remoteTasks;
    }

    Future<List<Task>?> localChanges() async {
      log('localChanges');
      var response = await _remoteRepository.patchTasks(
        tasks,
        _localRepository.getRevision(),
      );
      if (response.isSuccesful && _remoteRepository.activeRequests == 0) {
        _localRepository.saveTasks(response.data!);
        _localRepository.saveRevision(
          jsonDecode(response.message!)['revision'],
        );
        checkChanges(tasks, response.data!);
        logger.e(tasks);
        return response.data!;
      }
      return null;
    }

    if (!checkChanges(tasks, remoteTasks)) {
      return noChanges();
    } else {
      if (_remoteRepository.activeRequests == 0 &&
          _localRepository.getRevision() < revision) {
        return remoteChanges();
      } else {
        return localChanges();
      }
    }
  }

  List<Task> getLocalTasks() {
    return _localRepository.getTasks();
  }

  Future<List<Task>?> getTasks() async {
    var response = await _remoteRepository.getTasks();
    if (response.isSuccesful) {
      return await checkTasks(
        response.data!,
        jsonDecode(response.message!)['revision'],
      );
    }

    return null;
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
      return await getTasks();
    }
    return null;
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
      return await getTasks();
    }
    return null;
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
      return await getTasks();
    }
    return null;
  }
}
