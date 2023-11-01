import 'dart:math';
import 'package:flutter/material.dart';

class AppAvatars {
  AppAvatars._();

  static const length = 50;

  static int chooseAvatar() {
    final random = Random();
    return random.nextInt(length) + 1;
  }

  static Widget getAvatarImage(int? id) {
    id = id ?? 0;
    if (id == 0) {
      return const Icon(
        Icons.person,
        size: 56.0,
      );
    } else {
      return Image(
        width: 56.0,
        height: 56.0,
        image: AssetImage('assets/avatars/$id.png'),
      );
    }
  }
}
