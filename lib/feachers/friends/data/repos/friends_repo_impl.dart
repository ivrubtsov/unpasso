import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:goal_app/core/consts/api_consts.dart';
import 'package:goal_app/core/exceptions/exceptions.dart';
import 'package:goal_app/feachers/auth/domain/repos/session_repo.dart';
import 'package:goal_app/feachers/friends/domain/repos/friends_repo.dart';
import 'package:goal_app/feachers/profile/domain/entities/profile.dart';

class FriendsRepoImpl implements FriendsRepo {
  FriendsRepoImpl({
    required SessionRepo sessionRepo,
  }) : _sessionRepo = sessionRepo;
  final SessionRepo _sessionRepo;
  Dio _dio() {
    final username = _sessionRepo.sessionData?.username;
    final password = _sessionRepo.sessionData?.password;
    if (password == null && username == null) return Dio();
    return Dio(BaseOptions(
      headers: {
        'authorization':
            'Basic ${base64.encode(utf8.encode('$username:$password'))}',
      },
    ));
  }

  @override
  Future<void> getFriends() async {
    try {
      final response = await _dio().get<List<dynamic>>(ApiConsts.getFriends());

      if (response.data == null) throw ServerException();
      //final goals = response.data!.map((e) => GoalModel.fromJson(e)).toList();

      return;
    } on DioError {
      throw ServerException();
    }
  }

  @override
  Future<void> acceptRequest(Profile profile) async {
    return;
  }

  @override
  Future<void> rejectRequest(Profile profile) async {
    return;
  }

  @override
  Future<void> removeFriend(Profile profile) async {
    return;
  }

  @override
  Future<List<Profile>> searchFriends() async {
    return [];
  }
}
