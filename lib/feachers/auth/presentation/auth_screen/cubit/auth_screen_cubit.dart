import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:goal_app/core/navigation/app_router.dart';
import 'package:goal_app/feachers/auth/domain/repos/auth_repo.dart';
import 'package:goal_app/feachers/auth/domain/repos/session_repo.dart';

part 'auth_screen_state.dart';

class AuthScreenCubit extends Cubit<AuthScreenState> {
  AuthScreenCubit({
    required AuthRepo authRepo,
    required SessionRepo sessionRepo,
  })  : _authRepo = authRepo,
        _sessionRepo = sessionRepo,
        super(AuthScreenInitial());

  final AuthRepo _authRepo;
  final SessionRepo _sessionRepo;

  void onLoginTapped(BuildContext context) {
    Navigator.of(context).pushNamedAndRemoveUntil(
      MainRoutes.setGoalScreen,
      (_) => false,
    );
  }

  void onSignUpTapped(BuildContext context) {
    Navigator.of(context).pushNamed(
      AuthRoutes.registerScreen,
    );
  }

  void onForgotPasswordTapped(BuildContext context) {
    // FIXME: Сделать переход
    // Navigator.of(context).pushNamed(
    //   AuthRoutes.registerScreen,
    // );
  }
}
