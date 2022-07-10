part of 'auth_cubit.dart';

enum AuthStatus { logIn, logOut, loading }

class AuthState extends Equatable {
  final AuthStatus status;
  const AuthState({
    required this.status,
  });

  factory AuthState.initial() => const AuthState(status: AuthStatus.logOut);

  AuthState copyWith({
    AuthStatus? status,
  }) {
    return AuthState(
      status: status ?? this.status,
    );
  }

  @override
  List<Object> get props => [status];
}
