import 'package:goal_app/feachers/profile/domain/entities/profile.dart';

abstract class FriendsRepo {
  Future<void> getFriends();

  Future<void> acceptRequest(Profile profile);

  Future<void> rejectRequest(Profile profile);

  Future<void> removeFriend(Profile profile);

  Future<List<Profile>> searchFriends();
}
