part of 'friends_screen_cubit.dart';

enum FriendscreenStateStatus {
  loading,
  loaded,
  error,
  goalCompleted,
  goalIsSubmitting,
  goalIsCompleting,
  ready,
}

class FriendscreenState extends Equatable {
  final DateTime selectedDate;
  final DateTime currentDate;
  final Friends friends;
  final List<Friends> friends;
  final List<int> achievements;
  final FriendsScreenStateStatus status;
  final bool displayFunFront;

  bool get isCheckboxActive =>
      goal.text.isNotEmpty || (goal.isCompleted && goal.text.isNotEmpty);

  const FriendsScreenState({
    required this.selectedDate,
    required this.currentDate,
    required this.goal,
    required this.goals,
    required this.achievements,
    required this.status,
    required this.displayFunFront,
  });

  factory GoalScreenState.initial() => GoalScreenState(
        selectedDate: DateTime.now(),
        currentDate: DateTime.now(),
        goal: Goal(text: '', createdAt: DateTime(0), authorId: 0),
        goals: [],
        achievements: [],
        status: GoalScreenStateStatus.ready,
        displayFunFront: true,
      );

  GoalScreenState copyWith({
    DateTime? selectedDate,
    DateTime? currentDate,
    Goal? goal,
    List<Goal>? goals,
    List<int>? achievements,
    GoalScreenStateStatus? status,
    bool displayFunFront = true,
  }) {
    return GoalScreenState(
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
