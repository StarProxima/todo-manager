// // ignore_for_file: invalid_use_of_protected_member

// import 'package:flutter_test/flutter_test.dart';
// import 'package:mockito/annotations.dart';
// import 'package:mockito/mockito.dart';
// import 'package:todo_manager/core/providers.dart';
// import 'package:todo_manager/models/importance.dart';
// import 'package:todo_manager/models/response_data.dart';
// import 'package:todo_manager/models/task_model.dart';
// import 'package:todo_manager/repositories/task_remote_repository.dart';
// import 'package:todo_manager/repositories/tasks_controller.dart';

// import 'task_list_provider_test.mocks.dart';

// @GenerateMocks([TaskController])
// void main() {
//   late final TaskController taskController;
//   late TaskList taskList;

//   final task0 = Task.create(
//     text: 'Test task text',
//     done: true,
//     importance: Importance.low,
//     deadline: DateTime(2024),
//   );

//   final task1 = Task.create(
//     text: 'Test task text 2',
//     done: false,
//     importance: Importance.basic,
//     deadline: DateTime(2023, 6),
//   );

//   setUpAll(
//     () async {
//       taskController = MockTaskController();
//       when(taskController.getLocalTasks()).thenAnswer((_) => [task0]);
//       when(taskController.getTasks()).thenAnswer((_) async => [task1]);

//       // when(taskController.editTask).thenAnswer((_) {
//       //   return (_) async => null;
//       // });
//       // when(taskController.deleteTask).thenAnswer((_) {
//       //   return (_) async => null;
//       // });
//     },
//   );

//   setUp(() async {
//     taskList = TaskList([], taskController);
//   });

//   test(
//     '',
//     () {
//       expect(taskList.state, [task1]);
//     },
//   );

//   test(
//     '',
//     () {
//       taskList.add(task0);
//       expect(taskList.state, [task1, task0]);
//     },
//   );
// }

// class MockTaskRemoteRepository extends Mock implements TaskRemoteRepository {
//   @override
//   int activeRequests = 0;

//   @override
//   Future<ResponseData<Task>> addTask(Task task, int revision) {
//     return Future.value(ResponseData(isSuccesful: true, data: task));
//   }

//   @override
//   Future<ResponseData> deleteTask(Task task, int revision) {
//     return Future.value(ResponseData(isSuccesful: true, data: task));
//   }

//   @override
//   Future<ResponseData<Task>> editTask(Task task, int revision) {
//     return Future.value(ResponseData(isSuccesful: true, data: task));
//   }

//   @override
//   Future<ResponseData<List<Task>>> getTasks() {
//     return Future.value(const ResponseData(isSuccesful: true, data: []));
//   }

//   @override
//   Future<ResponseData<List<Task>>> patchTasks(List<Task> tasks, int revision) {
//     // TODO: implement patchTasks
//     throw UnimplementedError();
//   }
// }
