abstract class DetailedException implements Exception {
  DetailedException({this.message});
  final String? message;
}

class AuthException extends DetailedException {
  AuthException(String? message) : super(message: message);
}

class ServerException extends DetailedException {}

class CacheException extends DetailedException {}

class SessionDataException extends DetailedException {}
