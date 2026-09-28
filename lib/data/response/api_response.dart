import 'response_status.dart';

class ApiResponse<T> {
  const ApiResponse.loading()
    : status = ResponseStatus.loading,
      data = null,
      message = null;

  const ApiResponse.completed(T result)
    : status = ResponseStatus.completed,
      data = result,
      message = null;

  const ApiResponse.error(String errorMessage)
    : status = ResponseStatus.error,
      data = null,
      message = errorMessage;

  final ResponseStatus status;
  final T? data;
  final String? message;

  @override
  String toString() =>
      'ApiResponse(status: $status, data: $data, message: $message)';
}
