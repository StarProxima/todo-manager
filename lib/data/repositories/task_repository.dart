import 'dart:convert';
import 'dart:developer';

import 'package:todo_manager/data/models/task_model.dart';
import 'package:todo_manager/data/repositories/repository.dart';

class TaskRepository extends Repository {
  static const String baseUrl = 'https://beta.mrdekk.ru/todobackend';

  Future<List<Task>> getTaskList() async {
    final ResponseData response = await getRequest(
      "$baseUrl/list",
      headers: {
        "Authorization": 'Bearer Elesding',
      },
    );
    log(response.data);
    if (response.status == 200) {
      return (jsonDecode(response.data)['list'] as Iterable)
          .map((e) => Task.fromMap(e))
          .toList();
    }
    return [];
  }

  Future<ResponseData> addTask(Task task) async {
    final ResponseData response = await postRequest(
      url: "$baseUrl/list",
      parametrs: '''{
        "status": "ok",
        "element": ${task.toJson()}
      }''',
      headers: {
        "Authorization": 'Bearer Elesding',
        "X-Last-Known-Revision": '1',
      },
    );

    return response;
  }
}
