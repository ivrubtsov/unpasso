part of 'auth_screen_cubit.dart';

enum AuthScreenStateStatus { loading, loaded, error }

class AuthScreenState extends Equatable {
  final String email;
  final String password;
  final AuthScreenStateStatus status;

  bool get isFieldsFilled => email.isNotEmpty && password.isNotEmpty;

  const AuthScreenState({
    required this.email,
    required this.password,
    required this.status,
  });

  AuthScreenState copyWith({
    String? email,
    String? password,
    AuthScreenStateStatus? status,
  }) {
    return AuthScreenState(
      email: email ?? this.email,
      password: password ?? this.password,
      status: status ?? this.status,
    );
  }

  factory AuthScreenState.initial() => const AuthScreenState(
        email: '',
        password: '',
        status: AuthScreenStateStatus.loaded,
      );

  @override
  List<Object> get props => [
        email,
        password,
        status,
      ];
}
