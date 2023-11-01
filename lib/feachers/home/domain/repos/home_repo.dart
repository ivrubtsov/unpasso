import 'package:goal_app/feachers/goals/domain/entities/goal.dart';

abstract class HomeRepo {
  Future<List<Goal>> getGoals(int userId, int page);

  Future<Goal> likeGoal(Goal goal, int userId);
  Future<Goal> unLikeGoal(Goal goal, int userId);
}
