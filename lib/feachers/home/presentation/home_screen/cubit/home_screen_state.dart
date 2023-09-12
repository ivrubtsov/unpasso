part of 'home_screen_cubit.dart';

enum HomeScreenStateStatus {
  loading,
  loaded,
  error,
  goalCompleted,
  goalIsSubmitting,
  goalIsCompleting,
  ready,
}

class HomeScreenState extends Equatable {
  final DateTime selectedDate;
  final DateTime currentDate;
  final Home home;
  final List<Goal> goals;
  final List<int> achievements;
  final HomeScreenStateStatus status;
  final bool displayFunFront;

  bool get isCheckboxActive =>
      goal.text.isNotEmpty || (goal.isCompleted && goal.text.isNotEmpty);

  const HomeScreenState({
    required this.selectedDate,
    required this.currentDate,
    required this.goal,
    required this.goals,
    required this.achievements,
    required this.status,
    required this.displayFunFront,
  });

  factory HomeScreenState.initial() => HomeScreenState(
        selectedDate: DateTime.now(),
        currentDate: DateTime.now(),
        goal: Goal(text: '', createdAt: DateTime(0), authorId: 0),
        goals: [],
        achievements: [],
        status: GoalScreenStateStatus.ready,
        displayFunFront: true,
      );

  HomeScreenState copyWith({
    DateTime? selectedDate,
    DateTime? currentDate,
    Goal? goal,
    List<Goal>? goals,
    List<int>? achievements,
    GoalScreenStateStatus? status,
    bool displayFunFront = true,
  }) {
    return HomeScreenState(
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
