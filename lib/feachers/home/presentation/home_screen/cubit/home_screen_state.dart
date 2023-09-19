part of 'home_screen_cubit.dart';

enum HomeScreenStateStatus {
  loading,
  error,
  ready,
}

class HomeScreenState extends Equatable {
  final DateTime currentDate;
  final List<Goal> goals;
  final HomeScreenStateStatus status;

  const HomeScreenState({
    required this.currentDate,
    required this.goals,
    required this.status,
  });

  factory HomeScreenState.initial() => HomeScreenState(
        currentDate: DateTime.now(),
        goals: [],
        status: HomeScreenStateStatus.ready,
      );

  HomeScreenState copyWith({
    DateTime? currentDate,
    List<Goal>? goals,
    HomeScreenStateStatus? status,
  }) {
    return HomeScreenState(
      currentDate: currentDate ?? this.currentDate,
      goals: goals ?? this.goals,
      status: status ?? this.status,
    );
  }

  @override
  List<Object> get props => [
        currentDate,
        goals,
        status,
      ];
}
