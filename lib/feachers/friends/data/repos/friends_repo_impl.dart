import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:goal_app/core/consts/api_consts.dart';
import 'package:goal_app/core/exceptions/exceptions.dart';
import 'package:goal_app/feachers/auth/domain/repos/session_repo.dart';
import 'package:goal_app/feachers/friends/domain/repos/friends_repo.dart';
import 'package:goal_app/feachers/profile/data/models/profile_model/profile_model.dart';
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
  Future<List<Profile>> getFriends() async {
    try {
      final response = await _dio().get<List<dynamic>>(ApiConsts.getFriends());

      if (response.data == null) throw ServerException();
      //final goals = response.data!.map((e) => GoalModel.fromJson(e)).toList();

      final users = response.data!.map((e) {
        return ProfileModel.fromJson(e);
      }).toList();

      return users;
    } on DioError {
      throw ServerException();
    }
  }

  @override
  Future<List<Profile>> getFriendsRequestsReceived() async {
    try {
      final response = await _dio()
          .get<List<dynamic>>(ApiConsts.getFriendsRequestsReceived());

      if (response.data == null) throw ServerException();
      //final goals = response.data!.map((e) => GoalModel.fromJson(e)).toList();

      final users = response.data!.map((e) {
        return ProfileModel.fromJson(e);
      }).toList();

      return users;
    } on DioError {
      throw ServerException();
    }
  }

  @override
  Future<List<Profile>> getFriendsRequestsSent() async {
    try {
      final response =
          await _dio().get<List<dynamic>>(ApiConsts.getFriendsRequestsSent());

      if (response.data == null) throw ServerException();
      //final goals = response.data!.map((e) => GoalModel.fromJson(e)).toList();

      final users = response.data!.map((e) {
        return ProfileModel.fromJson(e);
      }).toList();

      return users;
    } on DioError {
      throw ServerException();
    }
  }

  @override
  Future<void> processRequest(Profile profile, String action) async {
    try {
      final data = {
        'action': action,
      };
      final response = await _dio().post<List<dynamic>>(
        ApiConsts.processFriendsRequestJSON(profile.id),
        data: jsonEncode(data),
      );

      if (response.data == null) throw ServerException();
      return;
    } on DioError {
      throw ServerException();
    }
  }

  @override
  Future<List<Profile>> searchFriends(String text) async {
    try {
      final response =
          await _dio().get<List<dynamic>>(ApiConsts.searchFriends(text));

      if (response.data == null) throw ServerException();
      //final goals = response.data!.map((e) => GoalModel.fromJson(e)).toList();

      final users = response.data!.map((e) {
        return ProfileModel.fromJson(e);
      }).toList();

      return users;
    } on DioError {
      throw ServerException();
    }
  }
}
