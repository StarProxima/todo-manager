import 'dart:convert';

import 'package:todo_manager/data/models/task_model.dart';
import 'package:todo_manager/data/repositories/repository.dart';

class TaskRepository {
  static const String baseUrl = 'https://beta.mrdekk.ru/todobackend';
  static int? revision = 0;

  Future<List<Task>> getTasks() async {
    final ResponseData response = await Repository.get(
      url: "$baseUrl/list",
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
    final ResponseData response = await Repository.post(
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
    if (response.status == 200) {
      revision = jsonDecode(response.data)['revision'];
    }
    return response;
  }

  Future<ResponseData> editTask(Task task) async {
    final ResponseData response = await Repository.put(
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
    if (response.status == 200) {
      revision = jsonDecode(response.data)['revision'];
    }
    return response;
  }

  Future<ResponseData> deleteTask(Task task) async {
    final ResponseData response = await Repository.delete(
      url: "$baseUrl/list/${task.id}",
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
