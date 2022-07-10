abstract class DetailedException implements Exception {
  DetailedException({this.message});
  final String? message;
}

enum AuthExceptionType { wrongPassword, wrondEmail, unknown }

class AuthException extends DetailedException {
  final AuthExceptionType? type;

  AuthException(String? message, this.type) : super(message: message);

  factory AuthException.type(AuthExceptionType type) {
    String typeMessage;
    switch (type) {
      case AuthExceptionType.wrongPassword:
        typeMessage = 'Wrong password';
        break;
      case AuthExceptionType.wrondEmail:
        typeMessage = 'Wrong email';
        break;
      case AuthExceptionType.unknown:
        typeMessage = 'Unknown error. Please try again later';
        break;
    }
    return AuthException(typeMessage, type);
  }
}

class ServerException extends DetailedException {}

class CacheException extends DetailedException {}

class SessionDataException extends DetailedException {}
