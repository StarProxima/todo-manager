import 'dart:convert';

import 'package:todo_manager/data/models/task_model.dart';
import 'package:todo_manager/data/repositories/repository.dart';

class TaskRepository extends Repository {
  static const String baseUrl = 'https://beta.mrdekk.ru/todobackend';
  static int? revision = 0;

  Future<List<Task>> getTasks() async {
    final ResponseData response = await getRequest(
      "$baseUrl/list",
      headers: {
        "Authorization": "Bearer Elesding",
      },
    );

    if (response.status == 200) {
      revision = jsonDecode(response.data)['revision'];

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
        "Authorization": "Bearer Elesding",
        "Content-Type": "application/json",
        "X-Last-Known-Revision": "$revision",
      },
    );
    if (response.status == 200) {
      revision = jsonDecode(response.data)['revision'];
    }
    return response;
  }

  Future<ResponseData> editTask(Task task) async {
    final ResponseData response = await putRequest(
      url: "$baseUrl/list/${task.id}",
      parametrs: '''{
        "status": "ok",
        "element": ${task.toJson()}
      }''',
      headers: {
        "Authorization": "Bearer Elesding",
        "Content-Type": "application/json",
        "X-Last-Known-Revision": "$revision",
      },
    );
    if (response.status == 200) {
      revision = jsonDecode(response.data)['revision'];
    }
    return response;
  }
}
