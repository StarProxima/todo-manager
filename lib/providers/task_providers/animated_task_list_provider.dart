import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'other_task_providers.dart';
import 'task_list_provider.dart';

import '../../models/animated_task_model.dart';
import '../../models/task_model.dart';

final animatedTaskList =
    StateNotifierProvider<AnimatedTaskListState, List<AnimatedTask>>((ref) {
  final tasks = ref.read(sorteredFilteredTaskList);

  final animTasks = List.generate(tasks.length, (index) {
    return AnimatedTask(
      animation: TaskCardAnimation.show,
      position: index == 0 ? TaskCardPosition.top : TaskCardPosition.middle,
      task: tasks[index],
    );
  });

  return AnimatedTaskListState(ref, animTasks);
});

class AnimatedTaskListState extends StateNotifier<List<AnimatedTask>> {
  final StateNotifierProviderRef _ref;

  final List<AnimatedTask> _lastState = [];

  List<AnimatedTask> get lastState => _lastState;

  AnimatedTaskListState(this._ref, super.state) {
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
          final TaskCardAnimation status;
          Task selectTask = task;
          if (!contains(lastTasks, task) && contains(newTasks, task)) {
            status = TaskCardAnimation.show;
          } else if (contains(lastTasks, task) && !contains(newTasks, task)) {
            status = TaskCardAnimation.hide;
            final list =
                _ref.read(taskList).where((element) => element.id == task.id);
            if (list.isNotEmpty) {
              selectTask = list.first;
            }
          } else {
            status = TaskCardAnimation.basic;
          }
          tasks.add(selectTask);
          animatedTasks.add(
            AnimatedTask(
              animation: status,
              position: animatedTasks.isEmpty
                  ? TaskCardPosition.top
                  : TaskCardPosition.middle,
              task: selectTask,
            ),
          );
        }
      }

      state = animatedTasks
        ..sort((a, b) => _ref.read(taskSort)(a.task, b.task));
    });
  }

  void changeAnimation(Task task, TaskCardAnimation animation) {
    final index = state.indexWhere((element) => element.task.id == task.id);
    if (index != -1) {
      state[index] = state[index].copyWith(animation: animation);
    }
  }
}
