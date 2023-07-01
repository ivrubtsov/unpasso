import 'package:goal_app/feachers/profile/domain/entities/profile.dart';

enum GetProfileQueryType { userHistory }

abstract class ProfileRepo {
  Future<Profile?> getAchievements();

  Future<void> setAchievements(List<int> achievements);
}
