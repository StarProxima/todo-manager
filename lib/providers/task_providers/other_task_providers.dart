import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'task_list_provider.dart';

import '../../models/task_filter.dart';
import '../../models/task_model.dart';

final taskFilter = StateProvider<TaskFilter>(
  (ref) => TaskFilter.all,
  name: 'taskFilter',
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

final completedTaskCount = Provider<int>((ref) {
  return ref.watch(taskList).where((task) => task.done).length;
});
