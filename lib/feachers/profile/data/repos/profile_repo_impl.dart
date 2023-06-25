import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:goal_app/core/consts/api_consts.dart';
import 'package:goal_app/core/consts/keys.dart';
import 'package:goal_app/core/exceptions/exceptions.dart';
import 'package:goal_app/feachers/auth/domain/repos/session_repo.dart';
import 'package:goal_app/feachers/profile/data/models/profile_model/profile_model.dart';
import 'package:goal_app/feachers/profile/domain/entities/profile.dart';
import 'package:goal_app/feachers/profile/domain/repos/profile_repo.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfileRepoImpl implements ProfileRepo {
  ProfileRepoImpl({required SessionRepo sessionRepo})
      : _sessionRepo = sessionRepo;
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
  Future<Goal> createGoal(Goal goal) async {
    try {
      final url = ApiConsts.createGoal(
        goal.text,
        goal.authorId,
        goal.createdAt.toIso8601String(),
      );
      final response = await _dio().post(url);
      final createdGoal = GoalModel.fromJson(response.data);
      await _saveGoalToLocal(createdGoal);
      return createdGoal;
    } on DioError {
      throw ServerException();
    }
  }

  @override
  Future<List<Goal>> getProfile(GetProfileQueryType queryType) async {
    if (_sessionRepo.sessionData == null) throw ServerException();
    try {
      final response = await _dio().get<List<dynamic>>(ApiConsts.getUserProfile(
        _sessionRepo.sessionData!.id,
      ));

      if (response.data == null) throw ServerException();
      final profile =
          response.data!.map((e) => ProfileModel.fromJson(e)).toList();

      return profile;
    } on DioError {
      throw ServerException();
    }
  }

  @override
  Future<Goal?> getTodaysGoal() async {
    try {
      if (_sessionRepo.sessionData == null) throw ServerException();

      final now = DateTime.now();
      final today = DateTime(now.year, now.month, now.day);
      final response = await _dio().get<List<dynamic>>(
        ApiConsts.getTodaysGoal(
          _sessionRepo.sessionData!.id,
          today.toIso8601String(),
        ),
      );

      if (response.data == null || response.data!.isEmpty) return null;

      final goal = GoalModel.fromJson(response.data!.first);
      return goal;
    } on DioError {
      return null;
    }
  }

  Future<void> _saveGoalToLocal(GoalModel goalModel) async {
    try {
      final shP = await SharedPreferences.getInstance();
      final json = goalModel.toJson();
      shP.setString(Keys.todaysGoal, jsonEncode(json));
    } catch (e) {
      print(e);
    }
  }

  @override
  Future<void> completeGoal(Goal goal) async {
    try {
      final id = goal.id;
      if (id == null) throw ServerException();
      await _dio().post(ApiConsts.completeGoal(id));
      // final updatedGoal = GoalModel.fromJson(response.data);
      // await _saveGoalToLocal(updatedGoal);
    } on DioError {
      throw ServerException();
    }
  }

  @override
  Future<void> removeTodaysGoal() async {
    final shP = await SharedPreferences.getInstance();
    shP.remove(Keys.todaysGoal);
  }
}