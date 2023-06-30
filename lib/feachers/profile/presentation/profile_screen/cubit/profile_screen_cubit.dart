import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:goal_app/core/exceptions/exceptions.dart';
import 'package:goal_app/core/navigation/app_router.dart';
import 'package:goal_app/core/widgets/error_presentor.dart';
import 'package:goal_app/feachers/auth/domain/repos/session_repo.dart';
import 'package:goal_app/feachers/profile/domain/entities/profile.dart';
import 'package:goal_app/feachers/profile/domain/repos/profile_repo.dart';

part 'profile_screen_state.dart';

class ProfileScreenCubit extends Cubit<ProfileScreenState> {
  ProfileScreenCubit({
    required ProfileRepo profileRepo,
    required SessionRepo sessionRepo,
  })  : _profileRepo = profileRepo,
        _sessionRepo = sessionRepo,
        super(ProfileScreenState.initial());

  final ProfileRepo _profileRepo;
  final SessionRepo _sessionRepo;

// ПОЛУЧАЕМ СЕГОДНЯШНЮЮ ЦЕЛЬ
  Future<void> getAchieves() async {
    // (await SharedPreferences.getInstance()).remove(Keys.todaysGoal);
    emit(state.copyWith(status: ProfileScreenStateStatus.loading));
    try {
      final todaysGoal = await _profileRepo.getTodaysGoal();
      if (todaysGoal == null) {
        emit(state.copyWith(
          status: ProfileScreenStateStatus.noGoalSet,
          goal: todaysGoal,
        ));
      } else if (todaysGoal.isCompleted) {
        emit(state.copyWith(
          goal: todaysGoal,
          status: ProfileScreenStateStatus.goalCompleted,
        ));
      } else {
        emit(state.copyWith(
          goal: todaysGoal,
          status: ProfileScreenStateStatus.goalSet,
        ));
      }
    } on ServerException {
      emit(state.copyWith(status: ProfileScreenStateStatus.error));
    }
  }

// МЕНЯЕМ ТЕКСТ ЦЕЛИ В STATE
  void changeProfile(String value) {
    emit(state.copyWith(goal: state.goal.copyWith(text: value)));
  }

// СОХРАНЯЕМ НОВУЮ ЦЕЛЬ
  void onSubmittedComplete(String value, BuildContext context) async {
    if (value.isEmpty) {
      ErrorPresentor.showError(context, 'Enter a goal');
      return;
    }
    emit(state.copyWith(status: ProfileScreenStateStatus.loading));
    final authorId = _sessionRepo.sessionData!.id;
    try {
      final goal = await _profileRepo.createGoal(Goal(
          createdAt: DateTime.now().toUtc(),
          text: value,
          authorId: authorId,
          isCompleted: false));
      emit(
          state.copyWith(status: ProfileScreenStateStatus.goalSet, goal: goal));
    } on ServerException {
      ErrorPresentor.showError(
          context, 'Unable to create goal. Check internet connection');
    }
  }

// ЗАВЕРШАЕМ ЦЕЛЬ
  void completeGoal(BuildContext context) async {
    try {
      emit(state.copyWith(
        goal: state.goal.copyWith(isCompleted: true),
        status: ProfileScreenStateStatus.goalCompleted,
      ));

      await _profileRepo.completeGoal(state.goal);
    } on ServerException {
      ErrorPresentor.showError(
          context, 'Unable to change goal. Check internet connection');
    }
  }

// КНОПКА НАЗАД
  void onBackTapped(BuildContext context) {
    Navigator.of(context).pushNamed(MainRoutes.goalScreen);
  }

// КНОПКА ПРОФИЛЬ
  void onProfileTapped(BuildContext context) {
    Navigator.of(context).pushNamed(MainRoutes.profileScreen);
  }
}
