import 'package:mockito/mockito.dart';
import 'package:todo_manager/models/task_model.dart';
import 'package:todo_manager/repositories/task_local_repository.dart';

class MockTaskLocalRepository extends Mock implements TaskLocalRepository {
  List<Task> tasks = [];

  int revision = 0;

  @override
  void add(Task task) {
    tasks.add(task);
  }

  @override
  void edit(Task task) {
    tasks = [
      for (final element in tasks)
        if (element.id == task.id) task else element,
    ];
  }

  @override
  int getRevision() {
    return revision;
  }

  @override
  List<Task> getTasks() {
    return tasks;
  }

  @override
  void remove(Task task) {
    tasks.remove(task);
  }

  @override
  void saveRevision(int? revision) {
    this.revision = revision ?? this.revision;
  }

  @override
  void saveTasks(List<Task>? tasks) {
    this.tasks = tasks ?? this.tasks;
  }
}
