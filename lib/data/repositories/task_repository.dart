import 'dart:convert';

import 'package:todo_manager/data/models/responce_datadart';
import 'package:todo_manager/data/models/task_model.dart';
import 'package:todo_manager/data/repositories/repository.dart';

class TaskRepository {
  static const String baseUrl = 'https://beta.mrdekk.ru/todobackend';
  static int? revision = 0;

  Future<ResponseData<List<Task>>> getTasks() async {
    final Response response = await Repository.get(
      url: "$baseUrl/list",
      headers: {
        "Authorization": "Bearer Elesding",
      },
    );

    if (response.isSuccesful) {
      revision = jsonDecode(response.body)['revision'];
      return ResponseData.response(
        response,
        (jsonDecode(response.body)['list'] as Iterable)
            .map((e) => Task.fromMap(e))
            .toList(),
      );
    }
    return ResponseData.response(response);
  }

  Future<ResponseData<List<Task>>> patchTasks(List<Task> tasks) async {
    final Response response = await Repository.patch(
      url: "$baseUrl/list",
      headers: {
        "Authorization": "Bearer Elesding",
        "Content-Type": "application/json",
        "X-Last-Known-Revision": "$revision",
      },
      body: jsonEncode({
        "status": "ok",
        "list": tasks.map((e) => e.toMap()).toList(),
      }),
    );

    if (response.isSuccesful) {
      revision = jsonDecode(response.body)['revision'];
      return ResponseData.response(
        response,
        (jsonDecode(response.body)['list'] as Iterable)
            .map((e) => Task.fromMap(e))
            .toList(),
      );
    }
    return ResponseData.response(response);
  }

  Future<ResponseData> addTask(Task task) async {
    final Response response = await Repository.post(
      url: "$baseUrl/list",
      headers: {
        "Authorization": "Bearer Elesding",
        "Content-Type": "application/json",
        "X-Last-Known-Revision": "$revision",
      },
      body: jsonEncode({
        "status": "ok",
        "element": task.toMap(),
      }),
    );
    if (response.isSuccesful) {
      revision = jsonDecode(response.body)['revision'];
    }
    return ResponseData.response(response);
  }

  Future<ResponseData> editTask(Task task) async {
    final Response response = await Repository.put(
      url: "$baseUrl/list/${task.id}",
      headers: {
        "Authorization": "Bearer Elesding",
        "Content-Type": "application/json",
        "X-Last-Known-Revision": "$revision",
      },
      body: jsonEncode({
        "status": "ok",
        "element": task.toMap(),
      }),
    );
    if (response.isSuccesful) {
      revision = jsonDecode(response.body)['revision'];
    }
    return ResponseData.response(response);
  }

  Future<ResponseData> deleteTask(Task task) async {
    final Response response = await Repository.delete(
      url: "$baseUrl/list/${task.id}",
      headers: {
        "Authorization": "Bearer Elesding",
        "Content-Type": "application/json",
        "X-Last-Known-Revision": "$revision",
      },
    );
    if (response.isSuccesful) {
      revision = jsonDecode(response.body)['revision'];
    }
    return ResponseData.response(response);
  }
}
