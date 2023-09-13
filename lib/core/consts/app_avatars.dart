import 'dart:math';
import 'package:flutter/material.dart';

class AppAvatars {
  AppAvatars._();

  static const length = 50;

  static int chooseAvatar() {
    final random = Random();
    return random.nextInt(length) + 1;
  }

  static Image getAvatarImage(int? id) {
    id = id ?? 0;
    return Image(
      image: AssetImage('assets/avatars/$id.png'),
    );
  }
}
