import 'package:goal_app/feachers/goals/domain/entities/goal.dart';
import 'package:goal_app/feachers/goals/domain/repos/goals_repo.dart';

class GoalsRepoImpl implements GoalsRepo {
  @override
  Future<void> createGoal(Goal goal) {
    // TODO: implement createGoal
    throw UnimplementedError();
  }

  @override
  Future<List<Goal>> getGoals(GetGoalsQueryType queryType) {
    // TODO: implement getGoals
    throw UnimplementedError();
  }

  @override
  Future<void> updateGoal(UpdateGoalParams params) {
    // TODO: implement updateGoal
    throw UnimplementedError();
  }
}
