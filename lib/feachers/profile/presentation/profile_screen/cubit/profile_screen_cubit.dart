import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:goal_app/core/consts/achievements.dart';
import 'package:goal_app/core/consts/app_fonts.dart';
import 'package:goal_app/core/exceptions/exceptions.dart';
import 'package:goal_app/core/navigation/app_router.dart';
import 'package:goal_app/feachers/auth/domain/repos/auth_repo.dart';
import 'package:goal_app/feachers/auth/domain/repos/session_repo.dart';
import 'package:goal_app/feachers/profile/domain/entities/profile.dart';
import 'package:goal_app/feachers/profile/domain/repos/profile_repo.dart';

part 'profile_screen_state.dart';

class ProfileScreenCubit extends Cubit<ProfileScreenState> {
  ProfileScreenCubit({
    required ProfileRepo profileRepo,
    required AuthRepo authRepo,
    required SessionRepo sessionRepo,
  })  : _profileRepo = profileRepo,
        _authRepo = authRepo,
        _sessionRepo = sessionRepo,
        super(ProfileScreenState.initial());

  final ProfileRepo _profileRepo;
  final AuthRepo _authRepo;
  final SessionRepo _sessionRepo;

// ПОЛУЧАЕМ ДАННЫЕ ПОЛЬЗОВАТЕЛЯ
  int getUserId() {
    return _sessionRepo.sessionData!.id;
  }

  String getName() {
    return state.profile.name ?? 'Unknown';
  }

  String getUsername() {
    return _sessionRepo.sessionData!.username;
  }

// ИНИЦИАЛИЗАЦИЯ СТРАНИЦЫ ПРОФИЛЯ
  void initProfileScreen() async {
    getProfile();
  }

// ПОЛУЧАЕМ АВАТАР, АЧИВКИ, ДРУЗЕЙ И ЗАПРОСЫ НА ДРУЖБУ
  void getProfile() async {
    emit(state.copyWith(status: ProfileScreenStateStatus.loading));
    try {
      final profile = await _profileRepo.getUserData();

      emit(state.copyWith(
        status: ProfileScreenStateStatus.loaded,
        profile: profile,
      ));
    } on ServerException {
      emit(state.copyWith(status: ProfileScreenStateStatus.error));
    }
  }

// ВЫВОДИМ АЧИВКИ НА СТРАНИЦЕ ПРОФИЛЯ
  List<Widget> showAchieves() {
    final List<Widget> achs = [];
    for (var i = 0; i < Achievements.length; i++) {
      achs.add(Container(
        alignment: Alignment.center,
        width: 160,
        height: 240,
        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 20.0),
        child: Column(
          children: [
            Achievements.getIcon(
              i,
              state.profile.achievements.contains(i), // isActive
            ),
            const SizedBox(
              height: 20.0,
            ),
            Expanded(
              child: Text(
                Achievements.descriptions[i],
                style: AppFonts.achText,
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      ));
    }

    return achs;
  }

// КНОПКА НАЗАД
  void onBackTapped(BuildContext context) {
    Navigator.of(context).pushNamed(MainRoutes.goalScreen);
  }

// КНОПКА ВЫХОДА НА ЭКРАН АУТЕНТИФИКАЦИИ
  void onLogOutTapped(BuildContext context) {
    _authRepo.logOut();
    Navigator.of(context).pushNamed(AuthRoutes.authScreen);
  }

// ACCOUNT DELETION BUTTON
  void onDeleteAccountTapped(BuildContext context) {
    // erase account
    _authRepo.deleteUser();
    _authRepo.logOut();
    // go to the login page
    Navigator.of(context).pushNamed(AuthRoutes.authScreen);
  }
}
