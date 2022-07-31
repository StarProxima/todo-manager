// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:todo_manager/data/repositories/repository.dart';

class ResponseData<T> {
  final bool isSuccesful;
  final String? message;
  final int? status;
  final T? data;

  const ResponseData({
    required this.isSuccesful,
    this.message,
    this.status,
    this.data,
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
    return 'ResponseData(isSuccesful: $isSuccesful, message: $message, status: $status, data: $data)';
  }
}
