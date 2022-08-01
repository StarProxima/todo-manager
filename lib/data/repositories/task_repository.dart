import 'dart:convert';

import 'package:todo_manager/data/models/response_data.dart';
import 'package:todo_manager/data/models/task_model.dart';
import 'package:todo_manager/data/repositories/repository.dart';

class TaskRepository {
  static const String baseUrl = 'https://beta.mrdekk.ru/todobackend';

  int activeRequests = 0;

  Future<ResponseData<List<Task>>> getTasks() async {
    activeRequests++;
    final Response response = await Repository.get(
      url: "$baseUrl/list",
      headers: {
        "Authorization": "Bearer Elesding",
      },
    );
    activeRequests--;
    if (response.isSuccesful) {
      return ResponseData.response(
        response,
        (jsonDecode(response.body)['list'] as Iterable)
            .map((e) => Task.fromMap(e))
            .toList(),
      );
    }
    return ResponseData.response(response);
  }

  Future<ResponseData<List<Task>>> patchTasks(
    List<Task> tasks,
    int revision,
  ) async {
    activeRequests++;
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
    activeRequests--;
    if (response.isSuccesful) {
      return ResponseData.response(
        response,
        (jsonDecode(response.body)['list'] as Iterable)
            .map((e) => Task.fromMap(e))
            .toList(),
      );
    }
    return ResponseData.response(response);
  }

  Future<ResponseData<Task>> addTask(Task task, int revision) async {
    activeRequests++;
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
    activeRequests--;
    if (response.isSuccesful) {
      return ResponseData.response(
        response,
        Task.fromMap(jsonDecode(response.body)['element']),
      );
    }

    return ResponseData.response(response);
  }

  Future<ResponseData<Task>> editTask(Task task, int revision) async {
    activeRequests++;
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
    activeRequests--;
    if (response.isSuccesful) {
      return ResponseData.response(
        response,
        Task.fromMap(jsonDecode(response.body)['element']),
      );
    }

    return ResponseData.response(response);
  }

  Future<ResponseData> deleteTask(Task task, int revision) async {
    activeRequests++;
    final Response response = await Repository.delete(
      url: "$baseUrl/list/${task.id}",
      headers: {
        "Authorization": "Bearer Elesding",
        "Content-Type": "application/json",
        "X-Last-Known-Revision": "$revision",
      },
    );
    activeRequests--;
    return ResponseData.response(response);
  }
}
