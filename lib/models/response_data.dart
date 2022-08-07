import '../repositories/repository.dart';

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
    return 'ResponseData(isSuccesful: $isSuccesful, ${!isSuccesful ? 'message: $message, ' : ''}status: $status, data: $data)';
  }

  ResponseData<T> copyWith({
    bool? isSuccesful,
    String? message,
    int? status,
    T? data,
  }) {
    return ResponseData<T>(
      isSuccesful: isSuccesful ?? this.isSuccesful,
      message: message ?? this.message,
      status: status ?? this.status,
      data: data ?? this.data,
    );
  }
}
