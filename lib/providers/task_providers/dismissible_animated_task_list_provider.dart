import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'other_task_providers.dart';

import '../app_providers.dart';
import '../../models/task_model.dart';
import 'task_list_provider.dart';

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
