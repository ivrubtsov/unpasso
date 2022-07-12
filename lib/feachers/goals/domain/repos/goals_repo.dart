import 'package:goal_app/feachers/goals/domain/entities/goal.dart';

enum GetGoalsQueryType { userHistory }

abstract class UpdateGoalParams {}

abstract class GoalsRepo {
  Future<void> createGoal(Goal goal);

  Future<Goal?> getTodaysGoal();

  Future<List<Goal>> getGoals(GetGoalsQueryType queryType);
}
