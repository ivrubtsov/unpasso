import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:goal_app/core/exceptions/exceptions.dart';
import 'package:goal_app/core/navigation/app_router.dart';
import 'package:goal_app/core/widgets/error_presentor.dart';
import 'package:goal_app/feachers/auth/data/repos/email_auth_repo_impl.dart';
import 'package:goal_app/feachers/auth/domain/repos/auth_repo.dart';
import 'package:goal_app/feachers/auth/domain/repos/session_repo.dart';

part 'auth_screen_state.dart';

class AuthScreenCubit extends Cubit<AuthScreenState> {
  AuthScreenCubit({
    required AuthRepo authRepo,
    required SessionRepo sessionRepo,
  })  : _authRepo = authRepo,
        _sessionRepo = sessionRepo,
        super(AuthScreenState.initial());

  final AuthRepo _authRepo;
  final SessionRepo _sessionRepo;

  Future<void> onLoginTapped(BuildContext context) async {
    try {
      emit(state.copyWith(status: AuthScreenStateStatus.loading));
      if (!state.isFieldsFilled) {
        ErrorPresentor.showError(context, 'Please complete all fields');
        return;
      }
      await _authRepo.autorizeUser(EmailAuthCreds(
        email: state.email,
        password: state.password,
      ));
      Navigator.of(context).pushNamedAndRemoveUntil(
        MainRoutes.setGoalScreen,
        (_) => false,
      );
    } on AuthException catch (e) {
      ErrorPresentor.showError(
          context, e.message ?? 'Unknown error. Please try again later');
    }
  }

  void onSignUpTapped(BuildContext context) {
    Navigator.of(context).pushNamed(
      AuthRoutes.registerScreen,
    );
  }

  void onForgotPasswordTapped(BuildContext context) {
    // FIXME: Сделать переход
    // Navigator.of(context).pushNamed(

    // );
  }

  void changeEmail(String value) {
    if (state.email == value) return;
    emit(state.copyWith(email: value));
  }

  void changePassword(String value) {
    if (state.password == value) return;
    emit(state.copyWith(password: value));
  }
}
