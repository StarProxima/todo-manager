// ignore_for_file: invalid_use_of_protected_member

import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:todo_manager/models/importance.dart';
import 'package:todo_manager/models/response_data.dart';
import 'package:todo_manager/models/task_model.dart';
import 'package:todo_manager/repositories/task_remote_repository.dart';
import 'package:todo_manager/repositories/tasks_controller.dart';

import '../../mocks/mock_task_local_repository.dart';
import '../../mocks/mock_task_remote_repository.dart';

void main() {
  late TaskController taskController;

  late MockTaskRemoteRepository mockRemote;

  late MockTaskLocalRepository mockLocal;

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
    mockRemote = MockTaskRemoteRepository();
    mockLocal = MockTaskLocalRepository();
  });

  test(
    'Merge when the same revision.',
    () async {
      final list = [
        task0,
        task1,
        task2,
      ];

      when(mockLocal.getTasks()).thenAnswer((realInvocation) => list);
      when(mockLocal.getRevision()).thenAnswer((realInvocation) => 0);
      when(mockRemote.getTasks()).thenAnswer(
        (realInvocation) async => ResponseData(
          isSuccesful: true,
          data: Rev(
            0,
            list,
          ),
        ),
      );

      taskController = TaskController(
        remote: mockRemote,
        local: mockLocal,
      );

      expect(taskController.getLocalTasks(), list);
      expectLater(await taskController.getTasks(), list);
    },
  );

  test(
    'Merge when the remote revision is bigger. '
    'Must return tasks from a remote server.',
    () async {
      final localList = [
        task0,
        task1,
        task2,
      ];

      final remoteList = [
        task1,
        task3,
        task2,
      ];

      when(mockLocal.getTasks()).thenAnswer((realInvocation) => localList);
      when(mockLocal.getRevision()).thenAnswer((realInvocation) => 1);
      when(mockRemote.getTasks()).thenAnswer(
        (realInvocation) async => ResponseData(
          isSuccesful: true,
          data: Rev(
            2,
            remoteList,
          ),
        ),
      );

      taskController = TaskController(
        remote: mockRemote,
        local: mockLocal,
      );

      expect(taskController.getLocalTasks(), localList);
      expectLater(await taskController.getTasks(), remoteList);
    },
  );

  test(
    'Merge when the remote revision is smaller. '
    'Must return tasks from a local repository.',
    () async {
      final localList = [
        task0,
        task1,
        task2,
      ];

      final remoteList = [
        task1,
        task3,
        task2,
      ];

      when(mockLocal.getTasks()).thenAnswer((realInvocation) => localList);
      when(mockLocal.getRevision()).thenAnswer((realInvocation) => 2);
      when(mockRemote.getTasks()).thenAnswer(
        (realInvocation) async => ResponseData(
          isSuccesful: true,
          data: Rev(
            2,
            remoteList,
          ),
        ),
      );

      when(mockRemote.patchTasks(localList, 2)).thenAnswer(
        (realInvocation) async => ResponseData(
          isSuccesful: true,
          data: Rev(
            2,
            localList,
          ),
        ),
      );

      taskController = TaskController(
        remote: mockRemote,
        local: mockLocal,
      );

      expect(taskController.getLocalTasks(), localList);
      expectLater(await taskController.getTasks(), localList);
    },
  );
}
