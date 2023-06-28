import 'package:flutter/material.dart';
import 'package:goal_app/core/consts/app_colors.dart';

class AppFonts {
  AppFonts._();

  static const header = TextStyle(
    fontFamily: 'Fredoka',
    fontWeight: FontWeight.w500,
    fontSize: 32,
    color: AppColors.header,
  );

  static const subHeader = TextStyle(
    fontFamily: 'Fredoka',
    fontWeight: FontWeight.w400,
    fontSize: 16,
    color: AppColors.header,
  );

  static const button = TextStyle(
    fontFamily: 'Fredoka',
    fontWeight: FontWeight.w600,
    fontSize: 16,
    color: AppColors.bg,
  );

  static const input = TextStyle(
    fontFamily: 'Fredoka',
    fontWeight: FontWeight.w400,
    fontSize: 16,
    color: AppColors.main,
  );

  static const inputText = TextStyle(
    fontFamily: 'Fredoka',
    fontWeight: FontWeight.w400,
    fontSize: 16,
    color: AppColors.main,
  );

  static const inputLink = TextStyle(
    fontFamily: 'Fredoka',
    fontWeight: FontWeight.w400,
    fontSize: 16,
    color: AppColors.enabled,
  );

  static const date = TextStyle(
    fontFamily: 'Fredoka',
    fontWeight: FontWeight.w600,
    fontSize: 16,
    color: AppColors.dateText,
  );

  static const dateSelected = TextStyle(
    fontFamily: 'Fredoka',
    fontWeight: FontWeight.w600,
    fontSize: 16,
    color: AppColors.selectedDateText,
  );

  static const goalHeader = TextStyle(
    fontFamily: 'Fredoka',
    fontWeight: FontWeight.w500,
    fontSize: 48,
    color: AppColors.goalDate,
  );

  static const goal = TextStyle(
    fontFamily: 'Fredoka',
    fontWeight: FontWeight.w400,
    fontSize: 24,
    color: AppColors.goalText,
  );

  static const goalHint = TextStyle(
    fontFamily: 'Fredoka',
    fontWeight: FontWeight.w400,
    fontSize: 12,
    color: AppColors.goalHint,
  );
}
