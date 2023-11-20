part of 'home_screen_cubit.dart';

enum HomeScreenStateStatus {
  loading,
  error,
  ready,
  fetch,
}

class HomeScreenState extends Equatable {
  final DateTime currentDate;
  final Profile profile;
  final List<Goal> goals;
  final int goalsLikedCount;
  final int goalsPage;
  final bool goalsHasMore;
  final HomeScreenStateStatus status;
  final String errorMessage;

  const HomeScreenState({
    required this.currentDate,
    required this.profile,
    required this.goals,
    required this.goalsLikedCount,
    required this.goalsPage,
    required this.goalsHasMore,
    required this.status,
    required this.errorMessage,
  });

  factory HomeScreenState.initial() => HomeScreenState(
        currentDate: DateTime.now(),
        profile: Profile(id: 0),
        goals: const [],
        goalsLikedCount: 0,
        goalsPage: 1,
        goalsHasMore: true,
        status: HomeScreenStateStatus.ready,
        errorMessage: '',
      );

  HomeScreenState copyWith({
    DateTime? currentDate,
    Profile? profile,
    List<Goal>? goals,
    int? goalsLikedCount,
    int? goalsPage,
    bool? goalsHasMore,
    HomeScreenStateStatus? status,
    String? errorMessage,
  }) {
    return HomeScreenState(
      currentDate: currentDate ?? this.currentDate,
      profile: profile ?? this.profile,
      goals: goals ?? this.goals,
      goalsLikedCount: goalsLikedCount ?? this.goalsLikedCount,
      goalsPage: goalsPage ?? this.goalsPage,
      goalsHasMore: goalsHasMore ?? this.goalsHasMore,
      status: status ?? this.status,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object> get props => [
        currentDate,
        profile,
        goals,
        goalsLikedCount,
        goalsPage,
        goalsHasMore,
        status,
        errorMessage,
      ];
}
