import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:goal_app/core/consts/funnytasks.dart';
import 'package:goal_app/core/widgets/fun.dart';
import 'package:goal_app/feachers/auth/domain/repos/session_repo.dart';

part 'games_screen_state.dart';

class GamesScreenCubit extends Cubit<GamesScreenState> {
  GamesScreenCubit({
    required SessionRepo sessionRepo,
  })  : _sessionRepo = sessionRepo,
        super(GamesScreenState.initial());

  final SessionRepo _sessionRepo;

// ИНИЦИАЛИЗАЦИЯ СТРАНИЦЫ С ЦЕЛЯМИ: ЗАГРУЗКА ВСЕХ ЦЕЛЕЙ И АЧИВОК
  void initGamesScreen() async {}

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
}
