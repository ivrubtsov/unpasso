class ApiConsts {
  ApiConsts._();
  static const _baseUrl = 'https://unpasso.org/wp-json/wp/v2';

  static const authUser = '$_baseUrl/users/me';
  static String registerUser(
    String email,
    String password,
    String username,
    String name,
    String description,
  ) =>
      '$_baseUrl/users?username=$username&name=$name&email=$email&password=$password&description=$description';

  static String deleteUser(int id) =>
      '$_baseUrl/users/$id?force=True&reassign=111';

  static String getUser(int id) => '$_baseUrl/users/$id';

  static String updateUser(int id, String description) =>
      '$_baseUrl/users/$id?description=$description';

  static String getFriends(int id) => '$_baseUrl/users/$id';

  static String setFriends(int id, String description) =>
      '$_baseUrl/users/$id?description=$description';

  static String inviteFriends(int id, String description) =>
      '$_baseUrl/users/$id?description=$description';

/*  static String createGoal(String title, int authorId, String date) =>
      '$_baseUrl/posts?status=publish&title=$title&author=$authorId&categories=6&date_gmt=$date';*/
  static String createGoal() => '$_baseUrl/posts';

  static String getUserGoals(int authorId) =>
      '$_baseUrl/posts?per_page=100&status=publish,future&author=$authorId';

  static String completeGoal(int postId) => '$_baseUrl/posts/$postId?tags=8';

  static String likeGoal(int postId, String content) =>
      '$_baseUrl/posts/$postId?content=$content';

  static const policyPrivacy = 'https://unpasso.org/privacy/';

  static const forgotPassword =
      'https://unpasso.org/wp-login.php?action=lostpassword';

  static String getTodaysGoal(int authorId, String date) =>
      '$_baseUrl/posts?author=$authorId&after=$date';
}
