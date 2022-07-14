import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:goal_app/core/exceptions/exceptions.dart';
import 'package:goal_app/core/navigation/app_router.dart';
import 'package:goal_app/core/widgets/error_presentor.dart';
import 'package:goal_app/feachers/auth/domain/repos/session_repo.dart';
import 'package:goal_app/feachers/goals/domain/entities/goal.dart';
import 'package:goal_app/feachers/goals/domain/repos/goals_repo.dart';

part 'set_goal_screen_state.dart';

class SetGoalScreenCubit extends Cubit<SetGoalScreenState> {
  SetGoalScreenCubit({
    required GoalsRepo goalsRepo,
    required SessionRepo sessionRepo,
  })  : _goalsRepo = goalsRepo,
        _sessionRepo = sessionRepo,
        super(SetGoalScreenState.initial());

  final GoalsRepo _goalsRepo;
  final SessionRepo _sessionRepo;

// ПОЛУЧАЕМ СЕГОДНЯШНЮЮ ЦЕЛЬ
  Future<void> getTodaysGoal() async {
    // (await SharedPreferences.getInstance()).remove(Keys.todaysGoal);
    emit(state.copyWith(status: SetGoalScreenStateStatus.loading));
    try {
      final todaysGoal = await _goalsRepo.getTodaysGoal();
      if (todaysGoal == null) {
        emit(state.copyWith(
          status: SetGoalScreenStateStatus.noGoalSet,
          goal: todaysGoal,
        ));
      } else if (todaysGoal.isCompleted) {
        emit(state.copyWith(
          goal: todaysGoal,
          status: SetGoalScreenStateStatus.goalCompleted,
        ));
      } else {
        emit(state.copyWith(
          goal: todaysGoal,
          status: SetGoalScreenStateStatus.goalSet,
        ));
      }
    } on ServerException {
      emit(state.copyWith(status: SetGoalScreenStateStatus.error));
    }
  }

// МЕНЯЕМ ТЕКСТ ЦЕЛИ В STATE
  void changeGoal(String value) {
    emit(state.copyWith(goal: state.goal.copyWith(text: value)));
  }

// СОХРАНЯЕМ НОВУЮ ЦЕЛЬ
  void onSubmittedComplete(String value, BuildContext context) async {
    if (value.isEmpty) {
      ErrorPresentor.showError(context, 'Enter a goal');
      return;
    }
    emit(state.copyWith(status: SetGoalScreenStateStatus.loading));
    final authorId = _sessionRepo.sessionData!.id;
    try {
      final goal = await _goalsRepo.createGoal(Goal(
          createdAt: DateTime.now(),
          text: value,
          authorId: authorId,
          isCompleted: false));
      emit(
          state.copyWith(status: SetGoalScreenStateStatus.goalSet, goal: goal));
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
        status: SetGoalScreenStateStatus.goalCompleted,
      ));

      await _goalsRepo.completeGoal(state.goal);
    } on ServerException {
      ErrorPresentor.showError(
          context, 'Unable to change goal. Check internet connection');
    }
  }

// КНОПКА ИСТОРИЯ
  void onHistoryTapped(BuildContext context) {
    Navigator.of(context).pushNamed(MainRoutes.goalsHistoryScreen);
  }
}
