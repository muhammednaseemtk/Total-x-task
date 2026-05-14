abstract class AppException implements Exception {
  final String message;
  final String? code;
  
  AppException(this.message, {this.code});
  
  @override
  String toString() => message;
}

class AuthException extends AppException {
  AuthException(super.message, {super.code});
}

class UserException extends AppException {
  UserException(super.message, {super.code});
}

class ImageException extends AppException {
  ImageException(super.message, {super.code});
}

class NetworkException extends AppException {
  NetworkException(super.message, {super.code});
}

class ValidationException extends AppException {
  ValidationException(super.message, {super.code});
}