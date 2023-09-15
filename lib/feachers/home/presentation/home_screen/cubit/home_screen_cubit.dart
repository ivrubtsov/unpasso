import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:goal_app/core/exceptions/exceptions.dart';
import 'package:goal_app/core/widgets/error_presentor.dart';
import 'package:goal_app/feachers/auth/domain/repos/session_repo.dart';
import 'package:goal_app/feachers/goals/domain/entities/goal.dart';
import 'package:goal_app/feachers/goals/domain/repos/goals_repo.dart';
import 'package:goal_app/feachers/home/domain/repos/home_repo.dart';
import 'package:goal_app/feachers/home/presentation/home_screen/home_screen.dart';
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
    try {
      emit(state.copyWith(status: HomeScreenStateStatus.loading));

      List<Goal> goals = await _homeRepo.getPublicGoals();

      emit(
        state.copyWith(goalsPublic: goals),
      );

      goals = await _homeRepo.getFriendsGoals(_sessionRepo.sessionData!.id);

      emit(
        state.copyWith(
          goalsFriends: goals,
          status: HomeScreenStateStatus.ready,
        ),
      );
    } on ServerException {
      emit(state.copyWith(status: HomeScreenStateStatus.error));
    }
  }

// LIKE A GOAL
  void likePublicGoal(int id) async {
    try {
      List<Goal> goals = state.goalsPublic;
      final Goal newGoal =
          await _homeRepo.likeGoal(goals[id], _sessionRepo.sessionData!.id);
      goals[id].likeUsers = newGoal.likeUsers;
      goals[id].likes = newGoal.likes;
      goals[id].like = true;
      emit(state.copyWith(goalsPublic: goals));
    } on ServerException {
      emit(state.copyWith(status: HomeScreenStateStatus.error));
    }
  }

  void likeFriendsGoal(int id) async {
    try {
      List<Goal> goals = state.goalsFriends;
      final Goal newGoal =
          await _homeRepo.likeGoal(goals[id], _sessionRepo.sessionData!.id);
      goals[id].likeUsers = newGoal.likeUsers;
      goals[id].likes = newGoal.likes;
      goals[id].like = true;
      emit(state.copyWith(goalsFriends: goals));
    } on ServerException {
      emit(state.copyWith(status: HomeScreenStateStatus.error));
    }
  }

// UNLIKE A GOAL
  void unlikePublicGoal(int id) async {
    try {
      List<Goal> goals = state.goalsPublic;
      final Goal newGoal =
          await _homeRepo.unLikeGoal(goals[id], _sessionRepo.sessionData!.id);
      goals[id].likeUsers = newGoal.likeUsers;
      goals[id].likes = newGoal.likes;
      goals[id].like = false;
      emit(state.copyWith(goalsPublic: goals));
    } on ServerException {
      emit(state.copyWith(status: HomeScreenStateStatus.error));
    }
  }

  void unlikeFriendsGoal(int id) async {
    try {
      List<Goal> goals = state.goalsFriends;
      final Goal newGoal =
          await _homeRepo.likeGoal(goals[id], _sessionRepo.sessionData!.id);
      goals[id].likeUsers = newGoal.likeUsers;
      goals[id].likes = newGoal.likes;
      goals[id].like = false;
      emit(state.copyWith(goalsFriends: goals));
    } on ServerException {
      emit(state.copyWith(status: HomeScreenStateStatus.error));
    }
  }
}
