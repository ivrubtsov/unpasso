import 'package:flutter/material.dart';
import 'package:goal_app/core/consts/app_colors.dart';

class Achievements {
  Achievements._();

  static const length = 14;

  static List<String> congrats = [
    // 0
    'This is the beginning of an amazing journey to perfection',
    // 1
    'Do you feel it? You have just become a better version of yourself',
    // 2
    'Some people are just one step ahead of monkey. But you are two steps ahead of you previous self',
    // 3
    'Sacred Trinity gives you its power to succeed',
    // 4
    'You are bold as a four-wheel-drive truck. Have one?',
    // 5
    'Give me five! You\'ve done it!',
    // 6
    'Indians work harder probably because they have 6 working days a week. And you are better than many Indians.',
    // 7
    'The whole week of success! This is a difficult but important achievment on a long journey to perfection.',
    // 8
    'Do you know that you\'re much better than an average person?',
    // 9
    'WOW! The whole month! You\'ve done it! Keep progressing!',
    // 10
    'Almost done! What aan amazing progress!!!',
    // 11
    'You are the best!!! Take a look back and see what a great journey you have passed.',
    // 12
    'Give yourself a break! Sometimes you just need to refill the energy.',
    // 13
    'The magic is here',
  ];

  static List<String> descriptions = [
    // 0
    'The first goal is set',
    // 1
    'The first step to success: the first goal is completed',
    // 2
    'Two steps ahead: two goals are completed in a row',
    // 3
    'Three goals in one week',
    // 4
    'Four goals in one week',
    // 5
    'Business week: five goals are completed in one week',
    // 6
    'Indian week: six goals are completed in one week',
    // 7
    'Full week: you did it! Seven days in a row!',
    // 8
    'Crescent: 15 goals in a month',
    // 9
    'Full moon: 30 days in a row',
    // 10
    'Demigod: 100 completed goals',
    // 11
    'Champion: 365 completed goals',
    // 12
    'A weekend without a backward thought',
    // 13
    'A special achievement from Dasha',
  ];

  static List<IconData> icons = [
    // 0
    Icons.plus_one,
    // 1
    Icons.task_alt,
    // 2
    Icons.done_all,
    // 3
    Icons.date_range,
    // 4
    Icons.pets,
    // 5
    Icons.grade,
    // 6
    Icons.hotel_class,
    // 7
    Icons.switch_access_shortcut_add,
    // 8
    Icons.brightness_4,
    // 9
    Icons.brightness_5,
    // 10
    Icons.emoji_people,
    // 11
    Icons.emoji_events,
    // 12
    Icons.cruelty_free,
    // 13
    Icons.error,
  ];

  static Widget getNewAchievement(int ach) {
    if (ach == 13) {
      return Image.asset('assets/achievements/ach13_128.png');
    } else {
      return Icon(
        icons[ach],
        color: AppColors.achIconActive,
        size: 128.0,
      );
    }
  }

  static Widget getActiveIcon(int ach) {
    if (ach == 13) {
      return Image.asset('assets/achievements/ach13_64.png');
    } else {
      return Icon(
        icons[ach],
        color: AppColors.achIconActive,
        size: 64.0,
      );
    }
  }

  static Widget getNonActiveIcon(int ach) {
    if (ach == 13) {
      return Image.asset('assets/achievements/ach13_64_off.png');
    } else {
      return Icon(
        icons[ach],
        color: AppColors.achIconNonActive,
        size: 64.0,
      );
    }
  }

  static Widget getIcon(int ach, bool isActive) {
    if (isActive) {
      return getActiveIcon(ach);
    } else {
      return getNonActiveIcon(ach);
    }
  }
}
