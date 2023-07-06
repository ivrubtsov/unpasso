abstract class ProfileRepo {
  Future<List<int>> getAchievements();

  Future<void> setAchievements(List<int> achievements);
}
