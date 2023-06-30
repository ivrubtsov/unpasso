import 'package:goal_app/feachers/goals/domain/entities/goal.dart';

enum GetProfileQueryType { userHistory }

/// completeGoal - завершает цель
/// createGoal - получаем цель на сегодня
/// createGoal - создаем цель
/// getGoals - получаем историю целей пользователя
abstract class ProfileRepo {
  Future<Goal> createGoal(Goal goal);

  Future<Goal?> getTodaysGoal();

  Future<void> removeTodaysGoal();

  Future<List<Goal>> getGoals(GetProfileQueryType queryType);

  Future<void> completeGoal(Goal goal);
}
