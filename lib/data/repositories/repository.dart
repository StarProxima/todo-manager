import 'dart:convert';
import 'package:http/http.dart' as http;

abstract class Repository {
  static const int _countSecTimeOut = 10;
  static const String _timeOutMessage = "Ошибка подключения к серверу";

  const Repository();

  Future<ResponseData> postRequest({
    required String url,
    required String parametrs,
    required Map<String, String> headers,
  }) async {
    http.Response response = await http
        .post(
          Uri.parse(url),
          headers: headers,
          body: parametrs,
        )
        .timeout(const Duration(seconds: _countSecTimeOut));

    return ResponseData(
      data: utf8.decode(response.bodyBytes),
      status: response.statusCode,
    );
  }

  Future<ResponseData> getRequest(
    String url, {
    Map<String, String>? headers,
  }) async {
    try {
      http.Response response = await http
          .get(
            Uri.parse(url),
            headers: headers,
          )
          .timeout(const Duration(seconds: _countSecTimeOut));

      return ResponseData(
        data: utf8.decode(response.bodyBytes),
        status: response.statusCode,
      );
    } catch (e) {
      return const ResponseData(data: _timeOutMessage);
    }
  }

  Future<ResponseData> putRequest({
    required String url,
    required String parametrs,
    required Map<String, String> headers,
  }) async {
    try {
      http.Response response = await http
          .put(
            Uri.parse(url),
            headers: headers,
            body: parametrs,
          )
          .timeout(const Duration(seconds: _countSecTimeOut));

      return ResponseData(
        data: utf8.decode(response.bodyBytes),
        status: response.statusCode,
      );
    } catch (e) {
      return const ResponseData(data: _timeOutMessage);
    }
  }

  Future<ResponseData> deleteRequest({
    required String url,
    required Map<String, String> headers,
  }) async {
    try {
      http.Response response = await http
          .delete(
            Uri.parse(url),
            headers: headers,
          )
          .timeout(const Duration(seconds: _countSecTimeOut));

      return ResponseData(
        data: utf8.decode(response.bodyBytes),
        status: response.statusCode,
      );
    } catch (e) {
      return const ResponseData(data: _timeOutMessage);
    }
  }
}

class ResponseData {
  final String data;
  final int status;
  final bool isSuccesful;

  const ResponseData({
    required this.data,
    this.status = 500,
    this.isSuccesful = false,
  });
}
