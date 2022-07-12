import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:goal_app/core/exceptions/exceptions.dart';
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

  Future<void> getTodaysGoal() async {
    emit(state.copyWith(status: SetGoalScreenStateStatus.loading));
    try {
      final todaysGoal = await _goalsRepo.getTodaysGoal();
      if (todaysGoal == null) {
        emit(state.copyWith(
          status: SetGoalScreenStateStatus.noGoalSet,
        ));
      } else {
        emit(state.copyWith(
          goal: todaysGoal.text,
          status: SetGoalScreenStateStatus.goalSet,
        ));
      }

      emit(state.copyWith(status: SetGoalScreenStateStatus.loading));
    } on ServerException {
      emit(state.copyWith(status: SetGoalScreenStateStatus.error));
    }
  }

  void changeGoal(String value) {
    emit(state.copyWith(goal: value));
  }

  void onSubmittedComplete(String value, BuildContext context) async {
    emit(state.copyWith(status: SetGoalScreenStateStatus.loading));
    final authorId = _sessionRepo.sessionData!.id;
    try {
      await _goalsRepo.createGoal(Goal(
        text: value,
        authorId: authorId,
      ));
      emit(state.copyWith(status: SetGoalScreenStateStatus.goalSet));
    } on ServerException {
      ErrorPresentor.showError(
          context, 'Unable to create goal. Check internet connection');
    }
  }

  void completeGoal() {
    emit(state.copyWith(status: SetGoalScreenStateStatus.goalCompleted));
  }
}
