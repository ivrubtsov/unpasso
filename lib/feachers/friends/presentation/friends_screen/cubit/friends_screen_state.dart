part of 'friends_screen_cubit.dart';

enum FriendsScreenStateStatus {
  loading,
  error,
  ready,
  fetch,
}

class FriendsScreenState extends Equatable {
  final DateTime currentDate;
  final List<Profile> friends;
  final List<Profile> friendsRequestsReceived;
  final List<Profile> friendsRequestsSent;
  final FriendsScreenStateStatus status;
  final String searchText;
  final bool searchOpen;
  final String errorMessage;

  const FriendsScreenState({
    required this.currentDate,
    required this.friends,
    required this.friendsRequestsReceived,
    required this.friendsRequestsSent,
    required this.status,
    required this.searchText,
    required this.searchOpen,
    required this.errorMessage,
  });

  factory FriendsScreenState.initial() => FriendsScreenState(
        currentDate: DateTime.now(),
        friends: const [],
        friendsRequestsReceived: const [],
        friendsRequestsSent: const [],
        status: FriendsScreenStateStatus.ready,
        searchText: '',
        searchOpen: false,
        errorMessage: '',
      );

  FriendsScreenState copyWith({
    DateTime? currentDate,
    List<Profile>? friends,
    List<Profile>? friendsRequestsReceived,
    List<Profile>? friendsRequestsSent,
    FriendsScreenStateStatus? status,
    String? searchText,
    bool? searchOpen,
    String? errorMessage,
  }) {
    return FriendsScreenState(
      currentDate: currentDate ?? this.currentDate,
      friends: friends ?? this.friends,
      friendsRequestsReceived:
          friendsRequestsReceived ?? this.friendsRequestsReceived,
      friendsRequestsSent: friendsRequestsSent ?? this.friendsRequestsSent,
      status: status ?? this.status,
      searchText: searchText ?? this.searchText,
      searchOpen: searchOpen ?? this.searchOpen,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object> get props => [
        currentDate,
        friends,
        friendsRequestsReceived,
        friendsRequestsSent,
        status,
        searchText,
        searchOpen,
        errorMessage,
      ];
}
