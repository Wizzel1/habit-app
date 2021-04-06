import 'package:Marbit/util/constants.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';

class SnackBars {
  static const SnackPosition _snackPosition = SnackPosition.TOP;
  static const Duration _snackDuration = Duration(seconds: 4);
  static const String _fontFamily = 'Lexend';

  static void showSuccessSnackBar(String title, String message) {
    Get.snackbar(
      title,
      message,
      duration: _snackDuration,
      padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
      snackStyle: SnackStyle.FLOATING,
      borderRadius: 8.0,
      icon: Icon(FontAwesomeIcons.check, color: kBackGroundWhite),
      shouldIconPulse: true,
      titleText: Text(
        title,
        style: TextStyle(
          color: kBackGroundWhite,
          fontWeight: FontWeight.bold,
          fontSize: 18,
          fontFamily: _fontFamily,
        ),
      ),
      messageText: Text(
        message,
        style: TextStyle(
          color: kBackGroundWhite,
          fontSize: 16,
          fontFamily: _fontFamily,
        ),
      ),
      snackPosition: _snackPosition,
      backgroundColor: kSuccessGreen,
    );
  }

  static void showWarningSnackBar(String title, String message) {
    Get.snackbar(
      title,
      message,
      duration: _snackDuration,
      padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
      snackStyle: SnackStyle.FLOATING,
      borderRadius: 8.0,
      icon: Icon(FontAwesomeIcons.exclamation, color: kBackGroundWhite),
      shouldIconPulse: true,
      titleText: Text(
        title,
        style: TextStyle(
          color: kBackGroundWhite,
          fontWeight: FontWeight.bold,
          fontSize: 18,
          fontFamily: _fontFamily,
        ),
      ),
      messageText: Text(
        message,
        style: TextStyle(
          color: kBackGroundWhite,
          fontSize: 16,
          fontFamily: _fontFamily,
        ),
      ),
      snackPosition: _snackPosition,
      backgroundColor: kWarningYellow,
    );
  }

  static void showErrorSnackBar(String title, String message) {
    Get.snackbar(
      title,
      message,
      duration: _snackDuration,
      padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
      snackStyle: SnackStyle.FLOATING,
      borderRadius: 8.0,
      icon: Icon(FontAwesomeIcons.ban, color: kBackGroundWhite),
      shouldIconPulse: true,
      titleText: Text(
        title,
        style: TextStyle(
          color: kBackGroundWhite,
          fontSize: 18,
          fontWeight: FontWeight.bold,
          fontFamily: _fontFamily,
        ),
      ),
      messageText: Text(
        message,
        style: TextStyle(
          color: kBackGroundWhite,
          fontSize: 16,
          fontFamily: _fontFamily,
        ),
      ),
      snackPosition: _snackPosition,
      backgroundColor: kErrorRed,
    );
  }
}
