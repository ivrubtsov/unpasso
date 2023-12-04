import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:goal_app/core/consts/achievements.dart';
import 'package:goal_app/core/consts/keys.dart';
import 'package:goal_app/core/exceptions/exceptions.dart';
import 'package:goal_app/core/navigation/app_router.dart';
import 'package:goal_app/core/widgets/error_presentor.dart';
import 'package:goal_app/feachers/auth/domain/repos/session_repo.dart';
import 'package:goal_app/feachers/goals/data/models/goal_model/goal_model.dart';
import 'package:goal_app/feachers/goals/domain/entities/goal.dart';
import 'package:goal_app/feachers/goals/domain/repos/goals_repo.dart';
import 'package:goal_app/feachers/goals/presentation/goal_screen/goal_screen.dart';
import 'package:goal_app/feachers/profile/domain/entities/profile.dart';
import 'package:goal_app/feachers/profile/domain/repos/profile_repo.dart';

part 'goal_screen_state.dart';

class GoalScreenCubit extends Cubit<GoalScreenState> {
  GoalScreenCubit({
    required GoalsRepo goalsRepo,
    required SessionRepo sessionRepo,
    required ProfileRepo profileRepo,
  })  : _goalsRepo = goalsRepo,
        _sessionRepo = sessionRepo,
        _profileRepo = profileRepo,
        super(GoalScreenState.initial());

  final GoalsRepo _goalsRepo;
  final SessionRepo _sessionRepo;
  final ProfileRepo _profileRepo;

// ПОЛУЧАЕМ СЕГОДНЯШНЮЮ ЦЕЛЬ
/*
  Future<void> getTodaysGoal() async {
    // (await SharedPreferences.getInstance()).remove(Keys.todaysGoal);
    emit(state.copyWith(status: GoalScreenStateStatus.loading));
    try {
      final todaysGoal = await _goalsRepo.getTodaysGoal();
      if (todaysGoal == null) {
        emit(state.copyWith(
          status: GoalScreenStateStatus.noGoalSet,
          goal: todaysGoal,
        ));
      } else if (todaysGoal.isCompleted) {
        emit(state.copyWith(
          goal: todaysGoal,
          status: GoalScreenStateStatus.goalCompleted,
        ));
      } else {
        emit(state.copyWith(
          goal: todaysGoal,
          status: GoalScreenStateStatus.goalSet,
        ));
      }
    } on ServerException {
      emit(state.copyWith(status: GoalScreenStateStatus.error));
    }
  }
*/

// CHANGE GOAL VISIBILITY (PRIVACY)
  void changePrivacy(Privacy privacy) {
    switch (privacy) {
      case Privacy.isPrivate:
        emit(state.copyWith(
            goal: state.goal.copyWith(
          isPrivate: true,
          isFriends: false,
          isPublic: false,
        )));
        return;
      case Privacy.isFriends:
        emit(state.copyWith(
            goal: state.goal.copyWith(
          isPrivate: false,
          isFriends: true,
          isPublic: false,
        )));
        return;
      case Privacy.isPublic:
        emit(state.copyWith(
            goal: state.goal.copyWith(
          isPrivate: false,
          isFriends: false,
          isPublic: true,
        )));
        return;
    }
  }

// CHANGE THE GOAL TITLE IN THE STATE
  void changeGoal(String value) {
    emit(state.copyWith(
        goal: state.goal.copyWith(
      text: value,
      isGenerated: false,
      isAccepted: false,
    )));
  }

// GET THE CURRENT USER ID
  int getUserId() {
    return _sessionRepo.sessionData!.id;
  }

// SAVE THE NEW GOAL
  void submitGoal(BuildContext context) async {
    final String value = state.goal.text;
    if (value.isEmpty || value == '%%!!-!!%%') {
      ErrorPresentor.showError(context, 'Enter a goal');
      return;
    }
    if (state.status == GoalScreenStateStatus.goalIsSubmitting) {
      return;
    }
    emit(state.copyWith(status: GoalScreenStateStatus.goalIsSubmitting));
    final authorId = _sessionRepo.sessionData!.id;
    try {
      // Save the new goal
      final goal = await _goalsRepo.createGoal(Goal(
        createdAt: DateTime.now(),
        text: value,
        authorId: authorId,
        authorName: state.profile.name ?? '',
        authorUserName: state.profile.userName ?? '',
        authorAvatar: state.profile.avatar ?? 0,
        isCompleted: false,
        isPublic: state.goal.isPublic,
        isFriends: state.goal.isFriends,
        isPrivate: state.goal.isPrivate,
        likeUsers: const [],
        likes: 0,
        isGenerated: state.goal.isGenerated,
        isAccepted: state.goal.isAccepted,
      ));

      emit(state.copyWith(goal: goal));

      // Check and add achievements
      // 0 'The first goal is set',
      if (!state.profile.achievements.contains(0)) {
        newAchieve(0, context);
      }

      // 12 'A weekend without a backward thought',
      if (!state.profile.achievements.contains(12)) {
        final DateTime today = DateTime.now();
        final DateTime friday = today.subtract(const Duration(days: 3));
        if (today.weekday == DateTime.monday &&
            state.goals.length >= 2 &&
            state.goals[1].createdAt.year == friday.year &&
            state.goals[1].createdAt.month == friday.month &&
            state.goals[1].createdAt.day == friday.day) {
          newAchieve(12, context);
        }
      }
      // 13 'A new goal was generated by AI',
      if (!state.profile.achievements.contains(13) &&
          state.goal.isGenerated &&
          state.goal.isAccepted) {
        newAchieve(13, context);
      }
      emit(state.copyWith(status: GoalScreenStateStatus.ready));
    } on ServerException {
      ErrorPresentor.showError(
          context, 'Unable to create goal. Check internet connection');
    }
  }

// ЗАВЕРШАЕМ ЦЕЛЬ
  void completeGoal(BuildContext context) async {
    try {
      if (state.status == GoalScreenStateStatus.goalIsCompleting ||
          state.status == GoalScreenStateStatus.goalIsSubmitting) {
        return;
      }
      emit(state.copyWith(status: GoalScreenStateStatus.goalIsCompleting));

      await _goalsRepo.completeGoal(state.goal);

      emit(state.copyWith(
        goal: state.goal.copyWith(isCompleted: true),
      ));

      // Check and add achievements
      // 1 'The first step to success: the first goal is completed',
      newAchieve(1, context);
      // 2 'Two steps ahead: two goals are completed in a row',
      if (!state.profile.achievements.contains(2)) {
        final DateTime today = DateTime.now();
        final DateTime dayMinus1 = today.subtract(const Duration(days: 1));
        if (state.goals.length > 1 &&
            state.goals[1].isCompleted &&
            state.goals[1].createdAt.year == dayMinus1.year &&
            state.goals[1].createdAt.month == dayMinus1.month &&
            state.goals[1].createdAt.day == dayMinus1.day) {
          newAchieve(2, context);
        }
      }

      // 3 'Three goals in one week',
      if (!state.profile.achievements.contains(3)) {
        if (countCompletedGoals(7) >= 3) {
          newAchieve(3, context);
        }
      }
      // 4 'Four goals in one week',
      if (!state.profile.achievements.contains(4)) {
        if (countCompletedGoals(7) >= 4) {
          newAchieve(4, context);
        }
      }
      // 5 'Business week: five goals are completed in one week',
      if (!state.profile.achievements.contains(5)) {
        if (countCompletedGoals(7) >= 5) {
          newAchieve(5, context);
        }
      }
      // 6 'Indian week: six goals are completed in one week',
      if (!state.profile.achievements.contains(6)) {
        if (countCompletedGoals(7) >= 6) {
          newAchieve(6, context);
        }
      }
      // 7 'Full week: you did it! Seven days in a row!',
      if (!state.profile.achievements.contains(7)) {
        if (countCompletedGoals(7) >= 7) {
          newAchieve(7, context);
        }
      }
      // 8 'Crescent: 15 goals in a month',
      if (!state.profile.achievements.contains(8)) {
        if (countCompletedGoals(30) >= 15) {
          newAchieve(8, context);
        }
      }
      // 9 'Full moon: 30 days in a row',
      if (!state.profile.achievements.contains(9)) {
        if (countCompletedGoals(30) >= 30) {
          newAchieve(9, context);
        }
      }
      // 10 'Demigod: 100 completed goals',
      if (!state.profile.achievements.contains(10)) {
        if (countCompletedGoals(0) >= 100) {
          newAchieve(10, context);
        }
      }
      // 11 'Champion: 365 completed goals',
      if (!state.profile.achievements.contains(11)) {
        if (countCompletedGoals(0) >= 365) {
          newAchieve(11, context);
        }
      }
      // 22 'A special achievement from Dasha',
      if (!state.profile.achievements.contains(22)) {
        final DateTime today = DateTime.now();
        final DateTime dayMinus1 = today.subtract(const Duration(days: 1));
        final DateTime dayMinus2 = today.subtract(const Duration(days: 2));
        final DateTime dayMinus3 = today.subtract(const Duration(days: 3));
        final DateTime dayMinus4 = today.subtract(const Duration(days: 4));
        final DateTime dayMinus5 = today.subtract(const Duration(days: 5));
        final DateTime dayMinus6 = today.subtract(const Duration(days: 7));
        final DateTime dayMinus7 = today.subtract(const Duration(days: 7));
        if (state.goals.length > 8 &&
            state.goals[1].isCompleted &&
            state.goals[1].createdAt.year == dayMinus1.year &&
            state.goals[1].createdAt.month == dayMinus1.month &&
            state.goals[1].createdAt.day == dayMinus1.day &&
            !state.goals[2].isCompleted &&
            state.goals[2].createdAt.year == dayMinus2.year &&
            state.goals[2].createdAt.month == dayMinus2.month &&
            state.goals[2].createdAt.day == dayMinus2.day &&
            state.goals[3].isCompleted &&
            state.goals[3].createdAt.year == dayMinus3.year &&
            state.goals[3].createdAt.month == dayMinus3.month &&
            state.goals[3].createdAt.day == dayMinus3.day &&
            !state.goals[4].isCompleted &&
            state.goals[4].createdAt.year == dayMinus4.year &&
            state.goals[4].createdAt.month == dayMinus4.month &&
            state.goals[4].createdAt.day == dayMinus4.day &&
            state.goals[5].isCompleted &&
            state.goals[5].createdAt.year == dayMinus5.year &&
            state.goals[5].createdAt.month == dayMinus5.month &&
            state.goals[5].createdAt.day == dayMinus5.day &&
            !state.goals[6].isCompleted &&
            state.goals[6].createdAt.year == dayMinus6.year &&
            state.goals[6].createdAt.month == dayMinus6.month &&
            state.goals[6].createdAt.day == dayMinus6.day &&
            state.goals[7].isCompleted &&
            state.goals[7].createdAt.year == dayMinus7.year &&
            state.goals[7].createdAt.month == dayMinus7.month &&
            state.goals[7].createdAt.day == dayMinus7.day) {
          newAchieve(13, context);
        }
      }
      emit(state.copyWith(status: GoalScreenStateStatus.ready));
    } on ServerException {
      ErrorPresentor.showError(
          context, 'Unable to complete goal. Check internet connection');
    }
  }

// LOADING THE GOALS HYSTORY
  void getAllGoals() async {
    emit(state.copyWith(status: GoalScreenStateStatus.loading));
    try {
      final goals =
          await _goalsRepo.getCurrentUserGoals(GetGoalsQueryType.userHistory);
      goals.sort((a, b) => b.createdAt.compareTo(a.createdAt));

      final DateTime today = DateTime.now();
      if (goals.isEmpty ||
          !(goals[0].createdAt.year == today.year &&
              goals[0].createdAt.month == today.month &&
              goals[0].createdAt.day == today.day)) {
        final authorId = getUserId();
        goals.insert(
            0,
            GoalModel(
              createdAt: today,
              text: '%%!!-!!%%',
              authorId: authorId,
              isCompleted: false,
              isExist: false,
              isPublic: true,
              isFriends: false,
              isPrivate: false,
            ));
      }
      // Load the today goal to the state
      if (goals[0].createdAt.year == today.year &&
          goals[0].createdAt.month == today.month &&
          goals[0].createdAt.day == today.day) {
        emit(state.copyWith(goal: goals[0]));
      }
      emit(state.copyWith(
        goals: goals,
        currentDate: DateTime.now(),
        status: GoalScreenStateStatus.ready,
        errorMessage: '',
      ));
    } on ServerException {
      emit(state.copyWith(
        status: GoalScreenStateStatus.error,
        errorMessage:
            'Can\'t load data. Please check your internet connection.',
      ));
    }
  }

// ИНИЦИАЛИЗАЦИЯ СТРАНИЦЫ С ЦЕЛЯМИ: ЗАГРУЗКА ВСЕХ ЦЕЛЕЙ И АЧИВОК
  void initGoalsScreen() async {
    getAllGoals();
    final profile = await _profileRepo.getUserData();
    emit(state.copyWith(profile: profile));
    // getTodaysGoal();
  }

// МЕНЯЕМ ВЫБРАННУЮ ДАТУ В STATE
  void setSelectedDate(DateTime value, double winWidth) {
    emit(state.copyWith(selectedDate: value));
    if (goalsListScrollController.hasClients) {
      final int index =
          state.goals.indexWhere((item) => item.createdAt == value);
      final double position = index * winWidth;
      goalsListScrollController.animateTo(position,
          duration: const Duration(seconds: 1), curve: Curves.easeInOutCubic);
    }
  }

// МЕНЯЕМ ВЫБРАННУЮ ДАТУ В STATE НА СЕГОДНЯ
  void setSelectedDateToday() {
    emit(state.copyWith(selectedDate: DateTime.now()));
  }

// КНОПКА ПРОФИЛЬ
  void onProfileTapped(BuildContext context) {
    Navigator.of(context).pushNamed(MainRoutes.profileScreen);
  }

// ADD A NEW ACHIEVEMENT (SAVE THE LIST)
  void newAchieve(int newAch, BuildContext context) async {
    try {
      List<int> achs;
      achs = state.profile.achievements;
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
      emit(state.copyWith(status: GoalScreenStateStatus.error));
      ErrorPresentor.showError(
          context, 'Unable to update achievements. Check internet connection');
    }
  }

// COUNTING THE NUMBER OF COMPLETED GOALS DURING A PERIOD OF TIME
  int countCompletedGoals(int period) {
    int count = 0;
    if (period > 0) {
      final DateTime today = DateTime.now();
      final DateTime dayMinus = today.subtract(Duration(
        days: period,
        hours: today.hour,
        minutes: today.minute,
        seconds: today.second,
      ));
      state.goals
          .where((goal) =>
              (goal.createdAt.compareTo(dayMinus) > 0 && goal.isCompleted))
          .forEach((goal) {
        count = count + 1;
      });
    } else {
      state.goals
          .where((goal) => goal.isCompleted)
          .forEach((goal) => count = count + 1);
    }
    return count;
  }

// COUNTING THE NUMBER OF LIKED GOALS AND SHOWING ACHIEVEMENTS
  void checkLikedGoalsAchs(BuildContext context) {
    var likes = state.goals.map((goal) => goal.likes);
    var totalLikes =
        likes.fold<int>(0, (previousValue, element) => previousValue + element);
    // Check and add achievements
    // 19 'Your goal was liked by others',
    if (!state.profile.achievements.contains(19) && totalLikes > 0) {
      newAchieve(19, context);
    }
    // 21 'Eleven your goals are liked by others',
    if (!state.profile.achievements.contains(21) && totalLikes > 10) {
      newAchieve(21, context);
    }
  }

// GENERATING A GOAL WITH AI
  void generateAIGoal(BuildContext context) async {
    try {
      if (state.status == GoalScreenStateStatus.goalIsGenerating) {
        return;
      }
      emit(state.copyWith(status: GoalScreenStateStatus.goalIsGenerating));
      // get a generated goal
      final value = await _goalsRepo.generateGoal();

      emit(state.copyWith(
        goal: state.goal.copyWith(
          text: value,
          isGenerated: true,
          isAccepted: true,
        ),
        status: GoalScreenStateStatus.ready,
        errorMessage: '',
      ));
      textFieldController.value = textFieldController.value.copyWith(
        text: value,
        selection: TextSelection.collapsed(offset: value.length),
      );
    } on ServerException {
      emit(state.copyWith(
        status: GoalScreenStateStatus.error,
        errorMessage:
            'Unfortunately the artificial intelligence is tired. There are too many people looking for its help. Please try again later,',
      ));
    }
  }
}
