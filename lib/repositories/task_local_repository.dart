import 'package:hive_flutter/hive_flutter.dart';

import '../models/task_model.dart';

class TaskLocalRepository {
  List<Task>? _tasks;

  int? _revision;

  void saveTasks(List<Task> tasks) {
    _tasks = tasks;
    Hive.box('tasks').put('tasks', tasks);
  }

  void add(Task task) {
    final tasks = getTasks();
    saveTasks([...tasks, task]);
  }

  void edit(Task task) {
    final tasks = getTasks();
    saveTasks(
      [
        for (final element in tasks)
          if (element.id == task.id) task else element,
      ],
    );
  }

  void remove(Task task) {
    final tasks = getTasks();
    saveTasks(
      tasks.where((element) => element.id != task.id).toList(),
    );
  }

  List<Task> getTasks() {
    _tasks ??= (Hive.box('tasks').get('tasks') as Iterable)
        .map((e) => e as Task)
        .toList();

    return _tasks!;
  }

  void saveRevision(int revision) {
    if (revision > (_revision ?? -1)) {
      _revision = revision;
      Hive.box<int>('support').put('revision', revision);
    }
  }

  int getRevision() {
    _revision ??= Hive.box<int>('support').get('revision');
    return _revision ?? -1;
  }
}
