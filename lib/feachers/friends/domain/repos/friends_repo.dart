import 'package:goal_app/feachers/friends/domain/entities/friend.dart';

enum GetFriendsQueryType { userHistory }

abstract class FriendsRepo {
  Future<Friend> createFriend(Friend friend);

  // Future<Goal?> getTodaysGoal();

  Future<void> removeTodaysFriends();

  Future<List<Friend>> getFriends(GetFriendsQueryType queryType);

  // Future<List<Goal>> getProcessedListFriends();

  Future<void> completeFriend(Friend friend);
}
