import 'package:equatable/equatable.dart';
import 'package:goal_app/feachers/auth/domain/repos/session_repo.dart';

/// Необходимые для подтверждения данные, напр., код подтверждения.
abstract class ConformationCredentials extends Equatable {
  const ConformationCredentials();
}

/// Необходимые для входа данные, напр., логин / пароль.
abstract class AuthCredentials extends Equatable {
  const AuthCredentials();
}

abstract class AuthRepo {
  AuthRepo(this.sessionRepo);

  SessionRepo sessionRepo;
  Future<void> registerUser(AuthCredentials credentials);

  Future<void> autorizeUser(AuthCredentials credentials);

  void logOut();

  Future<void> confirmRegistration(ConformationCredentials credentials);

  Future<void> deleteUser();
}
