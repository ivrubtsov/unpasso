part of 'home_screen_cubit.dart';

enum HomeScreenStateStatus {
  loading,
  error,
  ready,
  fetch,
}

class HomeScreenState extends Equatable {
  final DateTime currentDate;
  final List<Goal> goals;
  final int goalsPage;
  final bool goalsHasMore;
  final HomeScreenStateStatus status;
  final String errorMessage;

  const HomeScreenState({
    required this.currentDate,
    required this.goals,
    required this.goalsPage,
    required this.goalsHasMore,
    required this.status,
    required this.errorMessage,
  });

  factory HomeScreenState.initial() => HomeScreenState(
        currentDate: DateTime.now(),
        goals: const [],
        goalsPage: 1,
        goalsHasMore: true,
        status: HomeScreenStateStatus.ready,
        errorMessage: '',
      );

  HomeScreenState copyWith({
    DateTime? currentDate,
    List<Goal>? goals,
    int? goalsPage,
    bool? goalsHasMore,
    HomeScreenStateStatus? status,
    String? errorMessage,
  }) {
    return HomeScreenState(
      currentDate: currentDate ?? this.currentDate,
      goals: goals ?? this.goals,
      goalsPage: goalsPage ?? this.goalsPage,
      goalsHasMore: goalsHasMore ?? this.goalsHasMore,
      status: status ?? this.status,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object> get props => [
        currentDate,
        goals,
        goalsPage,
        goalsHasMore,
        status,
        errorMessage,
      ];
}
