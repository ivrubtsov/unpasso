import 'package:goal_app/feachers/games/domain/entities/games.dart';

enum GetGamesQueryType { userHistory }

/// completeGoal - завершает цель
/// createGoal - получаем цель на сегодня
/// createGoal - создаем цель
/// getGoals - получаем историю целей пользователя
abstract class GamesRepo {
  Future<Games> createGames(Games games);

  // Future<Goal?> getTodaysGoal();

  Future<void> removeTodaysGoal();

  Future<List<Goal>> getGoals(GetGoalsQueryType queryType);

  // Future<List<Goal>> getProcessedListGoals();

  Future<void> completeGoal(Goal goal);
}
