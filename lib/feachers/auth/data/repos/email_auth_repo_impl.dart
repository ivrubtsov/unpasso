import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:goal_app/core/consts/api_consts.dart';
import 'package:goal_app/core/consts/api_key.dart';
import 'package:goal_app/core/consts/app_avatars.dart';
import 'package:goal_app/core/entities/user/user.dart';
import 'package:goal_app/feachers/auth/domain/entities/session_data.dart';
import 'package:goal_app/feachers/auth/domain/repos/auth_repo.dart';
import 'package:goal_app/feachers/auth/domain/repos/session_repo.dart';

import '../../../../core/exceptions/auth_exception.dart';

class EmailAuthCreds extends AuthCredentials {
  final String username;
  final String password;

  const EmailAuthCreds({
    required this.username,
    required this.password,
  });
  @override
  List<Object?> get props => [username, password];
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

  static Dio _dio({String? username, String? password}) {
    final n = username ?? ApiKey.key1;
    final p = password ?? ApiKey.key2;

    final basicAuth = 'Basic ${base64.encode(utf8.encode('$n:$p'))}';
    return Dio(BaseOptions(
      headers: {
        'authorization': basicAuth,
      },
    ));
  }

  @override
  Future<void> autorizeUser(AuthCredentials credentials) async {
    try {
      credentials as EmailAuthCreds;

      final response = await _dio(
        username: credentials.username,
        password: credentials.password,
      ).get(
        ApiConsts.authUser,
      );
      if (response.data == null) {
        throw AuthException.type(AuthExceptionType.unknown);
      }
      final id = response.data['id'];
      final username = response.data['username'];
      await sessionRepo.saveSessionData(SessionData(
        id: id,
        password: credentials.password,
        username: username,
      ));
    } on DioError catch (e) {
      throw AuthException(
          e.response?.data['error_description'], AuthExceptionType.unknown);
      // throw AuthException.fromServerMessage(
      //     e.response?.data['error_description']);
    }
  }

  @override
  Future<void> registerUser(AuthCredentials credentials) async {
    try {
      credentials as RegisterCreds;
      final int avatar = AppAvatars.chooseAvatar();
      final description = {
        'avatar': avatar,
        'achievements': [],
        'friends': [],
        'friendsRequests': [],
      };
      final url = ApiConsts.registerUserJSON();
      final data = {
        'username': credentials.user.username,
        'name': credentials.user.name,
        'email': credentials.email,
        'password': credentials.password,
        'description': description,
      };
      final response = await _dio().post(
        url,
        data: jsonEncode(data),
      );
      if (response.data == null) {
        throw AuthException.type(AuthExceptionType.unknown);
      }

      final id = response.data['id'];
      // final username = response.data['username'];
      await sessionRepo.saveSessionData(SessionData(
        id: id,
        password: credentials.password,
        // username: username,
        username: credentials.user.username,
      ));
    } on DioError catch (e) {
      throw AuthException.fromServerMessage(e.response?.data['message']);
    }
  }

  @override
  Future<void> confirmRegistration(ConformationCredentials credentials) {
    // TODO: implement confirmRegistration
    throw UnimplementedError();
  }

  @override
  void logOut() {
    sessionRepo.removeSessionData();
  }

  @override
  Future<void> deleteUser() async {
    try {
      final url = ApiConsts.deleteUser(sessionRepo.sessionData!.id);
      await _dio(
        username: ApiKey.key1,
        password: ApiKey.key2,
      ).delete(url);
    } on DioError {
      throw AuthException.type(AuthExceptionType.unknown);
    }
  }
}
