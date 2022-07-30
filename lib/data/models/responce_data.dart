import 'package:todo_manager/data/repositories/repository.dart';

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
