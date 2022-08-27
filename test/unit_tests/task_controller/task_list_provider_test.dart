// ignore_for_file: invalid_use_of_protected_member

import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:todo_manager/models/importance.dart';
import 'package:todo_manager/models/task_model.dart';
import 'package:todo_manager/providers/task_providers/task_list_provider.dart';
import 'package:todo_manager/repositories/tasks_controller.dart';

import '../../mocks/mock_task_local_repository.dart';
import '../../mocks/mock_task_remote_repository.dart';

@GenerateMocks([TaskController])
void main() {
  late TaskController taskController;
  late TaskList taskList;

  final task0 = Task.create(
    text: 'task0',
    done: true,
    importance: Importance.low,
    deadline: DateTime(2023),
  );

  final task1 = Task.create(
    text: 'task1',
    done: false,
    importance: Importance.basic,
    deadline: DateTime(2024),
  );

  final task2 = Task.create(
    text: 'task2',
    done: true,
    importance: Importance.important,
    deadline: null,
  );

  final task3 = Task.create(
    text: 'task3',
    done: false,
    importance: Importance.low,
    deadline: DateTime(2026),
  );

  setUp(() async {
    taskController = TaskController(
      remote: MockTaskRemoteRepository(),
      local: MockTaskLocalRepository(),
    );
    taskList = TaskList([], taskController);
  });

  test(
    'TaskList init',
    () {
      expect(taskList.state, []);
    },
  );

  test(
    'TaskList add',
    () {
      taskList.add(task0);
      taskList.add(task1);
      taskList.add(task1);
      taskList.add(task0);
      taskList.add(task2);
      taskList.add(task1);
      expect(taskList.state, [task0, task1, task2]);
    },
  );

  test(
    'TaskList edit',
    () {
      taskList.add(task0);

      taskList.add(task1);
      final editedTask0 = task0.edit(text: 'task0 edited');
      taskList.edit(editedTask0);
      taskList.add(task2);

      expect(taskList.state, [editedTask0, task1, task2]);
    },
  );

  test(
    'TaskList delete',
    () {
      taskList.add(task1);
      taskList.add(task2);
      taskList.add(task3);
      taskList.delete(task2);
      taskList.add(task2);
      taskList.delete(task0);

      expect(taskList.state, [task1, task3, task2]);
    },
  );
}
