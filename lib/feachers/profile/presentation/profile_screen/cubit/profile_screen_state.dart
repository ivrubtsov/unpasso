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
        profile: Profile(id: 0, achievements: []),
        status: ProfileScreenStateStatus.loaded,
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
