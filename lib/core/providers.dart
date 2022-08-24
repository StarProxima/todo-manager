// ignore_for_file: public_member_api_docs, sort_constructors_first
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

  AnimatedTaskListState(this._ref) : super([]) {
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

class AnimatedTask {
  final TaskStatus status;
  final Task task;
  AnimatedTask({required this.status, required this.task});

  @override
  bool operator ==(covariant AnimatedTask other) {
    if (identical(this, other)) return true;

    return other.status == status && other.task == task;
  }

  @override
  int get hashCode => status.hashCode ^ task.hashCode;

  @override
  String toString() => 'AnimatedTask(status: $status, task: $task)';

  AnimatedTask copyWith({
    TaskStatus? status,
    Task? task,
  }) {
    return AnimatedTask(
      status: status ?? this.status,
      task: task ?? this.task,
    );
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
