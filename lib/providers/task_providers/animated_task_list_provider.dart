import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'other_task_providers.dart';
import 'task_list_provider.dart';

import '../../models/animated_task_model.dart';
import '../../models/task_model.dart';
import '../../ui/task_card/task_card.dart';

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
