import 'package:flutter/material.dart';

class ErrorPresentor {
  static void showError(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(message),
    ));
  }
}
