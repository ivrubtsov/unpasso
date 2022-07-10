import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:goal_app/feachers/goals/domain/repos/goals_repo.dart';

part 'set_goal_screen_state.dart';

class SetGoalScreenCubit extends Cubit<SetGoalScreenState> {
  SetGoalScreenCubit(GoalsRepo goalsRepo)
      : _goalsRepo = goalsRepo,
        super(SetGoalScreenInitial());

  final GoalsRepo _goalsRepo;
}
