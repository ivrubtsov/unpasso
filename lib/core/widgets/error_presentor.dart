import 'package:flutter/material.dart';

class ErrorPresentor {
  static void showError(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      duration: const Duration(milliseconds: 900),
      content: Text(message),
    ));
  }
}
