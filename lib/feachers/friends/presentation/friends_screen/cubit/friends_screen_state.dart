part of 'friends_screen_cubit.dart';

enum FriendsScreenStateStatus {
  loading,
  error,
  ready,
  fetch,
}

class FriendsScreenState extends Equatable {
  final DateTime currentDate;
  final Profile profile;
  final List<Profile> friends;
  final List<Profile> friendsRequestsReceived;
  final List<Profile> friendsRequestsSent;
  final List<int> friendsIds;
  final List<int> friendsRequestsReceivedIds;
  final List<int> friendsRequestsSentIds;
  final FriendsScreenStateStatus status;
  final String searchText;
  final bool searchOpen;
  final String errorMessage;

  const FriendsScreenState({
    required this.currentDate,
    required this.profile,
    required this.friends,
    required this.friendsRequestsReceived,
    required this.friendsRequestsSent,
    required this.friendsIds,
    required this.friendsRequestsReceivedIds,
    required this.friendsRequestsSentIds,
    required this.status,
    required this.searchText,
    required this.searchOpen,
    required this.errorMessage,
  });

  factory FriendsScreenState.initial() => FriendsScreenState(
        currentDate: DateTime.now(),
        profile: Profile(id: 0),
        friends: const [],
        friendsRequestsReceived: const [],
        friendsRequestsSent: const [],
        friendsIds: const [],
        friendsRequestsReceivedIds: const [],
        friendsRequestsSentIds: const [],
        status: FriendsScreenStateStatus.ready,
        searchText: '',
        searchOpen: false,
        errorMessage: '',
      );

  FriendsScreenState copyWith({
    DateTime? currentDate,
    Profile? profile,
    List<Profile>? friends,
    List<Profile>? friendsRequestsReceived,
    List<Profile>? friendsRequestsSent,
    List<int>? friendsIds,
    List<int>? friendsRequestsReceivedIds,
    List<int>? friendsRequestsSentIds,
    FriendsScreenStateStatus? status,
    String? searchText,
    bool? searchOpen,
    String? errorMessage,
  }) {
    return FriendsScreenState(
      currentDate: currentDate ?? this.currentDate,
      profile: profile ?? this.profile,
      friends: friends ?? this.friends,
      friendsRequestsReceived:
          friendsRequestsReceived ?? this.friendsRequestsReceived,
      friendsRequestsSent: friendsRequestsSent ?? this.friendsRequestsSent,
      friendsIds: friendsIds ?? this.friendsIds,
      friendsRequestsReceivedIds:
          friendsRequestsReceivedIds ?? this.friendsRequestsReceivedIds,
      friendsRequestsSentIds:
          friendsRequestsSentIds ?? this.friendsRequestsSentIds,
      status: status ?? this.status,
      searchText: searchText ?? this.searchText,
      searchOpen: searchOpen ?? this.searchOpen,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object> get props => [
        currentDate,
        profile,
        friends,
        friendsRequestsReceived,
        friendsRequestsSent,
        friendsIds,
        friendsRequestsReceivedIds,
        friendsRequestsSentIds,
        status,
        searchText,
        searchOpen,
        errorMessage,
      ];
}
