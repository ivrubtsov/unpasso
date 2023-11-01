import 'package:goal_app/feachers/profile/domain/entities/profile.dart';

abstract class ProfileRepo {
  Future<Profile> getUserData();
  Future<void> updateUserData(Profile profile);

  Future<List<int>> getAchievements();
  Future<void> setAchievements(List<int> achievements);
}
