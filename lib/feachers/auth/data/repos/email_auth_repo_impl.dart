import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:goal_app/core/consts/api_consts.dart';
import 'package:goal_app/core/entities/user/user.dart';
import 'package:goal_app/core/exceptions/exceptions.dart';
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

class RegisterCreds extends AuthCredentials {
  final String email;
  final String password;
  final User user;
  const RegisterCreds({
    required this.email,
    required this.password,
    required this.user,
  });
  @override
  List<Object?> get props => [email, password, user];
}

class EmailAuthRepoImpl implements AuthRepo {
  EmailAuthRepoImpl(this.sessionRepo);
  @override
  SessionRepo sessionRepo;

  @override
  Future<void> autorizeUser(AuthCredentials credentials) async {
    try {
      String basicAuth =
          'Basic ${base64.encode(utf8.encode('user2:UOEPqllWEHAy4coyEYp*wYcB'))}';

      final response = await Dio(BaseOptions(
        headers: {'authorization': basicAuth},
      )).get(ApiConsts.authUser);
    } on DioError {
      throw AuthException.type(AuthExceptionType.unknown);
    }
  }

  @override
  Future<void> registerUser(AuthCredentials credentials) {
    // TODO: implement registerUser
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
}
