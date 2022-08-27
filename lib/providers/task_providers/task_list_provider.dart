import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../models/task_model.dart';
import '../../repositories/tasks_controller.dart';

enum TaskListAction {
  create,
  fastCreate,
  edit,
  delete,
  update,
  none,
}

final taskList = StateNotifierProvider<TaskList, List<Task>>(
  (ref) {
    return TaskList([], TaskController());
  },
  name: 'taskList',
);

class TaskList extends StateNotifier<List<Task>> {
  TaskList(super.state, TaskController taskController)
      : _controller = taskController {
    _init();
  }

  final TaskController _controller;

  Task? _lastTask;

  Task? _originalLastTask;

  TaskListAction _lastAction = TaskListAction.none;

  Task? get lastTask => _lastTask;

  Task? get originalLastTask => _originalLastTask;

  TaskListAction get lastAction => _lastAction;

  Future<void> _init() async {
    state = _controller.getLocalTasks();
    state = await _controller.getTasks() ?? state;
  }

  Future<void> add(Task task, [bool isFastTask = false]) async {
    if (state.where((element) => element.id == task.id).isNotEmpty) return;

    if (isFastTask) {
      _lastAction = TaskListAction.fastCreate;
    } else {
      _lastAction = TaskListAction.create;
    }
    _lastTask = task;

    state = [
      ...state,
      task,
    ];

    final tasks = await _controller.addTask(task);
    if (tasks != null) {
      state = tasks;
    }
  }

  Future<void> edit(Task task) async {
    final index = state.indexWhere((element) => element.id == task.id);
    if (index != -1) {
      _lastAction = TaskListAction.edit;
      _lastTask = task;
      _originalLastTask = state[index];

      state = [
        for (final element in state)
          if (element.id == task.id) task else element,
      ];

      state = await _controller.editTask(task) ?? state;
    }
  }

  Future<void> delete(Task task) async {
    _lastAction = TaskListAction.delete;
    _lastTask = task;

    state = state.where((element) => element.id != task.id).toList();

    state = await _controller.deleteTask(task) ?? state;
  }

  Future<void> updateFromRemoteServer() async {
    _lastAction = TaskListAction.update;
    state = await _controller.getTasks() ?? state;
  }

  Task? getTaskById(String? taskId) {
    final list = state.where((element) => element.id == taskId);
    if (list.isNotEmpty) {
      return list.first;
    }
    return null;
  }
}
