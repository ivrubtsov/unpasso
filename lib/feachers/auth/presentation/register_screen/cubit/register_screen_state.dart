part of 'register_screen_cubit.dart';

enum RegisterScreenStateStatus { loaded, loading }

class RegisterScreenState extends Equatable {
  final String name;
  final String email;
  final String password;
  final bool isTermsAccepted;
  final RegisterScreenStateStatus status;

  bool get isFieldsFilled =>
      name.isNotEmpty && email.isNotEmpty && password.isNotEmpty;
  const RegisterScreenState({
    required this.isTermsAccepted,
    required this.name,
    required this.email,
    required this.password,
    required this.status,
  });

  factory RegisterScreenState.initial() => const RegisterScreenState(
      name: '',
      email: '',
      password: '',
      status: RegisterScreenStateStatus.loaded,
      isTermsAccepted: false);

  @override
  List<Object> get props => [
        name,
        email,
        password,
        status,
        isTermsAccepted,
      ];

  RegisterScreenState copyWith({
    String? name,
    String? email,
    String? password,
    bool? isTermsAccepted,
    RegisterScreenStateStatus? status,
  }) {
    return RegisterScreenState(
      name: name ?? this.name,
      email: email ?? this.email,
      password: password ?? this.password,
      isTermsAccepted: isTermsAccepted ?? this.isTermsAccepted,
      status: status ?? this.status,
    );
  }
}
