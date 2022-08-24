import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/task_filter.dart';
import '../models/task_model.dart';
import '../repositories/tasks_controller.dart';
import '../ui/task_card/task_card.dart';

final appThemeMode = StateNotifierProvider<AppThemeMode, ThemeMode>((ref) {
  return AppThemeMode(ThemeMode.system);
});

class AppThemeMode extends StateNotifier<ThemeMode> {
  AppThemeMode(super.state);

  void switchTheme() {
    state = state == ThemeMode.light ? ThemeMode.dark : ThemeMode.light;
  }
}

final taskFilter = StateProvider<TaskFilter>((ref) => TaskFilter.all);

final taskList = StateNotifierProvider<TaskList, List<Task>>((ref) {
  return TaskList([]);
});

List<Task> _lastTasks = [];
List<Task> lastTasks = [];

final filteredTaskList = Provider<List<Task>>((ref) {
  final filter = ref.watch(taskFilter);
  final tasks = ref.watch(taskList);

  final List<Task> filteredTask;
  switch (filter) {
    case TaskFilter.all:
      filteredTask = tasks;
      break;
    case TaskFilter.uncompleted:
      filteredTask = tasks.where((element) => !element.done).toList();
  }
  if (!identical(filteredTask, _lastTasks)) {
    lastTasks = _lastTasks;
    _lastTasks = filteredTask;
  }
  return filteredTask;
});

final sorteredFilteredTaskList = Provider<List<Task>>((ref) {
  final tasks = ref.watch(filteredTaskList)
    ..sort((a, b) => a.createdAt.compareTo(b.createdAt));
  return tasks;
});

final animatedTaskList = Provider<List<AnimatedTask>>((ref) {
  final newTasks = ref.watch(sorteredFilteredTaskList);

  List<Task> tasks = [];
  List<AnimatedTask> animatedTasks = [];

  final allTasks = [...newTasks, ...lastTasks]
    ..sort((a, b) => a.createdAt.compareTo(b.createdAt));

  bool contains(List<Task> list, Task task) {
    return list.where((element) => element.id == task.id).isNotEmpty;
  }

  for (final task in allTasks) {
    if (!contains(tasks, task)) {
      final TaskStatus status;
      if (!contains(lastTasks, task) && contains(newTasks, task)) {
        status = TaskStatus.create;
      } else if (contains(lastTasks, task) && !contains(newTasks, task)) {
        status = TaskStatus.hide;
      } else {
        status = TaskStatus.none;
      }
      tasks.add(task);
      animatedTasks.add(AnimatedTask(status: status, task: task));
    }
  }

  return animatedTasks;
});

class AnimatedTask {
  final TaskStatus status;
  final Task task;
  AnimatedTask({required this.status, required this.task});
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

class TaskList extends StateNotifier<List<Task>> {
  TaskList(super.state) {
    _init();
  }

  late final TaskController _controller;

  Future<void> _init() async {
    _controller = TaskController();
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

  Future<void> delete(Task task) async {
    state = state.where((element) => element.id != task.id).toList();

    state = await _controller.deleteTask(task) ?? state;
  }

  Future<void> updateFromRemoteServer() async {
    state = await _controller.getTasks() ?? state;
  }
}
