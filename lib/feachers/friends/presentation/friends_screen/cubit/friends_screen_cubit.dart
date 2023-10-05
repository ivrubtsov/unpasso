import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:goal_app/core/consts/achievements.dart';
import 'package:goal_app/core/consts/app_colors.dart';
import 'package:goal_app/core/consts/app_fonts.dart';
import 'package:goal_app/core/exceptions/exceptions.dart';
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

// FRIENDS PAGE INITIALIZATION
  void initFriendsScreen() async {
    getFriendsnRequests();
  }

// CHANGING THE SEARCH TEXT IN THE STATE
  void changeSearchText(String value) {
    if (state.searchText == value) return;
    emit(state.copyWith(searchText: value));
  }

// GET THE USER ID
  int getUserId() {
    return _sessionRepo.sessionData!.id;
  }

  Future<void> getFriendsnRequests() async {
    try {
      emit(
        state.copyWith(
          status: FriendsScreenStateStatus.loading,
        ),
      );

      List<Profile> friends = await _friendsRepo.getFriends();
      List<Profile> friendsRequestsReceived =
          await _friendsRepo.getFriendsRequestsReceived();
      List<Profile> friendsRequestsSent =
          await _friendsRepo.getFriendsRequestsSent();
      emit(
        state.copyWith(
          friends: friends,
          friendsRequestsReceived: friendsRequestsReceived,
          friendsRequestsSent: friendsRequestsSent,
          status: FriendsScreenStateStatus.ready,
        ),
      );
    } on ServerException {
      emit(state.copyWith(status: FriendsScreenStateStatus.error));
    }
  }

  void acceptRequest(Profile profile) {
    _friendsRepo.processRequest(profile, 'accept');
    getFriendsnRequests();
    return;
  }

  void rejectRequest(Profile profile) {
    _friendsRepo.processRequest(profile, 'reject');
    getFriendsnRequests();
    return;
  }

  void removeFriend(Profile profile) {
    _friendsRepo.processRequest(profile, 'remove');
    getFriendsnRequests();
    return;
  }

  void inviteFriend(Profile profile) {
    _friendsRepo.processRequest(profile, 'invite');
    getFriendsnRequests();
    return;
  }

  bool checkInviteSent(Profile profile) {
    var findById = (obj) => obj.id == profile.id;
    var result = state.friendsRequestsSent.where(findById);
    return result.isNotEmpty;
  }

  Future<List<Profile>> searchFriends(String text) async {
    List<Profile> friends = await _friendsRepo.searchFriends(text);
    return friends;
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
