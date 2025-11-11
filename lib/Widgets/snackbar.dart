import 'package:flutter/material.dart';
import 'package:get/get.dart';

void showCustomSnackbar({
  required BuildContext context,
  required String message,
  Color backgroundColor = Colors.black,
  Duration duration = const Duration(seconds: 3),
}) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(
        message,
        style: const TextStyle(color: Colors.white),
      ),
      backgroundColor: backgroundColor,
      duration: duration,
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
    ),
  );
}

// If you're using GetX:
void showGetXSnackbar({
  required String message,
  Color backgroundColor = Colors.black,
  Duration duration = const Duration(seconds: 3),
}) {
  Get.snackbar(
    "Notification",
    message,
    backgroundColor: backgroundColor,
    colorText: Colors.white,
    snackPosition: SnackPosition.BOTTOM,
    margin: const EdgeInsets.all(10),
    borderRadius: 10,
    duration: duration,
  );
}
