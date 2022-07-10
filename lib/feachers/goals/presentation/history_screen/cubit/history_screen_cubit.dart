import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../domain/repos/goals_repo.dart';

part 'history_screen_state.dart';

class HistoryScreenCubit extends Cubit<HistoryScreenState> {
  HistoryScreenCubit(GoalsRepo goalsRepo)
      : _goalsRepo = goalsRepo,
        super(HistoryScreenInitial());

  final GoalsRepo _goalsRepo;
}
