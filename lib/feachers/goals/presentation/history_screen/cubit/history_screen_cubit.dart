import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:goal_app/core/exceptions/exceptions.dart';
import 'package:goal_app/feachers/goals/domain/entities/goal.dart';

import '../../../domain/repos/goals_repo.dart';

part 'history_screen_state.dart';

class HistoryScreenCubit extends Cubit<HistoryScreenState> {
  HistoryScreenCubit(GoalsRepo goalsRepo)
      : _goalsRepo = goalsRepo,
        super(HistoryScreenState.initial());

  final GoalsRepo _goalsRepo;

  void init() async {
    emit(state.copyWith(status: HistoryScreenStateStatus.loading));
    try {
      final goals = await _goalsRepo.getGoals(GetGoalsQueryType.userHistory);

      emit(state.copyWith(
          goals: goals, status: HistoryScreenStateStatus.loaded));
    } on ServerException {
      emit(state.copyWith(status: HistoryScreenStateStatus.failure));
    }
  }
}
