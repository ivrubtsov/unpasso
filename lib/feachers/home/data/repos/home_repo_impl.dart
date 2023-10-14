import 'dart:convert';
import 'package:collection/collection.dart';

import 'package:dio/dio.dart';
import 'package:goal_app/core/consts/api_consts.dart';
//import 'package:goal_app/core/consts/api_key.dart';
import 'package:goal_app/core/exceptions/exceptions.dart';
import 'package:goal_app/feachers/auth/domain/repos/session_repo.dart';
import 'package:goal_app/feachers/goals/data/models/goal_model/goal_model.dart';
import 'package:goal_app/feachers/goals/domain/entities/goal.dart';
import 'package:goal_app/feachers/home/domain/repos/home_repo.dart';

class HomeRepoImpl implements HomeRepo {
  HomeRepoImpl({
    required SessionRepo sessionRepo,
  }) : _sessionRepo = sessionRepo;
  final SessionRepo _sessionRepo;

/*
  static Dio _dioA(String key3) {
    if (key3 != ApiKey.key3) {
      throw ServerException();
    }
    const n = ApiKey.key1;
    const q = ApiKey.key2;

    final basicAuth = 'Basic ${base64.encode(utf8.encode('$n:$q'))}';
    return Dio(BaseOptions(
      headers: {
        'authorization': basicAuth,
      },
    ));
  }
*/
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
  Future<List<Goal>> getGoals(int userId, int page) async {
    try {
      // getting goals for friends
      final response =
          await _dio().get<List<dynamic>>(ApiConsts.getAvailableGoals(page));

      if (response.data == null) throw ServerException();

      // filtering friends-only goals
      /*
      final goals = response.data!
          .map((e) {
            final goal = GoalModel.fromJson(e);
            if (goal.friendsUsers.contains(userId)) {
              return goal;
            } else {
              return null;
            }
          })
          .whereNotNull()
          .toList();
      */
      final goals = response.data!
          .map((e) {
            return GoalModel.fromJson(e);
          })
          .whereNotNull()
          .toList();

      return goals;
    } on DioError {
      throw ServerException();
    }
  }

  @override
  Future<Goal> likeGoal(Goal goal, int userId) async {
    try {
      if (goal.id != null && goal.id != 0) {
        /*
        String url = ApiConsts.getGoalById(goal.id ?? 0);
        var response = await _dioA(ApiKey.key3).get(url);
        if (response.data == null || response.data!.isEmpty) {
          throw ServerException();
        }
        Goal loadedGoal = GoalModel.fromJson(response.data);
        List<int> likeUsers = loadedGoal.likeUsers;
        if (!likeUsers.contains(userId)) likeUsers.add(userId);
        Goal newGoal = loadedGoal.copyWith(
          likeUsers: likeUsers,
          likes: likeUsers.length + 1,
        );
        url = ApiConsts.updateGoal(goal.id ?? 0);
        response = await _dioA(ApiKey.key3).post(
          url,
          data: jsonEncode(GoalModel.fromGoal(newGoal).toJson()),
        );
        if (response.data == null || response.data!.isEmpty) {
          throw ServerException();
        }
        */
        final url = ApiConsts.likeGoal(goal.id ?? 0);
        final response = await _dio().post(url);
        if (response.data == null || response.data!.isEmpty) {
          throw ServerException();
        }
        final newGoal = GoalModel.fromJson(response.data);
        return newGoal;
      } else {
        return goal;
      }
    } on DioError {
      throw ServerException();
    }
  }

  @override
  Future<Goal> unLikeGoal(Goal goal, int userId) async {
    try {
      if (goal.id != null && goal.id != 0) {
        /*
        String url = ApiConsts.getGoalById(goal.id ?? 0);
        var response = await _dioA(ApiKey.key3).get(url);
        if (response.data == null || response.data!.isEmpty) {
          throw ServerException();
        }
        Goal loadedGoal = GoalModel.fromJson(response.data);
        List<int> likeUsers = loadedGoal.likeUsers;
        if (likeUsers.contains(userId)) likeUsers.remove(userId);
        Goal newGoal = loadedGoal.copyWith(
          likeUsers: likeUsers,
          likes: likeUsers.length + 1,
        );
        url = ApiConsts.updateGoal(goal.id ?? 0);
        response = await _dioA(ApiKey.key3).post(
          url,
          data: jsonEncode(GoalModel.fromGoal(newGoal).toJson()),
        );
        if (response.data == null || response.data!.isEmpty) {
          throw ServerException();
        }
        */
        final url = ApiConsts.unLikeGoal(goal.id ?? 0);
        final response = await _dio().post(url);
        if (response.data == null || response.data!.isEmpty) {
          throw ServerException();
        }
        final newGoal = GoalModel.fromJson(response.data);
        return newGoal;
      } else {
        return goal;
      }
    } on DioError {
      throw ServerException();
    }
  }
}
