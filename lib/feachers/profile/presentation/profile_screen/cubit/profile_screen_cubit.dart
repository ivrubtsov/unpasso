import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:goal_app/core/consts/achievements.dart';
import 'package:goal_app/core/consts/app_fonts.dart';
import 'package:goal_app/core/exceptions/exceptions.dart';
import 'package:goal_app/core/navigation/app_router.dart';
import 'package:goal_app/core/widgets/error_presentor.dart';
import 'package:goal_app/feachers/auth/domain/repos/auth_repo.dart';
import 'package:goal_app/feachers/profile/domain/entities/profile.dart';
import 'package:goal_app/feachers/profile/domain/repos/profile_repo.dart';

part 'profile_screen_state.dart';

class ProfileScreenCubit extends Cubit<ProfileScreenState> {
  ProfileScreenCubit({
    required ProfileRepo profileRepo,
    required AuthRepo authRepo,
  })  : _profileRepo = profileRepo,
        _authRepo = authRepo,
        super(ProfileScreenState.initial());

  final ProfileRepo _profileRepo;
  final AuthRepo _authRepo;

// INITIALIZATION OF THE PROFILE SCREEN
  void initProfileScreen() async {
    getProfile();
  }

// INITIALIZATION OF THE AVATAR SELECTION SCREEN
  void initAvatarScreen() async {
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
        errorMessage: '',
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

// LOG OUT BUTTON
  void onLogOutTapped(BuildContext context) {
    _authRepo.logOut();
    Navigator.of(context).pushNamed(AuthRoutes.authScreen);
  }

// BUTTON TO RETURN TO THE PROFILE SCREEN
/*
  void onAvatarBackTapped(BuildContext context) {
    Navigator.of(context).pushNamed(MainRoutes.profileScreen);
  }
*/

// BUTTON TO OPEN THE AVATARS SELECTION SCREEN
  void onAvatarOpenTapped(BuildContext context) {
    Navigator.of(context).pushNamed(MainRoutes.avatarScreen);
  }

// BUTTON TO SAVE THE NEW AVATAR
  void onAvatarAcceptTapped(BuildContext context) {
    // submitAvatar(context);
    Navigator.of(context).pushNamed(MainRoutes.profileScreen);
  }

/*
  int getCurrentAvatar() {
    return state.profile.avatar ?? 0;
  }
*/

// ACCOUNT DELETION BUTTON
  void onDeleteAccountTapped(BuildContext context) {
    // erase account
    _authRepo.deleteUser();
    _authRepo.logOut();
    // go to the login page
    Navigator.of(context).pushNamed(AuthRoutes.authScreen);
  }

// NAME CHANGE REQUEST
  void submitName(String name, BuildContext context) async {
    try {
      if (name == state.profile.name) return;
      Profile newProfile = state.profile.copyWith(name: name);
      await _profileRepo.updateUserData(newProfile);
      emit(state.copyWith(
        profile: newProfile,
        errorMessage: '',
      ));
    } on ServerException {
      emit(state.copyWith(status: ProfileScreenStateStatus.error));
      ErrorPresentor.showError(
          context, 'Unable to update the profile. Check internet connection');
    }
  }

// AVATAR CHANGE REQUEST
  void submitAvatar(BuildContext context, int avatar) async {
    try {
      emit(state.copyWith(
        profile: state.profile.copyWith(avatar: avatar),
        errorMessage: '',
      ));
      await _profileRepo.updateUserData(state.profile);
    } on ServerException {
      emit(state.copyWith(status: ProfileScreenStateStatus.error));
      ErrorPresentor.showError(
          context, 'Unable to update the profile. Check internet connection');
    }
  }

// AVATAR SELECTION
  void changeAvatar(int avatar) async {
    emit(state.copyWith(
      profile: state.profile.copyWith(avatar: avatar),
    ));
  }
}
