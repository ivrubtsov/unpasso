import 'package:goal_app/feachers/goals/domain/entities/goal.dart';

enum GetGoalsQueryType { userHistory }

/// completeGoal - завершает цель
/// createGoal - получаем цель на сегодня
/// createGoal - создаем цель
/// getGoals - получаем историю целей пользователя
abstract class GoalsRepo {
  Future<Goal> createGoal(Goal goal);

  // Future<Goal?> getTodaysGoal();

  Future<void> removeTodaysGoal();

  Future<List<Goal>> getCurrentUserGoals(GetGoalsQueryType queryType);

  // Future<List<Goal>> getProcessedListGoals();

  Future<void> completeGoal(Goal goal);
}
