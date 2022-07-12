part of 'set_goal_screen_cubit.dart';

enum SetGoalScreenStateStatus { loading, noGoalSet, goalSet, error }

class SetGoalScreenState extends Equatable {
  final String goal;
  final SetGoalScreenStateStatus status;
  const SetGoalScreenState({
    required this.goal,
    required this.status,
  });

  factory SetGoalScreenState.initial() => const SetGoalScreenState(
        goal: '',
        status: SetGoalScreenStateStatus.loading,
      );

  SetGoalScreenState copyWith({
    String? goal,
    SetGoalScreenStateStatus? status,
  }) {
    return SetGoalScreenState(
      goal: goal ?? this.goal,
      status: status ?? this.status,
    );
  }

  @override
  List<Object> get props => [goal, status];
}
