import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../models/animated_task_model.dart';
import '../app_providers.dart';
import 'animated_task_list_provider.dart';

import '../../models/task_model.dart';
import 'task_list_provider.dart';

final dismissibleAnimatedTaskList =
    StateNotifierProvider<DismissibleAnimatedTaskListState, List<AnimatedTask>>(
  (ref) {
    return DismissibleAnimatedTaskListState(ref);
  },
);

class DismissibleAnimatedTaskListState
    extends StateNotifier<List<AnimatedTask>> {
  StateNotifierProviderRef ref;
  bool lastActionIsNotDismiss = true;

  DismissibleAnimatedTaskListState(
    this.ref,
  ) : super(ref.read(animatedTaskList)) {
    ref.listen(animatedTaskList, (t0, t1) async {
      if (lastActionIsNotDismiss) {
        state = ref.read(animatedTaskList);
      } else {
        lastActionIsNotDismiss = true;
      }
    });

    ref.listen(appThemeMode, (previous, next) {
      state = ref.read(animatedTaskList);
    });
  }

  void dismissDelete(Task task) {
    lastActionIsNotDismiss = false;

    ref.read(taskList.notifier).delete(task);
    ref.read(animatedTaskList.notifier).changeAnimation(
          task,
          TaskCardAnimation.empty,
        );
  }

  void dismissEdit(Task task) {
    lastActionIsNotDismiss = false;
    ref.read(taskList.notifier).edit(task);
    ref.read(animatedTaskList.notifier).changeAnimation(
          task,
          TaskCardAnimation.empty,
        );
  }
}
