import 'package:flutter/material.dart';
import 'package:goal_app/core/consts/app_colors.dart';

class Achievements {
  Achievements._();

  static const length = 13;

  static List<String> texts = [
    // 0
    'This is the beginning of an amazing journey to perfection',
    // 1
    'Do you feel it? You have just become a better version of yourself',
    // 2
    'Some people are just one step ahead of monkey. But you are two steps ahead of you previous self.',
    // 3
    'Sacred Trinity',
    // 4
    'You are bold as a four-wheel-drive truck. Have one?',
    // 5
    '',
    // 6
    '',
    // 7
    '',
    // 8
    '',
    // 9
    '',
    // 10
    '',
    // 11
    'You are the best!!! Take a look back and see what a great journey you have passed.',
    // 12
    'Give yourself a break! Sometimes you just need to refill the energy.',
  ];

  static List<String> descriptions = [
    // 0
    'The first goal is set',
    // 1
    'The first step to success: the first goal is completed',
    // 2
    'Two steps ahead: two goals are completed in one week',
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
  ];

  static List<IconData> icons = [
    // 0
    Icons.star_border_rounded,
    // 1
    Icons.thumb_up_outlined,
  ];

  static Widget getNewAchievement(int ach) {
    return Icon(
      Achievements.icons[ach],
      color: AppColors.achIconActive,
      size: 128.0,
    );
  }

  static Widget getActiveIcon(int ach) {
    return Icon(
      Achievements.icons[ach],
      color: AppColors.achIconActive,
      size: 64.0,
    );
  }

  static Widget getNonActiveIcon(int ach) {
    return Icon(
      Achievements.icons[ach],
      color: AppColors.achIconNonActive,
      size: 64.0,
    );
  }

  static Widget getIcon(int ach, bool isActive) {
    if (isActive) {
      return getActiveIcon(ach);
    } else {
      return getNonActiveIcon(ach);
    }
  }
}
