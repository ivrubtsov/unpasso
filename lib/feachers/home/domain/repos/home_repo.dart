import 'package:goal_app/feachers/goals/domain/entities/goal.dart';

abstract class HomeRepo {
  Future<List<Goal>> getPublicGoals();
  Future<List<Goal>> getFriendsGoals(int userId);

  Future<Goal> likeGoal(Goal goal, int userId);
  Future<Goal> unLikeGoal(Goal goal, int userId);
}
