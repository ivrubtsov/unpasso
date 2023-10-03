import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:goal_app/core/consts/achievements.dart';
import 'package:goal_app/core/consts/app_colors.dart';
import 'package:goal_app/core/consts/app_fonts.dart';
import 'package:goal_app/feachers/auth/domain/repos/session_repo.dart';
import 'package:goal_app/feachers/friends/domain/repos/friends_repo.dart';
import 'package:goal_app/feachers/profile/domain/entities/profile.dart';
import 'package:goal_app/feachers/profile/domain/repos/profile_repo.dart';

part 'friends_screen_state.dart';

class FriendsScreenCubit extends Cubit<FriendsScreenState> {
  FriendsScreenCubit({
    required FriendsRepo friendsRepo,
    required SessionRepo sessionRepo,
    required ProfileRepo profileRepo,
  })  : _friendsRepo = friendsRepo,
        _sessionRepo = sessionRepo,
        _profileRepo = profileRepo,
        super(FriendsScreenState.initial());

  final FriendsRepo _friendsRepo;
  final SessionRepo _sessionRepo;
  final ProfileRepo _profileRepo;

// CHANGING THE SEARCH TEXT IN THE STATE
  void changeSearchText(String value) {
    if (state.searchText == value) return;
    emit(state.copyWith(searchText: value));
  }

// GET THE USER ID
  int getUserId() {
    return _sessionRepo.sessionData!.id;
  }

  Future<void> getFriends() async {
    return;
  }

  void acceptRequest(Profile profile) {
    return;
  }

  void rejectRequest(Profile profile) {
    return;
  }

  void removeFriend(Profile profile) {
    return;
  }

  List<Profile> searchFriends() {
    return [];
  }

  void inviteFriend(Profile profile) {
    return;
  }

  bool checkInviteSent(Profile profile) {
    var findById = (obj) => obj.id == profile.id;
    var result = state.friendsRequestsSent.where(findById);
    return result.isNotEmpty;
  }

  void openSearchBar() {
    if (state.searchOpen) return;
    emit(state.copyWith(searchOpen: true));
  }

  void closeSearchBar() {
    if (!state.searchOpen) return;
    emit(state.copyWith(searchOpen: false));
  }

// SHOW THE SEARCH MODAL WINDOW
  void showSearchModal(int ach, BuildContext context) {
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
