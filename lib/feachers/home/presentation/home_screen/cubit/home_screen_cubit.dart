import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:goal_app/core/consts/achievements.dart';
import 'package:goal_app/core/consts/api_consts.dart';
import 'package:goal_app/core/exceptions/exceptions.dart';
import 'package:goal_app/core/widgets/error_presentor.dart';
import 'package:goal_app/feachers/auth/domain/repos/session_repo.dart';
import 'package:goal_app/feachers/goals/domain/entities/goal.dart';
import 'package:goal_app/feachers/home/domain/repos/home_repo.dart';
import 'package:goal_app/feachers/home/presentation/home_screen/home_screen.dart';
import 'package:goal_app/feachers/profile/domain/entities/profile.dart';
import 'package:goal_app/feachers/profile/domain/repos/profile_repo.dart';

part 'home_screen_state.dart';

class HomeScreenCubit extends Cubit<HomeScreenState> {
  HomeScreenCubit({
    required HomeRepo homeRepo,
    required SessionRepo sessionRepo,
    required ProfileRepo profileRepo,
  })  : _homeRepo = homeRepo,
        _sessionRepo = sessionRepo,
        _profileRepo = profileRepo,
        super(HomeScreenState.initial());

  final HomeRepo _homeRepo;
  final SessionRepo _sessionRepo;
  final ProfileRepo _profileRepo;

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
      final profile = await _profileRepo.getUserData();

      emit(
        state.copyWith(
          goals: goals,
          goalsPage: 1,
          goalsHasMore: hasMore,
          profile: profile,
          status: HomeScreenStateStatus.ready,
          errorMessage: '',
        ),
      );
      emit(
        state.copyWith(
          goalsLikedCount: countLikedGoals(),
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
      emit(
        state.copyWith(
          goalsLikedCount: countLikedGoals(),
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

  // COUNTING THE NUMBER OF LIKED GOALS
  int countLikedGoals() {
    int count = 0;
    final userId = getUserId();
    state.goals
        .where((goal) => goal.likeUsers.contains(userId))
        .forEach((goal) => count = count + 1);
    return count;
  }

// LIKE A GOAL
/*
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
*/

  void setLikeGoal(Goal goal, BuildContext context) async {
    try {
      await _homeRepo.likeGoal(goal, _sessionRepo.sessionData!.id);
      emit(
        state.copyWith(
          goalsLikedCount: state.goalsLikedCount + 1,
        ),
      );
      // Check and add achievements
      // 18 'Like a goal',
      if (!state.profile.achievements.contains(18)) {
        newAchieve(18, context);
      }
      // 20 'You have liked 11 goals',
      if (!state.profile.achievements.contains(20) &&
          state.goalsLikedCount > 10) {
        newAchieve(20, context);
      }
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
/*
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
*/

  void setUnLikeGoal(Goal goal, BuildContext context) async {
    try {
      await _homeRepo.unLikeGoal(goal, _sessionRepo.sessionData!.id);
      emit(
        state.copyWith(
          goalsLikedCount: state.goalsLikedCount - 1,
        ),
      );
      return;
    } on ServerException {
      emit(state.copyWith(
        status: HomeScreenStateStatus.error,
        errorMessage:
            'I don\'t like it. Please check your internet connection.',
      ));
    }
  }

  // REFRESH THE CURRENT TIME TO CALCULATE DELAY ON APP RESUME
  void setCurrentDateNow() {
    emit(state.copyWith(currentDate: DateTime.now()));
  }

  // ADD A NEW ACHIEVEMENT (SAVE THE LIST)
  void newAchieve(int newAch, BuildContext context) async {
    try {
      var achs = state.profile.achievements;
      if (achs.contains(newAch)) {
        return;
      }
      achs.add(newAch);
      await _profileRepo.setAchievements(achs);
      Profile newProfile = state.profile;
      newProfile.achievements = achs;
      emit(state.copyWith(
        profile: newProfile,
      ));
      Achievements.showAchieveModal(newAch, context);
    } on ServerException {
      emit(state.copyWith(status: HomeScreenStateStatus.error));
      ErrorPresentor.showError(
          context, 'Unable to update achievements. Check internet connection');
    }
  }
}
