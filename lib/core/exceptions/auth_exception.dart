import 'exceptions.dart';

enum AuthExceptionType {
  wrongPassword,
  wrondEmail,
  unknown,
  emailExists,
  usernameExists,
  invalidEmail,
  userNotExist,
  incorrectPassword
}

class AuthException extends DetailedException {
  final AuthExceptionType? type;

  AuthException(String? message, this.type) : super(message: message);

  factory AuthException.fromServerMessage(String? message) {
    switch (message) {
      case 'User does not exist.':
        return AuthException.type(AuthExceptionType.userNotExist);
      case 'Incorrect password.':
        return AuthException.type(AuthExceptionType.incorrectPassword);
      case 'Sorry, this username is already taken!':
        return AuthException.type(AuthExceptionType.usernameExists);
      case 'Sorry, this email address is already used!':
        return AuthException.type(AuthExceptionType.emailExists);
      case 'Invalid parameter(s): email':
        return AuthException.type(AuthExceptionType.invalidEmail);

      default:
        return AuthException.type(AuthExceptionType.unknown);
    }
  }

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
        typeMessage = 'Unknown error. Please, try again later';
        break;
      case AuthExceptionType.emailExists:
        typeMessage = 'Sorry, this email address is already used!';
        break;
      case AuthExceptionType.usernameExists:
        typeMessage = 'Sorry, this username already exists!';
        break;
      case AuthExceptionType.invalidEmail:
        typeMessage = 'Invalid email';
        break;
      case AuthExceptionType.userNotExist:
        typeMessage = 'User doesn\'t exsist';
        break;
      case AuthExceptionType.incorrectPassword:
        typeMessage = 'Password is incorrect';
        break;
    }
    return AuthException(typeMessage, type);
  }
}
