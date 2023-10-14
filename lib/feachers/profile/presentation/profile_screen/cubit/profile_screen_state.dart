part of 'profile_screen_cubit.dart';

enum ProfileScreenStateStatus {
  loading,
  loaded,
  error,
}

class ProfileScreenState extends Equatable {
  final Profile profile;
  final ProfileScreenStateStatus status;
  final String errorMessage;

  const ProfileScreenState({
    required this.profile,
    required this.status,
    required this.errorMessage,
  });

  factory ProfileScreenState.initial() => ProfileScreenState(
        profile: Profile(
          id: 0,
          avatar: 0,
          achievements: [],
          friends: [],
          friendsRequestsReceived: [],
          friendsRequestsSent: [],
        ),
        status: ProfileScreenStateStatus.loading,
        errorMessage: '',
      );

  ProfileScreenState copyWith({
    Profile? profile,
    ProfileScreenStateStatus? status,
    String? errorMessage,
  }) {
    return ProfileScreenState(
      profile: profile ?? this.profile,
      status: status ?? this.status,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object> get props => [
        profile,
        status,
        errorMessage,
      ];
}
