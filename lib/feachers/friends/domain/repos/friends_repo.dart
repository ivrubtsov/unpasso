import 'package:goal_app/feachers/friends/domain/entities/friends.dart';

enum GetFriendsQueryType { userHistory }

/// completeGoal - завершает цель
/// createGoal - получаем цель на сегодня
/// createGoal - создаем цель
/// getFriends - получаем историю целей пользователя
abstract class FriendsRepo {
  Future<Friends> createFriends(Friends friends);

  // Future<Goal?> getTodaysGoal();

  Future<void> removeTodaysFriends();

  Future<List<Friends>> getFriends(GetFriendsQueryType queryType);

  // Future<List<Goal>> getProcessedListFriends();

  Future<void> completeFriends(Friends friends);
}
