import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:goal_app/core/consts/api_consts.dart';
import 'package:goal_app/core/consts/keys.dart';
import 'package:goal_app/core/exceptions/exceptions.dart';
import 'package:goal_app/feachers/auth/domain/repos/session_repo.dart';
import 'package:goal_app/feachers/home/data/models/home_model/home_model.dart';
import 'package:goal_app/feachers/home/domain/entities/home.dart';
import 'package:goal_app/feachers/home/domain/repos/home_repo.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomeRepoImpl implements HomeRepo {
  HomeRepoImpl({
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
  Future<Goal> createGoal(Goal goal) async {
    try {
      final url = ApiConsts.createGoal(
        goal.text,
        goal.authorId,
        goal.createdAt.toUtc().toIso8601String(),
      );
      final response = await _dio().post(url);
      final createdGoal = GoalModel.fromJson(response.data);
      // await _saveGoalToLocal(createdGoal);
      return createdGoal;
    } on DioError {
      throw ServerException();
    }
  }

  @override
  Future<List<Goal>> getGoals(GetGoalsQueryType queryType) async {
    if (_sessionRepo.sessionData == null) throw ServerException();
    try {
      final response = await _dio().get<List<dynamic>>(ApiConsts.getUserGoals(
        _sessionRepo.sessionData!.id,
      ));

      if (response.data == null) throw ServerException();
      final goals = response.data!.map((e) => GoalModel.fromJson(e)).toList();

      return goals;
    } on DioError {
      throw ServerException();
    }
  }

/*
  @override
  Future<List<Goal>> getProcessedListGoals() async {
    try {
      final goals = await getGoals(GetGoalsQueryType.userHistory);
      goals.sort((a, b) => b.createdAt.compareTo(a.createdAt));

      final DateTime today = DateTime.now();
      if (goals.isEmpty ||
          !(goals[0].createdAt.year == today.year &&
              goals[0].createdAt.month == today.month &&
              goals[0].createdAt.day == today.day)) {
        goals.insert(
            0,
            GoalModel(
              createdAt: today,
              text: '%%!!-!!%%',
              authorId: 0,
              isCompleted: false,
              isExist: false,
            ));
      }
      return goals;
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
*/

  @override
  Future<void> completeGoal(Goal goal) async {
    try {
      final id = goal.id;
      if (id == null) throw ServerException();
      final String url = ApiConsts.completeGoal(id);
      final response = await _dio().post(url);
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
