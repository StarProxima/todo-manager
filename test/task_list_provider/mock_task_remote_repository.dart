import 'package:mockito/mockito.dart';
import 'package:todo_manager/models/response_data.dart';
import 'package:todo_manager/models/task_model.dart';
import 'package:todo_manager/repositories/task_remote_repository.dart';

class MockTaskRemoteRepository extends Mock implements TaskRemoteRepository {
  @override
  int activeRequests = 0;

  int _revision = 0;

  Future<ResponseData<Rev>> getRespone(int revision) async {
    _revision = revision + 1;
    return ResponseData<Rev>(
      isSuccesful: true,
      data: Rev(
        revision + 1,
      ),
    );
  }

  @override
  Future<ResponseData<Rev>> addTask(Task task, int revision) {
    return getRespone(revision);
  }

  @override
  Future<ResponseData<Rev>> deleteTask(Task task, int revision) {
    return getRespone(revision);
  }

  @override
  Future<ResponseData<Rev>> editTask(Task task, int revision) {
    return getRespone(revision);
  }

  @override
  Future<ResponseData<Rev<List<Task>>>> getTasks() {
    return Future.value(
      ResponseData<Rev<List<Task>>>(
        isSuccesful: false,
        data: Rev(
          _revision,
        ),
      ),
    );
  }

  @override
  Future<ResponseData<Rev<List<Task>>>> patchTasks(
    List<Task> tasks,
    int revision,
  ) {
    return Future.value(
      ResponseData<Rev<List<Task>>>(
        isSuccesful: false,
        data: Rev(
          _revision,
        ),
      ),
    );
  }
}
