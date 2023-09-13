part of 'games_screen_cubit.dart';

enum GamesScreenStateStatus {
  loading,
  loaded,
  error,
  ready,
}

class GamesScreenState extends Equatable {
  final GamesScreenStateStatus status;
  final bool displayFunFront;

  const GamesScreenState({
    required this.status,
    required this.displayFunFront,
  });

  factory GamesScreenState.initial() => GamesScreenState(
        status: GamesScreenStateStatus.ready,
        displayFunFront: true,
      );

  GamesScreenState copyWith({
    GamesScreenStateStatus? status,
    bool displayFunFront = true,
  }) {
    return GamesScreenState(
      status: status ?? this.status,
      displayFunFront: displayFunFront,
    );
  }

  @override
  List<Object> get props => [status, displayFunFront];
}
