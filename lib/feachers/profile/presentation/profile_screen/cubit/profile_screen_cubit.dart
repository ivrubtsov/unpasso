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

// ПОЛУЧАЕМ АЧИВКИ
  Future<void> getAchieves() async {
    emit(state.copyWith(status: ProfileScreenStateStatus.loading));
    try {
      final ach = await _profileRepo.getAchievements();
      emit(state.copyWith(
        status: ProfileScreenStateStatus.loaded,
        profile: ach,
      ));
    } on ServerException {
      emit(state.copyWith(status: ProfileScreenStateStatus.error));
    }
  }

// ДОБАВЛЯЕМ НОВУЮ АЧИВКУ (СОХРАНЯЕМ ОБНОВЛЕННЫЙ СПИСОК)
  void newAchieve(int newAch, BuildContext context) async {
    try {
      emit(state.copyWith(status: ProfileScreenStateStatus.loading));
      final profile = state.profile;
      profile.addAchievement(555);
      await _profileRepo.setAchievements(profile.achievements);
      emit(state.copyWith(
        profile: profile,
        status: ProfileScreenStateStatus.loaded,
      ));
      showAchieve(newAch, context);
    } on ServerException {
      emit(state.copyWith(status: ProfileScreenStateStatus.error));
      ErrorPresentor.showError(
          context, 'Unable to update achievements. Check internet connection');
    }
  }

// ПОКАЗЫВАЕМ МОДАЛКУ С АЧИВКОЙ ВНИЗУ
  void showAchieve(int ach, BuildContext context) {
    showModalBottomSheet<void>(
      context: context,
      builder: (BuildContext context) {
        return Container(
          height: 300,
          margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
          color: AppColors.achBg,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
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
                  Achievements.texts[ach],
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

// КНОПКА ПРОФИЛЬ
  void onProfileTapped(BuildContext context) {
    Navigator.of(context).pushNamed(MainRoutes.profileScreen);
  }
}
