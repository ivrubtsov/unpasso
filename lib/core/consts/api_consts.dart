import 'package:goal_app/core/consts/api_key.dart';

class ApiConsts {
  ApiConsts._();
  static const _baseUrl = ApiKey.baseUrl;

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

  static String updateUser(
          int id, String name, String userName, String description) =>
      '$_baseUrl/users/$id?name=$name&username=$userName&description=$description';

  static String getFriends() => '$_baseUrl/friends';

  static String getFriendsRequestsReceived() =>
      '$_baseUrl/friends/requests/received';

  static String getFriendsRequestsSent() => '$_baseUrl/friends/requests/sent';

  static String searchFriends(String text) =>
      '$_baseUrl/friends/search?text=$text';

  static String processFriendsRequest(int id, String action) =>
      '$_baseUrl/friends/requests/$id?action=$action';

/*  static String createGoal(String title, int authorId, String date) =>
      '$_baseUrl/posts?status=publish&title=$title&author=$authorId&categories=6&date_gmt=$date';*/
  static String createGoal() => '$_baseUrl/posts';

  static int fetchPageLimit = 100;

  static String getUserGoals(int authorId, int page) =>
      '$_baseUrl/posts?per_page=$fetchPageLimit&page=$page&status=publish,future&categories=6&author=$authorId';

  static String getAvailableGoals(int page) =>
      '$_baseUrl/posts?per_page=$fetchPageLimit&page=$page&status=publish,future&categories=6';

  static String getGoalById(int id) => '$_baseUrl/posts/$id';

  static String completeGoal(int postId) => '$_baseUrl/posts/$postId?tags=8';

  static String updateGoal(int id) => '$_baseUrl/posts/$id';

  static const policyPrivacy = 'https://unpasso.org/privacy/';

  static const forgotPassword =
      'https://unpasso.org/wp-login.php?action=lostpassword';
}
