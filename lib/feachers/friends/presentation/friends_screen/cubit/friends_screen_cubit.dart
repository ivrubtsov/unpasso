import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:goal_app/core/exceptions/exceptions.dart';
import 'package:goal_app/core/widgets/error_presentor.dart';
import 'package:goal_app/feachers/friends/domain/repos/friends_repo.dart';
import 'package:goal_app/feachers/profile/data/models/profile_model/profile_model.dart';
import 'package:goal_app/feachers/profile/domain/entities/profile.dart';

part 'friends_screen_state.dart';

class FriendsScreenCubit extends Cubit<FriendsScreenState> {
  FriendsScreenCubit({
    required FriendsRepo friendsRepo,
  })  : _friendsRepo = friendsRepo,
        super(FriendsScreenState.initial());

  final FriendsRepo _friendsRepo;

// FRIENDS PAGE INITIALIZATION
  void initFriendsScreen() async {
    getFriendsnRequests();
  }

// CHANGING THE SEARCH TEXT IN THE STATE
  void changeSearchText(String value) {
    if (state.searchText == value) return;
    emit(state.copyWith(searchText: value));
  }

  void processFriendsResponse(Map<String, dynamic> json) {
    ProfileModel profile;
    List<Profile> friends = [];
    List<Profile> friendsRequestsReceived = [];
    List<Profile> friendsRequestsSent = [];
    List<int> friendsIds = [];
    List<int> friendsRequestsReceivedIds = [];
    List<int> friendsRequestsSentIds = [];
    for (var json in json['friends']) {
      profile = ProfileModel.fromJson(json);
      friends.add(profile);
      friendsIds.add(profile.id);
    }
    for (var json in json['friendsRequestsReceived']) {
      profile = ProfileModel.fromJson(json);
      friendsRequestsReceived.add(profile);
      friendsRequestsReceivedIds.add(profile.id);
    }
    for (var json in json['friendsRequestsSent']) {
      profile = ProfileModel.fromJson(json);
      friendsRequestsSent.add(profile);
      friendsRequestsSentIds.add(profile.id);
    }
    emit(
      state.copyWith(
        friends: friends,
        friendsRequestsReceived: friendsRequestsReceived,
        friendsRequestsSent: friendsRequestsSent,
        friendsIds: friendsIds,
        friendsRequestsReceivedIds: friendsRequestsReceivedIds,
        friendsRequestsSentIds: friendsRequestsSentIds,
      ),
    );
    return;
  }

  Future<void> getFriendsnRequests() async {
    try {
      emit(
        state.copyWith(
          status: FriendsScreenStateStatus.loading,
        ),
      );
      final Map<String, dynamic> userData = await _friendsRepo.getFriendsData();
      processFriendsResponse(userData);
      emit(
        state.copyWith(
          status: FriendsScreenStateStatus.ready,
          errorMessage: '',
        ),
      );
      return;
    } on ServerException {
      emit(state.copyWith(
        status: FriendsScreenStateStatus.error,
        errorMessage:
            'Can\'t load data. Please check your internet connection.',
      ));
    }
  }

  void acceptRequest(Profile profile, BuildContext context) async {
    try {
      final Map<String, dynamic> userData =
          await _friendsRepo.processRequest(profile, 'accept');
      processFriendsResponse(userData);
      return;
    } on ServerException {
      ErrorPresentor.showError(
          context, 'Unable to process the request. Check internet connection');
      emit(state.copyWith(status: FriendsScreenStateStatus.error));
    }
  }

  void rejectRequest(Profile profile, BuildContext context) async {
    try {
      final Map<String, dynamic> userData =
          await _friendsRepo.processRequest(profile, 'reject');
      processFriendsResponse(userData);
      return;
    } on ServerException {
      ErrorPresentor.showError(
          context, 'Unable to process the request. Check internet connection');
      emit(state.copyWith(status: FriendsScreenStateStatus.error));
    }
  }

  void removeFriend(Profile profile, BuildContext context) async {
    try {
      final Map<String, dynamic> userData =
          await _friendsRepo.processRequest(profile, 'remove');
      processFriendsResponse(userData);
      return;
    } on ServerException {
      ErrorPresentor.showError(
          context, 'Unable to process the request. Check internet connection');
      emit(state.copyWith(status: FriendsScreenStateStatus.error));
    }
  }

  void inviteFriend(Profile profile, BuildContext context) async {
    try {
      final Map<String, dynamic> userData =
          await _friendsRepo.processRequest(profile, 'invite');
      processFriendsResponse(userData);
      return;
    } on ServerException {
      ErrorPresentor.showError(
          context, 'Unable to process the request. Check internet connection');
      emit(state.copyWith(status: FriendsScreenStateStatus.error));
    }
  }

  bool checkFriend(int id) {
    return state.friendsIds.contains(id);
  }

  bool checkRequestSent(int id) {
    return state.friendsRequestsSentIds.contains(id);
  }

  bool checkRequestReceived(int id) {
    return state.friendsRequestsReceivedIds.contains(id);
  }
/*
  bool checkInviteSent(Profile profile) {
    var findById = (obj) => obj.id == profile.id;
    var result = state.friendsRequestsSent.where(findById);
    return result.isNotEmpty;
  }
*/

  Future<List<Profile>> searchFriends(String text) async {
    if (text == '') {
      return [];
    } else {
      List<Profile> friends =
          await _friendsRepo.searchFriends(text.toLowerCase());

      return friends;
    }
  }

  void openSearchBar() {
    if (state.searchOpen) return;
    emit(state.copyWith(searchOpen: true));
  }

  void closeSearchBar() {
    if (!state.searchOpen) return;
    emit(state.copyWith(searchOpen: false));
  }

// REFRESH THE CURRENT TIME TO CALCULATE DELAY ON APP RESUME
  void setCurrentDateNow() {
    emit(state.copyWith(currentDate: DateTime.now()));
  }
}
