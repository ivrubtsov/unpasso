part of 'games_screen_cubit.dart';

enum GamesScreenStateStatus {
  loading,
  loaded,
  error,
  goalCompleted,
  goalIsSubmitting,
  goalIsCompleting,
  ready,
}

class GamesScreenState extends Equatable {
  final DateTime selectedDate;
  final DateTime currentDate;
  final Games games;
  final List<Games> games;
  final List<int> achievements;
  final GamesScreenStateStatus status;
  final bool displayFunFront;

  bool get isCheckboxActive =>
      goal.text.isNotEmpty || (goal.isCompleted && goal.text.isNotEmpty);

  const GamesScreenState({
    required this.selectedDate,
    required this.currentDate,
    required this.goal,
    required this.goals,
    required this.achievements,
    required this.status,
    required this.displayFunFront,
  });

  factory GamesScreenState.initial() => GamesScreenState(
        selectedDate: DateTime.now(),
        currentDate: DateTime.now(),
        goal: Goal(text: '', createdAt: DateTime(0), authorId: 0),
        goals: [],
        achievements: [],
        status: GoalScreenStateStatus.ready,
        displayFunFront: true,
      );

  GamesScreenState copyWith({
    DateTime? selectedDate,
    DateTime? currentDate,
    Games? games,
    List<Goal>? goals,
    List<int>? achievements,
    GoalScreenStateStatus? status,
    bool displayFunFront = true,
  }) {
    return GamesScreenState(
      selectedDate: selectedDate ?? this.selectedDate,
      currentDate: currentDate ?? this.currentDate,
      goal: goal ?? this.goal,
      goals: goals ?? this.goals,
      achievements: achievements ?? this.achievements,
      status: status ?? this.status,
      displayFunFront: displayFunFront,
    );
  }

  @override
  List<Object> get props => [
        selectedDate,
        currentDate,
        goal,
        goals,
        achievements,
        status,
        displayFunFront
      ];
}
