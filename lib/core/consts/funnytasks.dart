import 'dart:math';

class FunnyTasks {
  FunnyTasks._();

  static List<String> tasks = [
    '',
    '',
    '',
  ];

  static String getRandomTask() {
    final _random = new Random();
    final index = _random.nextInt(tasks.length);
    return tasks[index];
  }
}
