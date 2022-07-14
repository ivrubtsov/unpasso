part of 'history_screen_cubit.dart';

enum HistoryScreenStateStatus { loading, loaded, failure }

class HistoryScreenState extends Equatable {
  final List<Goal> goals;
  final HistoryScreenStateStatus status;

  const HistoryScreenState({required this.goals, required this.status});

  factory HistoryScreenState.initial() => const HistoryScreenState(
      goals: [], status: HistoryScreenStateStatus.loading);

  @override
  List<Object> get props => [goals, status];

  HistoryScreenState copyWith({
    List<Goal>? goals,
    HistoryScreenStateStatus? status,
  }) {
    return HistoryScreenState(
      goals: goals ?? this.goals,
      status: status ?? this.status,
    );
  }
}
