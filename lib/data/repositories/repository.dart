// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:http/http.dart' as http;

abstract class Repository {
  static const int _countSecTimeOut = 10;
  static const String _timeOutMessage = "Ошибка подключения к серверу";

  static Future<Response> post({
    required String url,
    Map<String, String>? headers,
    String? body,
  }) async {
    try {
      http.Response response = await http
          .post(
            Uri.parse(url),
            headers: headers,
            body: body,
          )
          .timeout(const Duration(seconds: _countSecTimeOut));

      return Response.fromHttpResponce(response);
    } catch (e) {
      return Response.timeout();
    }
  }

  static Future<Response> get({
    required String url,
    Map<String, String>? headers,
  }) async {
    try {
      http.Response response = await http
          .get(
            Uri.parse(url),
            headers: headers,
          )
          .timeout(const Duration(seconds: _countSecTimeOut));

      return Response.fromHttpResponce(response);
    } catch (e) {
      return Response.timeout();
    }
  }

  static Future<Response> put({
    required String url,
    String? body,
    Map<String, String>? headers,
  }) async {
    try {
      http.Response response = await http
          .put(
            Uri.parse(url),
            headers: headers,
            body: body,
          )
          .timeout(const Duration(seconds: _countSecTimeOut));

      return Response.fromHttpResponce(response);
    } catch (e) {
      return Response.timeout();
    }
  }

  static Future<Response> patch({
    required String url,
    Map<String, String>? headers,
    String? body,
  }) async {
    try {
      http.Response response = await http
          .patch(
            Uri.parse(url),
            headers: headers,
            body: body,
          )
          .timeout(const Duration(seconds: _countSecTimeOut));

      return Response.fromHttpResponce(response);
    } catch (e) {
      return Response.timeout();
    }
  }

  static Future<Response> delete({
    required String url,
    Map<String, String>? headers,
  }) async {
    try {
      http.Response response = await http
          .delete(
            Uri.parse(url),
            headers: headers,
          )
          .timeout(const Duration(seconds: _countSecTimeOut));

      return Response.fromHttpResponce(response);
    } catch (e) {
      return Response.timeout();
    }
  }
}

class ResponseData<T> {
  final T? data;
  final String message;
  final int status;
  final bool isSuccesful;

  const ResponseData({
    this.data,
    required this.message,
    required this.status,
    required this.isSuccesful,
  });

  factory ResponseData.response(Response response, [T? data]) {
    return ResponseData<T>(
      data: data,
      message: response.body,
      status: response.status,
      isSuccesful: response.isSuccesful,
    );
  }

  @override
  String toString() {
    return 'ResponseData(data: $data, message: $message, status: $status, isSuccesful: $isSuccesful)';
  }
}

class Response {
  final String body;
  final int status;
  final bool isSuccesful;

  const Response({
    required this.body,
    required this.status,
    required this.isSuccesful,
  });

  factory Response.fromHttpResponce(http.Response response) {
    return Response(
      body: utf8.decode(response.bodyBytes),
      status: response.statusCode,
      isSuccesful: response.statusCode >= 200 && response.statusCode < 300,
    );
  }

  factory Response.timeout([String? message]) {
    return Response(
      body: message ?? "Ошибка подключения к серверу",
      status: 504,
      isSuccesful: false,
    );
  }
}
