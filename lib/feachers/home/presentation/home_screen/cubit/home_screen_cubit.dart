import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:goal_app/core/exceptions/exceptions.dart';
import 'package:goal_app/feachers/auth/domain/repos/session_repo.dart';
import 'package:goal_app/feachers/goals/domain/entities/goal.dart';
import 'package:goal_app/feachers/goals/domain/repos/goals_repo.dart';
import 'package:goal_app/feachers/home/domain/repos/home_repo.dart';
import 'package:goal_app/feachers/profile/domain/repos/profile_repo.dart';

part 'home_screen_state.dart';

class HomeScreenCubit extends Cubit<HomeScreenState> {
  HomeScreenCubit({
    required HomeRepo homeRepo,
    required SessionRepo sessionRepo,
    required ProfileRepo profileRepo,
    required GoalsRepo goalsRepo,
  })  : _homeRepo = homeRepo,
        _sessionRepo = sessionRepo,
        _profileRepo = profileRepo,
        _goalsRepo = goalsRepo,
        super(HomeScreenState.initial());

  final HomeRepo _homeRepo;
  final SessionRepo _sessionRepo;
  final ProfileRepo _profileRepo;
  final GoalsRepo _goalsRepo;

// HOME PAGE INITIALIZATION
  void initHomeScreen() async {
    getAllGoals();
  }

// LOAD GOALS
  void getAllGoals() async {
    try {
      emit(state.copyWith(status: HomeScreenStateStatus.loading));

      List<Goal> goals = await _homeRepo.getGoals(_sessionRepo.sessionData!.id);

      emit(
        state.copyWith(goals: goals),
      );
    } on ServerException {
      emit(state.copyWith(status: HomeScreenStateStatus.error));
    }
  }

// LIKE A GOAL
  void likeGoal(int id) async {
    try {
      List<Goal> goals = state.goals;
      final Goal newGoal =
          await _homeRepo.likeGoal(goals[id], _sessionRepo.sessionData!.id);
      goals[id].likeUsers = newGoal.likeUsers;
      goals[id].likes = newGoal.likes;
      goals[id].like = true;
      emit(state.copyWith(goals: goals));
    } on ServerException {
      emit(state.copyWith(status: HomeScreenStateStatus.error));
    }
  }

// UNLIKE A GOAL
  void unLikeGoal(int id) async {
    try {
      List<Goal> goals = state.goals;
      final Goal newGoal =
          await _homeRepo.unLikeGoal(goals[id], _sessionRepo.sessionData!.id);
      goals[id].likeUsers = newGoal.likeUsers;
      goals[id].likes = newGoal.likes;
      goals[id].like = false;
      emit(state.copyWith(goals: goals));
    } on ServerException {
      emit(state.copyWith(status: HomeScreenStateStatus.error));
    }
  }
}
