import 'package:flutter/material.dart';
import 'package:goal_app/core/consts/app_colors.dart';

class Achievements {
  Achievements._();

  static List<String> texts = [
    // 0
    'Do you feel it? You have just become a better version of yourself',
    // 1
    '',
  ];

  static List<String> descriptions = [
    // 0
    'The first goal is set',
    // 1
    'The first goal is completed'
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
      size: 128,
    );
  }

  static Widget getActiveIcon(int ach) {
    return Icon(
      Achievements.icons[ach],
      color: AppColors.achIconActive,
      size: 32,
    );
  }

  static Widget getNonActiveIcon(int ach) {
    return Icon(
      Achievements.icons[ach],
      color: AppColors.achIconNonActive,
      size: 32,
    );
  }
}
