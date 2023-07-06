import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:goal_app/core/consts/achievements.dart';
import 'package:goal_app/core/consts/app_colors.dart';
import 'package:goal_app/core/consts/app_fonts.dart';
import 'package:goal_app/core/exceptions/exceptions.dart';
import 'package:goal_app/core/navigation/app_router.dart';
import 'package:goal_app/core/widgets/error_presentor.dart';
import 'package:goal_app/feachers/auth/domain/repos/session_repo.dart';
import 'package:goal_app/feachers/profile/domain/entities/profile.dart';
import 'package:goal_app/feachers/profile/domain/repos/profile_repo.dart';

part 'profile_screen_state.dart';

class ProfileScreenCubit extends Cubit<ProfileScreenState> {
  ProfileScreenCubit({
    required ProfileRepo profileRepo,
    required SessionRepo sessionRepo,
  })  : _profileRepo = profileRepo,
        _sessionRepo = sessionRepo,
        super(ProfileScreenState.initial());

  final ProfileRepo _profileRepo;
  final SessionRepo _sessionRepo;

// ПОЛУЧАЕМ ДАННЫЕ ПОЛЬЗОВАТЕЛЯ
  int getUserId() {
    return _sessionRepo.sessionData!.id;
  }

  String getName() {
    return _sessionRepo.sessionData!.username;
  }

  String getUsername() {
    return '';
  }

// ИНИЦИАЛИЗАЦИЯ СТРАНИЦЫ ПРОФИЛЯ
  void initProfileScreen() async {
    getAchieves();
  }

// ПОЛУЧАЕМ АЧИВКИ
  void getAchieves() async {
    emit(state.copyWith(status: ProfileScreenStateStatus.loading));
    try {
      final achs = await _profileRepo.getAchievements();
      final profile = Profile(
        id: _sessionRepo.sessionData!.id,
        achievements: achs,
      );

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

// ДОБАВЛЯЕМ НОВУЮ АЧИВКУ (СОХРАНЯЕМ ОБНОВЛЕННЫЙ СПИСОК)
  void newAchieve(int newAch, BuildContext context) async {
    try {
      emit(state.copyWith(status: ProfileScreenStateStatus.loading));
      final profile = state.profile;
      profile.addAchievement(newAch);
      await _profileRepo.setAchievements(profile.achievements);
      emit(state.copyWith(
        profile: profile,
        status: ProfileScreenStateStatus.loaded,
      ));
      showAchieveModal(newAch, context);
    } on ServerException {
      emit(state.copyWith(status: ProfileScreenStateStatus.error));
      ErrorPresentor.showError(
          context, 'Unable to update achievements. Check internet connection');
    }
  }

// ПОКАЗЫВАЕМ МОДАЛКУ С АЧИВКОЙ ВНИЗУ
  void showAchieveModal(int ach, BuildContext context) {
    showModalBottomSheet<void>(
      context: context,
      builder: (BuildContext context) {
        return Container(
          height: 300,
          margin: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 20.0),
          color: AppColors.achBg,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20.0),
          ),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                Align(
                  alignment: Alignment.topRight,
                  child: IconButton(
                      onPressed: () => Navigator.pop(context),
                      icon: const Icon(Icons.close),
                      color: AppColors.headerIcon),
                ),
                const Text(
                  'Congratulations! New achievement!!!',
                  style: AppFonts.achHeader,
                ),
                Text(
                  Achievements.congrats[ach],
                  style: AppFonts.achText,
                ),
                Center(
                  child: Achievements.getNewAchievement(ach),
                )
              ],
            ),
          ),
        );
      },
    );
  }

// КНОПКА НАЗАД
  void onBackTapped(BuildContext context) {
    Navigator.of(context).pushNamed(MainRoutes.goalScreen);
  }

// КНОПКА ВЫХОДА НА ЭКРАН АУТЕНТИФИКАЦИИ
  void onLogOutTapped(BuildContext context) {
    Navigator.of(context).pushNamed(AuthRoutes.authScreen);
  }
}
