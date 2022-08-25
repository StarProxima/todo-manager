// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:developer';

import 'package:appmetrica_plugin/appmetrica_plugin.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/animated_task_model.dart';
import '../models/task_filter.dart';
import '../models/task_model.dart';
import '../repositories/tasks_controller.dart';
import '../ui/task_card/task_card.dart';

final appThemeMode = StateNotifierProvider<AppThemeMode, ThemeMode>(
  (ref) {
    return AppThemeMode(ThemeMode.system);
  },
  name: 'appThemeMode',
);

class AppThemeMode extends StateNotifier<ThemeMode> {
  AppThemeMode(super.state);

  void switchTheme() {
    AppMetrica.reportEvent('Switch theme');
    state = state == ThemeMode.light ? ThemeMode.dark : ThemeMode.light;
  }
}

final taskFilter = StateProvider<TaskFilter>(
  (ref) => TaskFilter.all,
  name: 'taskFilter',
);

final taskList = StateNotifierProvider<TaskList, List<Task>>(
  (ref) {
    return TaskList([]);
  },
  name: 'taskList',
);

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

final taskSort = StateProvider<int Function(Task, Task)>(
  (ref) => (a, b) {
    return a.createdAt.compareTo(b.createdAt);
  },
);

final sorteredFilteredTaskList = Provider<List<Task>>((ref) {
  final sort = ref.watch(taskSort);
  final tasks = ref.watch(filteredTaskList)..sort(sort);
  return tasks;
});

final animatedTaskList =
    StateNotifierProvider<AnimatedTaskListState, List<AnimatedTask>>((ref) {
  return AnimatedTaskListState(ref);
});

class AnimatedTaskListState extends StateNotifier<List<AnimatedTask>> {
  final StateNotifierProviderRef _ref;

  final List<AnimatedTask> _lastState = [];

  List<AnimatedTask> get lastState => _lastState;

  AnimatedTaskListState(this._ref)
      : super(
          _ref
              .read(sorteredFilteredTaskList)
              .map((e) => AnimatedTask(status: TaskStatus.create, task: e))
              .toList(),
        ) {
    _init();
  }

  void _init() {
    _ref.listen<List<Task>>(sorteredFilteredTaskList, (previous, next) {
      final newTasks = next;
      final lastTasks = previous ?? [];

      List<Task> tasks = [];
      List<AnimatedTask> animatedTasks = [];

      final allTasks = [...newTasks, ...lastTasks];

      bool contains(List<Task> list, Task task) {
        return list.where((element) => element.id == task.id).isNotEmpty;
      }

      for (final task in allTasks) {
        if (!contains(tasks, task)) {
          final TaskStatus status;
          Task selectTask = task;
          if (!contains(lastTasks, task) && contains(newTasks, task)) {
            status = TaskStatus.create;
          } else if (contains(lastTasks, task) && !contains(newTasks, task)) {
            status = TaskStatus.hide;
            final list =
                _ref.read(taskList).where((element) => element.id == task.id);
            if (list.isNotEmpty) {
              selectTask = list.first;
            }
          } else {
            status = TaskStatus.none;
          }
          tasks.add(selectTask);
          animatedTasks.add(AnimatedTask(status: status, task: selectTask));
        }
      }

      state = animatedTasks
        ..sort((a, b) => _ref.read(taskSort)(a.task, b.task));
    });
  }

  void changeStatus(AnimatedTask task) {
    final index =
        state.indexWhere((element) => element.task.id == task.task.id);
    if (index != -1) {
      state[index] = state[index].copyWith(status: task.status);
    }
  }
}

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
    ref.listen(filteredTaskList, (t0, t1) async {
      if (lastActionIsNotDismiss) {
        state = !state;
      } else {
        lastActionIsNotDismiss = true;
      }
    });

    ref.listen(appThemeMode, (previous, next) {
      state = !state;
    });
  }

  void dismissDelete(Task task) {
    lastActionIsNotDismiss = false;
    ref.read(taskList.notifier).delete(task);
  }

  void dismissEdit(Task task) {
    lastActionIsNotDismiss = false;
    ref.read(taskList.notifier).edit(task);
  }
}

enum TaskListAction {
  create,
  edit,
  delete,
  update,
}

class TaskList extends StateNotifier<List<Task>> {
  TaskList(super.state) {
    _init();
  }

  late final TaskController _controller;

  TaskListAction lastAction = TaskListAction.update;

  Future<void> _init() async {
    _controller = TaskController();
    state = _controller.getLocalTasks();
    state = await _controller.getTasks() ?? state;
  }

  Future<void> add(Task task) async {
    lastAction = TaskListAction.create;
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
    lastAction = TaskListAction.edit;
    state = [
      for (final element in state)
        if (element.id == task.id) task else element,
    ];
    state = await _controller.editTask(task) ?? state;
  }

  Future<void> delete(Task task) async {
    lastAction = TaskListAction.delete;
    state = state.where((element) => element.id != task.id).toList();

    state = await _controller.deleteTask(task) ?? state;
  }

  Future<void> updateFromRemoteServer() async {
    lastAction = TaskListAction.update;
    state = await _controller.getTasks() ?? state;
  }
}
