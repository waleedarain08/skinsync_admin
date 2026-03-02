abstract class AppException implements Exception {
  final String message;

  const AppException(this.message);

  @override
  String toString() => message;
}

class NoInternetException extends AppException {
  const NoInternetException() : super('No internet connection');
}

class BadRequestException extends AppException {
  const BadRequestException(super.message);
}

class UnauthorizedException extends AppException {
  const UnauthorizedException(super.message);
}

class NotFoundException extends AppException {
  const NotFoundException(super.message);
}

class ServerException extends AppException {
  const ServerException([super.message = 'Server error']);
}

class UnknownException extends AppException {
  const UnknownException([super.message = 'Something went wrong']);
}

class PermissionExecption extends AppException {
  const PermissionExecption(super.message);
}
