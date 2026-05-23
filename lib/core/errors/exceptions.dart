abstract class AppException implements Exception {
  final String message;

  AppException({required this.message});

  @override
  String toString() => message;
}

class NetworkException extends AppException {
  NetworkException({required super.message});
}

class ServerException extends AppException {
  final int? statusCode;
  final dynamic response;

  ServerException({required super.message, this.statusCode, this.response});
}

class AuthenticationException extends AppException {
  AuthenticationException({required super.message});
}

class ValidationException extends AppException {
  final Map<String, String> errors;

  ValidationException({required super.message, this.errors = const {}});
}

class CacheException extends AppException {
  CacheException({required super.message});
}

class UnknownException extends AppException {
  UnknownException({required super.message});
}

class NotFoundException extends AppException {
  NotFoundException({required super.message});
}

class ConflictException extends AppException {
  ConflictException({required super.message});
}
