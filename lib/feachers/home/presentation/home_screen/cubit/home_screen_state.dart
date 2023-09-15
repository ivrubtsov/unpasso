part of 'home_screen_cubit.dart';

enum HomeScreenStateStatus {
  loading,
  error,
  ready,
}

class HomeScreenState extends Equatable {
  final List<Goal> goalsPublic;
  final List<Goal> goalsFriends;
  final HomeScreenStateStatus status;

  const HomeScreenState({
    required this.goalsPublic,
    required this.goalsFriends,
    required this.status,
  });

  factory HomeScreenState.initial() => HomeScreenState(
        goalsPublic: [],
        goalsFriends: [],
        status: HomeScreenStateStatus.ready,
      );

  HomeScreenState copyWith({
    List<Goal>? goalsPublic,
    List<Goal>? goalsFriends,
    HomeScreenStateStatus? status,
  }) {
    return HomeScreenState(
      goalsPublic: goalsPublic ?? this.goalsPublic,
      goalsFriends: goalsFriends ?? this.goalsFriends,
      status: status ?? this.status,
    );
  }

  @override
  List<Object> get props => [
        goalsPublic,
        goalsFriends,
        status,
      ];
}
