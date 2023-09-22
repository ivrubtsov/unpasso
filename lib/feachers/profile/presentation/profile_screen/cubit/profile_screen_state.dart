part of 'profile_screen_cubit.dart';

enum ProfileScreenStateStatus {
  loading,
  loaded,
  error,
}

class ProfileScreenState extends Equatable {
  final Profile profile;
  final ProfileScreenStateStatus status;

  const ProfileScreenState({
    required this.profile,
    required this.status,
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
      );

  ProfileScreenState copyWith({
    Profile? profile,
    ProfileScreenStateStatus? status,
  }) {
    return ProfileScreenState(
      profile: profile ?? this.profile,
      status: status ?? this.status,
    );
  }

  @override
  List<Object> get props => [profile, status];
}
