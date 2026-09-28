/// A failure that can be shown to the user or handled by the API layer.
class AppException implements Exception {
  const AppException(this.message, {this.statusCode});

  final String message;
  final int? statusCode;

  @override
  String toString() => message;
}

class NoInternetException extends AppException {
  const NoInternetException([super.message = 'No internet connection.']);
}

class RequestTimeoutException extends AppException {
  const RequestTimeoutException([
    super.message = 'The request timed out. Please try again.',
  ]);
}

class BadRequestException extends AppException {
  const BadRequestException([super.message = 'The request is invalid.'])
    : super(statusCode: 400);
}

class UnauthorizedException extends AppException {
  const UnauthorizedException([
    super.message = 'The API key is invalid or missing.',
  ]) : super(statusCode: 401);
}

class NotFoundException extends AppException {
  const NotFoundException([super.message = 'Location not found.'])
    : super(statusCode: 404);
}

class RateLimitException extends AppException {
  const RateLimitException([
    super.message = 'Too many requests. Please try again later.',
  ]) : super(statusCode: 429);
}

class ServerException extends AppException {
  const ServerException([
    super.message = 'The weather service is unavailable.',
  ]);
}
