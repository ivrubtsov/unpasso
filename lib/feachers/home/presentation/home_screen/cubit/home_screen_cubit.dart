import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:goal_app/core/consts/api_consts.dart';
import 'package:goal_app/core/exceptions/exceptions.dart';
import 'package:goal_app/feachers/auth/domain/repos/session_repo.dart';
import 'package:goal_app/feachers/goals/domain/entities/goal.dart';
import 'package:goal_app/feachers/home/domain/repos/home_repo.dart';
import 'package:goal_app/feachers/home/presentation/home_screen/home_screen.dart';

part 'home_screen_state.dart';

class HomeScreenCubit extends Cubit<HomeScreenState> {
  HomeScreenCubit({
    required HomeRepo homeRepo,
    required SessionRepo sessionRepo,
  })  : _homeRepo = homeRepo,
        _sessionRepo = sessionRepo,
        super(HomeScreenState.initial());

  final HomeRepo _homeRepo;
  final SessionRepo _sessionRepo;

// HOME PAGE INITIALIZATION
  void initHomeScreen() async {
    homeListScrollController.addListener(() {
      if (homeListScrollController.position.maxScrollExtent ==
          homeListScrollController.offset) {
        getMoreGoals();
      }
    });
    getFirstGoals();
  }

// GET THE CURRENT USER ID
  int getUserId() {
    return _sessionRepo.sessionData!.id;
  }

// LOAD GOALS
  Future<void> getFirstGoals() async {
    try {
      emit(
        state.copyWith(
          status: HomeScreenStateStatus.loading,
        ),
      );

      List<Goal> goals = await _homeRepo.getGoals(
        _sessionRepo.sessionData!.id,
        1,
      );
      final bool hasMore =
          goals.length < ApiConsts.fetchPageLimit ? false : true;

      emit(
        state.copyWith(
          goals: goals,
          goalsPage: 1,
          goalsHasMore: hasMore,
          status: HomeScreenStateStatus.ready,
          errorMessage: '',
        ),
      );
    } on ServerException {
      emit(state.copyWith(
        status: HomeScreenStateStatus.error,
        errorMessage:
            'Can\'t load data. Please check your internet connection.',
      ));
    }
  }

  Future<void> getMoreGoals() async {
    if (state.status == HomeScreenStateStatus.fetch ||
        state.status == HomeScreenStateStatus.loading) return;
    try {
      emit(state.copyWith(status: HomeScreenStateStatus.fetch));
      final int page = state.goalsPage + 1;
      final List<Goal> goals = state.goals;
      List<Goal> newGoals = await _homeRepo.getGoals(
        _sessionRepo.sessionData!.id,
        page,
      );
      final bool hasMore =
          newGoals.length < ApiConsts.fetchPageLimit ? false : true;
      goals.addAll(newGoals);
      emit(
        state.copyWith(
          goals: goals,
          goalsPage: page,
          goalsHasMore: hasMore,
          status: HomeScreenStateStatus.ready,
          errorMessage: '',
        ),
      );
    } on ServerException {
      emit(state.copyWith(
        status: HomeScreenStateStatus.error,
        errorMessage:
            'Can\'t load data. Please check your internet connection.',
      ));
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
      emit(state.copyWith(
        goals: goals,
        errorMessage: '',
      ));
    } on ServerException {
      emit(state.copyWith(
        status: HomeScreenStateStatus.error,
        errorMessage:
            'I don\'t like it. Please check your internet connection.',
      ));
    }
  }

  void setLikeGoal(Goal goal) async {
    try {
      await _homeRepo.likeGoal(goal, _sessionRepo.sessionData!.id);
      return;
    } on ServerException {
      emit(state.copyWith(
        status: HomeScreenStateStatus.error,
        errorMessage:
            'I don\'t like it. Please check your internet connection.',
      ));
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
      emit(state.copyWith(
        goals: goals,
        errorMessage: '',
      ));
    } on ServerException {
      emit(state.copyWith(
        status: HomeScreenStateStatus.error,
        errorMessage:
            'I don\'t like it. Please check your internet connection.',
      ));
    }
  }

  void setUnLikeGoal(Goal goal) async {
    try {
      await _homeRepo.unLikeGoal(goal, _sessionRepo.sessionData!.id);
      return;
    } on ServerException {
      emit(state.copyWith(
        status: HomeScreenStateStatus.error,
        errorMessage:
            'I don\'t like it. Please check your internet connection.',
      ));
    }
  }
}
