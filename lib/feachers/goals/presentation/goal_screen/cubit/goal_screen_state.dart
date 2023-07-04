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
  final bool displayFunFront;

  bool get isCheckboxActive =>
      goal.text.isNotEmpty || (goal.isCompleted && goal.text.isNotEmpty);

  const GoalScreenState({
    required this.date,
    required this.goal,
    required this.goals,
    required this.status,
    required this.displayFunFront,
  });

  factory GoalScreenState.initial() => GoalScreenState(
        date: DateTime.now(),
        goal: Goal(text: '', createdAt: DateTime(0), authorId: 0),
        goals: [],
        status: GoalScreenStateStatus.noGoalSet,
        displayFunFront: true,
      );

  GoalScreenState copyWith({
    DateTime? date,
    Goal? goal,
    List<Goal>? goals,
    GoalScreenStateStatus? status,
    bool displayFunFront = true,
  }) {
    return GoalScreenState(
      date: date ?? this.date,
      goal: goal ?? this.goal,
      goals: goals ?? this.goals,
      status: status ?? this.status,
      displayFunFront: displayFunFront,
    );
  }

  @override
  List<Object> get props => [date, goal, goals, status, displayFunFront];
}
