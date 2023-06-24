part of 'profile_screen_cubit.dart';

enum ProfileScreenStateStatus {
  loading,
  noGoalSet,
  error,
}

class ProfileScreenState extends Equatable {
  final Profile goal;
  final ProfileScreenStateStatus status;

  bool get isCheckboxActive =>
      goal.text.isNotEmpty || (goal.isCompleted && goal.text.isNotEmpty);

  const ProfileScreenState({
    required this.goal,
    required this.status,
  });

  factory ProfileScreenState.initial() => ProfileScreenState(
        goal: Profile(text: '', createdAt: DateTime(0), authorId: 0),
        status: ProfileScreenStateStatus.noGoalSet,
      );

  ProfileScreenState copyWith({
    Profile? goal,
    ProfileScreenStateStatus? status,
  }) {
    return ProfileScreenState(
      goal: goal ?? this.goal,
      status: status ?? this.status,
    );
  }

  @override
  List<Object> get props => [goal, status];
}
