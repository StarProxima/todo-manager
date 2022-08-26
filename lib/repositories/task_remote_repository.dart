import 'dart:convert';

import '../../models/response_data.dart';
import '../../models/task_model.dart';
import 'repository.dart';

class TaskRemoteRepository {
  static const String baseUrl = 'https://beta.mrdekk.ru/todobackend';

  int activeRequests = 0;

  Future<ResponseData<Rev<List<Task>>>> getTasks() async {
    activeRequests++;
    final Response response = await Repository.get(
      url: "$baseUrl/list",
      headers: {
        "Authorization": "Bearer Elesding",
      },
    );
    activeRequests--;
    if (response.isSuccesful) {
      final json = jsonDecode(response.body);
      return ResponseData.response(
        response,
        Rev(
          json['revision'],
          (json['list'] as Iterable).map((e) => Task.fromJson(e)).toList(),
        ),
      );
    }
    return ResponseData.response(response);
  }

  Future<ResponseData<Rev<List<Task>>>> patchTasks(
    List<Task> tasks,
    int revision,
  ) async {
    activeRequests++;

    final body = jsonEncode({
      "status": "ok",
      "list": tasks.map((e) => e.toJson()).toList(),
    });

    final Response response = await Repository.patch(
      url: "$baseUrl/list",
      headers: {
        "Authorization": "Bearer Elesding",
        "Content-Type": "application/json",
        "X-Last-Known-Revision": "$revision",
      },
      body: body,
    );

    activeRequests--;
    if (response.isSuccesful) {
      final json = jsonDecode(response.body);
      return ResponseData.response(
        response,
        Rev(
          json['revision'],
          (json['list'] as Iterable).map((e) => Task.fromJson(e)).toList(),
        ),
      );
    }
    return ResponseData.response(response);
  }

  Future<ResponseData> addTask(Task task, int revision) async {
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
        "element": task.toJson(),
      }),
    );
    activeRequests--;
    if (response.isSuccesful) {
      return ResponseData.response(
        response,
        Rev(
          jsonDecode(response.body)['revision'],
        ),
      );
    }

    return ResponseData.response(response);
  }

  Future<ResponseData<Rev>> editTask(Task task, int revision) async {
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
        "element": task.toJson(),
      }),
    );
    activeRequests--;
    if (response.isSuccesful) {
      return ResponseData.response(
        response,
        Rev(
          jsonDecode(response.body)['revision'],
        ),
      );
    }

    return ResponseData.response(response);
  }

  Future<ResponseData<Rev>> deleteTask(Task task, int revision) async {
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
    if (response.isSuccesful) {
      return ResponseData.response(
        response,
        Rev(
          jsonDecode(response.body)['revision'],
        ),
      );
    }
    return ResponseData.response(response);
  }
}

class Rev<T> {
  final int? revision;
  final T? data;
  Rev([this.revision, this.data]);
}
