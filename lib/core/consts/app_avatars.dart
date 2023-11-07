import 'dart:math';
import 'package:flutter/material.dart';
import 'package:goal_app/core/consts/app_colors.dart';

class AppAvatars {
  AppAvatars._();

  static const length = 50;

  static List<String> headers = [
    'Animals',
    'Robot',
    'Users',
    'Professionals',
    'Travel',
    'Sports',
    'Winter sports',
    'Friendship',
    'Monsters',
    'Future',
    'Christmas',
  ];

  static int chooseAvatar() {
    final random = Random();
    return random.nextInt(length) + 1;
  }

  static Widget getAvatarImage(int? id, bool? isEnabled) {
    id = id ?? 0;
    isEnabled = isEnabled ?? true;
    if (id == 0) {
      return const Icon(
        Icons.person,
        size: 56.0,
      );
    } else {
      if (isEnabled) {
        return Image(
          width: 56.0,
          height: 56.0,
          image: AssetImage('assets/avatars/$id.png'),
        );
      } else {
        return Image(
          width: 56.0,
          height: 56.0,
          image: AssetImage('assets/avatars/$id.png'),
          color: AppColors.avatarShaded,
          colorBlendMode: BlendMode.color,
        );
      }
    }
  }
}
