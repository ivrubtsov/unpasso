class ApiConsts {
  ApiConsts._();
  static const _baseUrl = 'https://unpasso.org/wp-json/wp/v2';

  static const authUser = '$_baseUrl/users/me';
  static String registerUser(
    String email,
    String password,
    String name,
  ) =>
      '$_baseUrl/users?username=$name&email=$email&password=$password';

  static String deleteUser(int id) =>
      '$_baseUrl/users/$id?force=True&reassign=111';

  static String getAchievements(int id) => '$_baseUrl/users/$id';

  static String setAchievements(String description, int id) =>
      '$_baseUrl/users/$id?description=$description';

  static String createGoal(String title, int authorId, String date) =>
      '$_baseUrl/posts?status=publish&title=$title&author=$authorId&categories=6&date_gmt=$date';

  static String getUserGoals(int authorId) =>
      '$_baseUrl/posts?per_page=100&status=publish,future&author=$authorId';

  static String completeGoal(int postId) => '$_baseUrl/posts/$postId?tags=8';

  static const policyPrivacy = 'https://unpasso.org/privacy/';

  static const forgotPassword =
      'https://unpasso.org/wp-login.php?action=lostpassword';

  static String getTodaysGoal(int authorId, String date) =>
      '$_baseUrl/posts?author=$authorId&after=$date';
}
