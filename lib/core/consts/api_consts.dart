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
}
