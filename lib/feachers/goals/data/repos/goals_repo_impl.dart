import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:goal_app/core/consts/api_consts.dart';
import 'package:goal_app/core/consts/keys.dart';
import 'package:goal_app/core/exceptions/exceptions.dart';
import 'package:goal_app/feachers/auth/domain/repos/session_repo.dart';
import 'package:goal_app/feachers/goals/data/models/goal_model/goal_model.dart';
import 'package:goal_app/feachers/goals/domain/entities/goal.dart';
import 'package:goal_app/feachers/goals/domain/repos/goals_repo.dart';
import 'package:shared_preferences/shared_preferences.dart';

class GoalsRepoImpl implements GoalsRepo {
  GoalsRepoImpl({required SessionRepo sessionRepo})
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

  @override
  Future<Goal?> getTodaysGoal() async {
    final shP = await SharedPreferences.getInstance();
    final jsonStr = shP.getString(Keys.todaysGoal);
    if (jsonStr == null) return null;

    final goal = GoalModel.fromJson(jsonDecode(jsonStr));

    final now = DateTime.now();
    final currentYear = now.year;
    final currentDay = now.day;
    final currentMonth = now.month;

    final goalDate = goal.createdAt;
    final goalYear = goalDate.year;
    final goalMonth = goalDate.month;
    final goalDay = goalDate.day;

    // если дата цели не равна сегодняшней дате, тогда удаляем
    // сравниваем
    // - год
    // - месяц
    // - день
    // если ничего не равно, тогда удаляем цель
    if (currentDay != goalDay ||
        currentMonth != goalMonth ||
        currentYear != goalYear) {
      await removeTodaysGoal();
      return null;
    }

    return goal;
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
      final response = await _dio().post(ApiConsts.completeGoal(id));
      final updatedGoal = GoalModel.fromJson(response.data);
      await _saveGoalToLocal(updatedGoal);
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
