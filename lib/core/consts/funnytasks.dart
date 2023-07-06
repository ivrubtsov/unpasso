import 'dart:math';

class FunnyTasks {
  FunnyTasks._();

  static List<String> tasks = [
    'Take a candy out of the plate filled with flour by mouth',
    'Throw a raw egg to a friend',
    'Jump 20 times on one foot',
    'Shout "cuckoo" out a window five times',
    'Reach your elbow to your heel',
    'Guess the food when blindfolded',
    'Make a paper aeroplane and hit a running friend with it',
    'Push a fruit or vegetable from one side of the table to the other without using your hands',
    'Drink two glasses of water',
    'Write any word on the paper, holding the pencil with your lips',
    'Guess the word your friend has in mind with three clues',
  ];

  static String getRandomTask() {
    final _random = new Random();
    final index = _random.nextInt(tasks.length);
    return tasks[index];
  }
}
