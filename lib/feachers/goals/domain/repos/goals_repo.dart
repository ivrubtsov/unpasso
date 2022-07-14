import 'package:goal_app/feachers/goals/domain/entities/goal.dart';

enum GetGoalsQueryType { userHistory }

/// completeGoal - завершает цель
/// createGoal - получаем цель на сегодня
/// createGoal - создаем цель
/// getGoals - получаем историю целей пользователя
abstract class GoalsRepo {
  Future<Goal> createGoal(Goal goal);

  Future<Goal?> getTodaysGoal();

  Future<List<Goal>> getGoals(GetGoalsQueryType queryType);

  Future<void> completeGoal(Goal goal);
}
