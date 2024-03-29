part of 'goal_screen_cubit.dart';

enum GoalScreenStateStatus {
  loading,
  loaded,
  error,
  goalCompleted,
  goalIsSubmitting,
  goalIsCompleting,
  goalIsGenerating,
  ready,
}

class GoalScreenState extends Equatable {
  final DateTime selectedDate;
  final DateTime currentDate;
  final Goal goal;
  final List<Goal> goals;
  final Profile profile;
  final GoalScreenStateStatus status;
  final bool displayFunFront;
  final String errorMessage;

  bool get isCheckboxActive =>
      goal.text.isNotEmpty || (goal.isCompleted && goal.text.isNotEmpty);

  const GoalScreenState({
    required this.selectedDate,
    required this.currentDate,
    required this.goal,
    required this.goals,
    required this.profile,
    required this.status,
    required this.displayFunFront,
    required this.errorMessage,
  });

  factory GoalScreenState.initial() => GoalScreenState(
        selectedDate: DateTime.now(),
        currentDate: DateTime.now(),
        goal: Goal(text: '', createdAt: DateTime(0), authorId: 0),
        goals: const [],
        profile: Profile(id: 0),
        status: GoalScreenStateStatus.ready,
        displayFunFront: true,
        errorMessage: '',
      );

  GoalScreenState copyWith({
    DateTime? selectedDate,
    DateTime? currentDate,
    Goal? goal,
    List<Goal>? goals,
    Profile? profile,
    GoalScreenStateStatus? status,
    bool displayFunFront = true,
    String? errorMessage,
  }) {
    return GoalScreenState(
      selectedDate: selectedDate ?? this.selectedDate,
      currentDate: currentDate ?? this.currentDate,
      goal: goal ?? this.goal,
      goals: goals ?? this.goals,
      profile: profile ?? this.profile,
      status: status ?? this.status,
      displayFunFront: displayFunFront,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object> get props => [
        selectedDate,
        currentDate,
        goal,
        goals,
        profile,
        status,
        displayFunFront,
        errorMessage,
      ];
}
