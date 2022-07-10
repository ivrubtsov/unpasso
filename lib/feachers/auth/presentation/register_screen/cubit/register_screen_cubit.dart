import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:goal_app/core/navigation/app_router.dart';

import '../../../domain/repos/auth_repo.dart';
import '../../../domain/repos/session_repo.dart';

part 'register_screen_state.dart';

class RegisterScreenCubit extends Cubit<RegisterScreenState> {
  RegisterScreenCubit({
    required AuthRepo authRepo,
    required SessionRepo sessionRepo,
  })  : _authRepo = authRepo,
        _sessionRepo = sessionRepo,
        super(RegisterScreenState.initial());

  final AuthRepo _authRepo;
  final SessionRepo _sessionRepo;

  void onPolicyPrivacyTapped(BuildContext context) {}

  void onSignUpTapped(BuildContext context) {
    Navigator.of(context).pushNamedAndRemoveUntil(
      MainRoutes.setGoalScreen,
      (route) => false,
    );
  }
}
