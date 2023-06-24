part of 'goal_screen_cubit.dart';

enum GoalScreenStateStatus {
  loading,
  loaded,
  noGoalSet,
  goalSet,
  error,
  goalCompleted,
}

class GoalScreenState extends Equatable {
  final DateTime date;
  final Goal goal;
  final List<Goal> goals;
  final GoalScreenStateStatus status;

  bool get isCheckboxActive =>
      goal.text.isNotEmpty || (goal.isCompleted && goal.text.isNotEmpty);

  const GoalScreenState({
    required this.date,
    required this.goal,
    required this.goals,
    required this.status,
  });

  factory GoalScreenState.initial() => GoalScreenState(
        date: DateTime.now(),
        goal: Goal(text: '', createdAt: DateTime(0), authorId: 0),
        goals: [],
        status: GoalScreenStateStatus.noGoalSet,
      );

  GoalScreenState copyWith({
    DateTime? date,
    Goal? goal,
    List<Goal>? goals,
    GoalScreenStateStatus? status,
  }) {
    return GoalScreenState(
      date: date ?? this.date,
      goal: goal ?? this.goal,
      goals: goals ?? this.goals,
      status: status ?? this.status,
    );
  }

  @override
  List<Object> get props => [date, goal, goals, status];
}
