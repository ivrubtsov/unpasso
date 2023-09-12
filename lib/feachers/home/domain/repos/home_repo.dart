import 'package:goal_app/feachers/home/domain/entities/home.dart';

enum GetHomeQueryType { userHistory }

/// completeHome - завершает цель
/// createHome - получаем цель на сегодня
/// createHome - создаем цель
/// getHome - получаем историю целей пользователя
abstract class HomeRepo {
  Future<Home> createHome(Home Home);

  // Future<Home?> getTodaysHome();

  Future<void> removeTodaysHome();

  Future<List<Home>> getHome(GetHomeQueryType queryType);

  // Future<List<Home>> getProcessedListHome();

  Future<void> completeHome(Home Home);
}
