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

  static String createGoal(String title, int authorId, String date) =>
      '$_baseUrl/posts?status=publish&title=$title&author=$authorId&categories=6&date=$date';

  static String getUserGoals(int authorId) =>
      '$_baseUrl/posts?author=$authorId';

  static String completeGoal(int postId) => '$_baseUrl/posts/$postId?tags=8';
}
