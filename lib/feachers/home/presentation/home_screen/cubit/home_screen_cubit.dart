import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:goal_app/core/consts/achievements.dart';
import 'package:goal_app/core/consts/app_colors.dart';
import 'package:goal_app/core/consts/app_fonts.dart';
import 'package:goal_app/core/consts/funnytasks.dart';
import 'package:goal_app/core/exceptions/exceptions.dart';
import 'package:goal_app/core/navigation/app_router.dart';
import 'package:goal_app/core/widgets/error_presentor.dart';
import 'package:goal_app/core/widgets/fun.dart';
import 'package:goal_app/feachers/auth/domain/repos/session_repo.dart';
import 'package:goal_app/feachers/home/data/models/home_model/home_model.dart';
import 'package:goal_app/feachers/home/domain/entities/home.dart';
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

// МЕНЯЕМ ТЕКСТ ЦЕЛИ В STATE
  void changeGoal(String value) {
    emit(state.copyWith(goal: state.goal.copyWith(text: value)));
  }

// ПОЛУЧАЕМ ИДЕНТИФИКАТОР ПОЛЬЗОВАТЕЛЯ
  int getUserId() {
    return _sessionRepo.sessionData!.id;
  }

// СОХРАНЯЕМ НОВУЮ ЦЕЛЬ
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
          isCompleted: false));

      emit(state.copyWith(goal: goal));

      // Check and add achievements
      // 0 'The first goal is set',
      newAchieve(0, context);

      // 12 'A weekend without a backward thought',
      if (!state.achievements.contains(12)) {
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
      if (!state.achievements.contains(2)) {
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
      if (!state.achievements.contains(3)) {
        if (countCompletedGoals(7) >= 3) {
          newAchieve(3, context);
        }
      }
      // 4 'Four goals in one week',
      if (!state.achievements.contains(4)) {
        if (countCompletedGoals(7) >= 4) {
          newAchieve(4, context);
        }
      }
      // 5 'Business week: five goals are completed in one week',
      if (!state.achievements.contains(5)) {
        if (countCompletedGoals(7) >= 5) {
          newAchieve(5, context);
        }
      }
      // 6 'Indian week: six goals are completed in one week',
      if (!state.achievements.contains(6)) {
        if (countCompletedGoals(7) >= 6) {
          newAchieve(6, context);
        }
      }
      // 7 'Full week: you did it! Seven days in a row!',
      if (!state.achievements.contains(7)) {
        if (countCompletedGoals(7) >= 7) {
          newAchieve(7, context);
        }
      }
      // 8 'Crescent: 15 goals in a month',
      if (!state.achievements.contains(8)) {
        if (countCompletedGoals(30) >= 15) {
          newAchieve(8, context);
        }
      }
      // 9 'Full moon: 30 days in a row',
      if (!state.achievements.contains(9)) {
        if (countCompletedGoals(30) >= 30) {
          newAchieve(9, context);
        }
      }
      // 10 'Demigod: 100 completed goals',
      if (!state.achievements.contains(10)) {
        if (countCompletedGoals(0) >= 100) {
          newAchieve(10, context);
        }
      }
      // 11 'Champion: 365 completed goals',
      if (!state.achievements.contains(11)) {
        if (countCompletedGoals(0) >= 365) {
          newAchieve(11, context);
        }
      }
      // 13 'A special achievement from Dasha',
      if (!state.achievements.contains(13)) {
        final DateTime today = DateTime.now();
        final DateTime dayMinus1 = today.subtract(const Duration(days: 1));
        final DateTime dayMinus2 = today.subtract(const Duration(days: 2));
        final DateTime dayMinus3 = today.subtract(const Duration(days: 3));
        final DateTime dayMinus4 = today.subtract(const Duration(days: 4));
        final DateTime dayMinus5 = today.subtract(const Duration(days: 5));
        final DateTime dayMinus6 = today.subtract(const Duration(days: 7));
        final DateTime dayMinus7 = today.subtract(const Duration(days: 7));
        if (state.goals.length > 8 &&
            !state.goals[1].isCompleted &&
            state.goals[1].createdAt.year == dayMinus1.year &&
            state.goals[1].createdAt.month == dayMinus1.month &&
            state.goals[1].createdAt.day == dayMinus1.day &&
            state.goals[2].isCompleted &&
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
            !state.goals[5].isCompleted &&
            state.goals[5].createdAt.year == dayMinus5.year &&
            state.goals[5].createdAt.month == dayMinus5.month &&
            state.goals[5].createdAt.day == dayMinus5.day &&
            state.goals[6].isCompleted &&
            state.goals[6].createdAt.year == dayMinus6.year &&
            state.goals[6].createdAt.month == dayMinus6.month &&
            state.goals[6].createdAt.day == dayMinus6.day &&
            !state.goals[7].isCompleted &&
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

// ЗАГРУЖАЕМ ИСТОРИЮ ЦЕЛЕЙ
  void getAllGoals() async {
    emit(state.copyWith(status: GoalScreenStateStatus.loading));
    try {
      final goals = await _goalsRepo.getGoals(GetGoalsQueryType.userHistory);
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
          status: GoalScreenStateStatus.ready));
    } on ServerException {
      emit(state.copyWith(status: GoalScreenStateStatus.error));
    }
  }

// ИНИЦИАЛИЗАЦИЯ СТРАНИЦЫ С ЦЕЛЯМИ: ЗАГРУЗКА ВСЕХ ЦЕЛЕЙ И АЧИВОК
  void initHomeScreen() async {
    getAllGoals();
    final achs = await _profileRepo.getAchievements();
    emit(state.copyWith(achievements: achs));
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

// ВОЗВРАЩАЕМ СОСТОЯНИЕ ПОВОРОТА КАРТОЧКИ
  bool getDisplayFunFront() {
    return state.displayFunFront;
  }

// ПЕРЕВОРАЧИВАЕМ КАРТОЧКУ С ЗАДАНИЯМИ
  void flipFunCard() {
    emit(state.copyWith(displayFunFront: !state.displayFunFront));
  }

// ВОЗВРАЩАЕМ ВИДЖЕТ (ЛИЦЕВАЯ ИЛИ ЗАДНЯЯ СТОРОНА) В ЗАВИСИМОСТИ ОТ СОСТОЯНИЯ
  Widget getFunGoalWidget() {
    final String funGoalText = FunnyTasks.getRandomTask();
    return state.displayFunFront
        ? const FunFront()
        : FunBack(funText: funGoalText);
  }

// ДОБАВЛЯЕМ НОВУЮ АЧИВКУ (СОХРАНЯЕМ ОБНОВЛЕННЫЙ СПИСОК)
  void newAchieve(int newAch, BuildContext context) async {
    try {
      final achs = state.achievements;
      if (achs.contains(newAch)) {
        return;
      }
      achs.add(newAch);
      await _profileRepo.setAchievements(achs);
      emit(state.copyWith(
        achievements: achs,
      ));
      showAchieveModal(newAch, context);
    } on ServerException {
      emit(state.copyWith(status: GoalScreenStateStatus.error));
      ErrorPresentor.showError(
          context, 'Unable to update achievements. Check internet connection');
    }
  }

// СЧИТАЕМ КОЛИЧЕСТВО ВЫПОЛНЕННЫХ ЗАДАЧ ЗА ПЕРИОД
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

// ПОКАЗЫВАЕМ МОДАЛКУ С АЧИВКОЙ ВНИЗУ
  void showAchieveModal(int ach, BuildContext context) {
    showModalBottomSheet<void>(
      context: context,
      builder: (BuildContext context) {
        return Container(
          height: 300,
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 20.0),
          decoration: const BoxDecoration(
            color: AppColors.achBg,
            // borderRadius: BorderRadius.circular(30.0),
          ),
          child: Column(
            // mainAxisAlignment: MainAxisAlignment.center,
            // mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                children: [
                  const Expanded(
                    child: Text(
                      'Congratulations!!!',
                      style: AppFonts.achModalHeader,
                      textAlign: TextAlign.center,
                    ),
                  ),
                  Align(
                    alignment: Alignment.topRight,
                    child: IconButton(
                        onPressed: () => Navigator.pop(context),
                        icon: const Icon(Icons.close),
                        color: AppColors.achCloseIcon),
                  ),
                ],
              ),
              Expanded(
                child: Center(
                  child: Achievements.getNewAchievement(ach),
                ),
              ),
              Text(
                Achievements.congrats[ach],
                style: AppFonts.achModalText,
                textAlign: TextAlign.center,
              ),
            ],
          ),
        );
      },
    );
  }
}