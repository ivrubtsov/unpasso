import 'package:goal_app/feachers/auth/domain/repos/auth_repo.dart';
import 'package:goal_app/feachers/auth/domain/repos/session_repo.dart';

class EmailAuthCreds extends AuthCredentials {
  final String email;
  final String password;
  const EmailAuthCreds({
    required this.email,
    required this.password,
  });
  @override
  List<Object?> get props => [email, password];
}

class EmailAuthRepoImpl implements AuthRepo {
  EmailAuthRepoImpl(this.sessionRepo);
  @override
  SessionRepo sessionRepo;

  @override
  Future<void> autorizeUser(AuthCredentials credentials) {
    // TODO: implement autorizeUser
    throw UnimplementedError();
  }

  @override
  Future<void> confirmRegistration(ConformationCredentials credentials) {
    // TODO: implement confirmRegistration
    throw UnimplementedError();
  }

  @override
  Future<void> logOut() {
    // TODO: implement logOut
    throw UnimplementedError();
  }

  @override
  Future<void> registerUser(AuthCredentials credentials) {
    // TODO: implement registerUser
    throw UnimplementedError();
  }
}
