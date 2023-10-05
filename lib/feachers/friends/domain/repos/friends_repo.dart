import 'package:goal_app/feachers/profile/domain/entities/profile.dart';

abstract class FriendsRepo {
  Future<List<Profile>> getFriends();

  Future<List<Profile>> getFriendsRequestsReceived();

  Future<List<Profile>> getFriendsRequestsSent();

  Future<void> processRequest(Profile profile, String action);

  Future<List<Profile>> searchFriends(String text);
}
