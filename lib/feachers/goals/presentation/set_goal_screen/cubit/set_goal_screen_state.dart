part of 'set_goal_screen_cubit.dart';

enum SetGoalScreenStateStatus {
  loading,
  noGoalSet,
  goalSet,
  error,
  goalCompleted,
}

class SetGoalScreenState extends Equatable {
  final Goal goal;
  final SetGoalScreenStateStatus status;

  bool get isCheckboxActive =>
      goal.text.isNotEmpty || (goal.isCompleted && goal.text.isNotEmpty);

  const SetGoalScreenState({
    required this.goal,
    required this.status,
  });

  factory SetGoalScreenState.initial() => SetGoalScreenState(
        goal: Goal(text: '', createdAt: DateTime(0), authorId: 0),
        status: SetGoalScreenStateStatus.noGoalSet,
      );

  SetGoalScreenState copyWith({
    Goal? goal,
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
