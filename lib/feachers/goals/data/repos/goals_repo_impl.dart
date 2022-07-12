import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:goal_app/core/consts/api_consts.dart';
import 'package:goal_app/core/exceptions/exceptions.dart';
import 'package:goal_app/feachers/auth/domain/repos/session_repo.dart';
import 'package:goal_app/feachers/goals/domain/entities/goal.dart';
import 'package:goal_app/feachers/goals/domain/repos/goals_repo.dart';

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
  Future<void> createGoal(Goal goal) async {
    try {
      final url = ApiConsts.createGoal(
        goal.text,
        goal.authorId,
        DateTime.now().toIso8601String(),
      );
      await _dio().post(url);

      // TODO:

      // Сделать надпись well done, чтобы полявлялась при отметку цели
      // Цель должна стать неактивная
      // Сделать историю

    } on DioError catch (e) {
      print(e);
      throw ServerException();
    }
  }

  @override
  Future<List<Goal>> getGoals(GetGoalsQueryType queryType) {
    // TODO: implement getGoals
    throw UnimplementedError();
  }

  @override
  Future<Goal?> getTodaysGoal() {
    // TODO: implement getTodaysGoal
    throw UnimplementedError();
  }
}
