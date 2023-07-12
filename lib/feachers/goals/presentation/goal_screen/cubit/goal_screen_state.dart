part of 'goal_screen_cubit.dart';

enum GoalScreenStateStatus {
  loading,
  loaded,
  noGoalSet,
  goalSet,
  error,
  goalCompleted,
  goalIsSubmitting,
  goalIsCompleting,
  ready,
}

class GoalScreenState extends Equatable {
  final DateTime date;
  final Goal goal;
  final List<Goal> goals;
  final List<int> achievements;
  final GoalScreenStateStatus status;
  final bool displayFunFront;

  bool get isCheckboxActive =>
      goal.text.isNotEmpty || (goal.isCompleted && goal.text.isNotEmpty);

  const GoalScreenState({
    required this.date,
    required this.goal,
    required this.goals,
    required this.achievements,
    required this.status,
    required this.displayFunFront,
  });

  factory GoalScreenState.initial() => GoalScreenState(
        date: DateTime.now(),
        goal: Goal(text: '', createdAt: DateTime(0), authorId: 0),
        goals: [],
        achievements: [],
        status: GoalScreenStateStatus.noGoalSet,
        displayFunFront: true,
      );

  GoalScreenState copyWith({
    DateTime? date,
    Goal? goal,
    List<Goal>? goals,
    List<int>? achievements,
    GoalScreenStateStatus? status,
    bool displayFunFront = true,
  }) {
    return GoalScreenState(
      date: date ?? this.date,
      goal: goal ?? this.goal,
      goals: goals ?? this.goals,
      achievements: achievements ?? this.achievements,
      status: status ?? this.status,
      displayFunFront: displayFunFront,
    );
  }

  @override
  List<Object> get props =>
      [date, goal, goals, achievements, status, displayFunFront];
}
