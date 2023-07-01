import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:goal_app/core/exceptions/exceptions.dart';
import 'package:goal_app/core/navigation/app_router.dart';
import 'package:goal_app/core/widgets/error_presentor.dart';
import 'package:goal_app/feachers/auth/domain/repos/session_repo.dart';
import 'package:goal_app/feachers/goals/domain/entities/goal.dart';
import 'package:goal_app/feachers/goals/domain/repos/goals_repo.dart';
import 'package:goal_app/feachers/goals/presentation/goal_screen/goal_screen.dart';

part 'goal_screen_state.dart';

class GoalScreenCubit extends Cubit<GoalScreenState> {
  GoalScreenCubit({
    required GoalsRepo goalsRepo,
    required SessionRepo sessionRepo,
  })  : _goalsRepo = goalsRepo,
        _sessionRepo = sessionRepo,
        super(GoalScreenState.initial());

  final GoalsRepo _goalsRepo;
  final SessionRepo _sessionRepo;

// ПОЛУЧАЕМ СЕГОДНЯШНЮЮ ЦЕЛЬ
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

// МЕНЯЕМ ТЕКСТ ЦЕЛИ В STATE
  void changeGoal(String value) {
    emit(state.copyWith(goal: state.goal.copyWith(text: value)));
  }

// ПОЛУЧАЕМ ИДЕНТИФИКАТОР ПОЛЬЗОВАТЕЛЯ
  int getUserId() {
    return _sessionRepo.sessionData!.id;
  }

// СОХРАНЯЕМ НОВУЮ ЦЕЛЬ
  void onSubmittedComplete(String value, BuildContext context) async {
    if (value.isEmpty) {
      ErrorPresentor.showError(context, 'Enter a goal');
      return;
    }
    emit(state.copyWith(status: GoalScreenStateStatus.loading));
    final authorId = _sessionRepo.sessionData!.id;
    try {
      final goal = await _goalsRepo.createGoal(Goal(
          createdAt: DateTime.now(),
          text: value,
          authorId: authorId,
          isCompleted: false));
      emit(state.copyWith(status: GoalScreenStateStatus.goalSet, goal: goal));
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
        status: GoalScreenStateStatus.goalCompleted,
      ));

      await _goalsRepo.completeGoal(state.goal);
    } on ServerException {
      ErrorPresentor.showError(
          context, 'Unable to change goal. Check internet connection');
    }
  }

// ЗАГРУЖАЕМ ИСТОРИЮ ЦЕЛЕЙ
  void getAllGoals() async {
    emit(state.copyWith(status: GoalScreenStateStatus.loading));
    try {
      final goals = await _goalsRepo.getGoals(GetGoalsQueryType.userHistory);

      emit(state.copyWith(goals: goals, status: GoalScreenStateStatus.loaded));
    } on ServerException {
      emit(state.copyWith(status: GoalScreenStateStatus.error));
    }
  }

// ИНИЦИАЛИЗАЦИЯ СТРАНИЦЫ С ЦЕЛЯМИ: ЗАГРУЗКА ВСЕХ ЦЕЛЕЙ ВКЛЮЧАЯ СЕГОДНЯШНЮЮ
  void initGoalsScreen() async {
    getAllGoals();
    if (dateListScrollController.hasClients) {
      final position = dateListScrollController.position.maxScrollExtent;
      // dateListScrollController.jumpTo(position);
      dateListScrollController.animateTo(
        position,
        duration: const Duration(seconds: 2),
        curve: Curves.easeOut,
      );
    }
    getTodaysGoal();
  }

// МЕНЯЕМ ВЫБРАННУЮ ДАТУ В STATE
  void setSelectedDate(DateTime value) {
    emit(state.copyWith(date: value));
  }

// КНОПКА ПРОФИЛЬ
  void onProfileTapped(BuildContext context) {
    Navigator.of(context).pushNamed(MainRoutes.profileScreen);
  }
}
