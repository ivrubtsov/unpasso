import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:goal_app/core/consts/api_consts.dart';
import 'package:goal_app/core/entities/user/user.dart';
import 'package:goal_app/core/exceptions/auth_exception.dart';
import 'package:goal_app/core/navigation/app_router.dart';
import 'package:goal_app/core/widgets/error_presentor.dart';
import 'package:goal_app/feachers/auth/data/repos/email_auth_repo_impl.dart';
import 'package:url_launcher/url_launcher_string.dart';

import '../../../domain/repos/auth_repo.dart';

part 'register_screen_state.dart';

class RegisterScreenCubit extends Cubit<RegisterScreenState> {
  RegisterScreenCubit({
    required AuthRepo authRepo,
  })  : _authRepo = authRepo,
        super(RegisterScreenState.initial());

  final AuthRepo _authRepo;

  void onPolicyPrivacyTapped(BuildContext context) async {
    await launchUrlString(ApiConsts.policyPrivacy);
  }

  Future<void> onSignUpTapped(BuildContext context) async {
    try {
      emit(state.copyWith(status: RegisterScreenStateStatus.loading));
      if (!state.isFieldsFilled) {
        ErrorPresentor.showError(context, 'please fill in all the fields');
        return;
      }

      if (!state.isTermsAccepted) {
        ErrorPresentor.showError(
            context, 'Please agree with Terms and Privacy policy');
        return;
      }
      await _authRepo.registerUser(RegisterCreds(
        email: state.email,
        password: state.password,
        user: User(
          name: state.name,
        ),
      ));

      Navigator.of(context).pushNamedAndRemoveUntil(
        MainRoutes.goalScreen,
        (_) => false,
      );
    } on AuthException catch (e) {
      ErrorPresentor.showError(
        context,
        e.message ?? 'Unknown error. Please try again later',
      );
    }
  }

  void onLogInTapped(BuildContext context) {
    Navigator.of(context).pushNamed(
      AuthRoutes.authScreen,
    );
  }

  void changeEmail(String value) {
    if (state.email == value) return;
    emit(state.copyWith(email: value));
  }

  void changePassword(String value) {
    if (state.password == value) return;
    emit(state.copyWith(password: value));
  }

  void changeName(String value) {
    if (state.name == value) return;
    emit(state.copyWith(name: value));
  }

  void changeTermsAcception(bool value) {
    if (state.isTermsAccepted == value) return;
    emit(state.copyWith(isTermsAccepted: value));
  }
}
