import 'package:Marbit/util/constants.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';

class SnackBars {
  static void getSuccessSnackBar(String title, String message) {
    Get.snackbar(
      title,
      message,
      snackStyle: SnackStyle.FLOATING,
      borderRadius: 8.0,
      icon: Icon(FontAwesomeIcons.check, color: kBackGroundWhite),
      shouldIconPulse: true,
      titleText: Text(
        title,
        style: TextStyle(color: kBackGroundWhite),
      ),
      messageText: Text(
        message,
        style: TextStyle(color: kBackGroundWhite),
      ),
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: kSuccessGreen,
    );
  }

  static void getWarningSnackBar(String title, String message) {
    Get.snackbar(
      title,
      message,
      snackStyle: SnackStyle.FLOATING,
      borderRadius: 8.0,
      icon: Icon(FontAwesomeIcons.exclamation, color: kBackGroundWhite),
      shouldIconPulse: true,
      titleText: Text(
        title,
        style: TextStyle(color: kBackGroundWhite),
      ),
      messageText: Text(
        message,
        style: TextStyle(color: kBackGroundWhite),
      ),
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: kWarningYellow,
    );
  }

  static void getErrorSnackBar(String title, String message) {
    Get.snackbar(
      title,
      message,
      snackStyle: SnackStyle.FLOATING,
      borderRadius: 8.0,
      icon: Icon(FontAwesomeIcons.ban, color: kBackGroundWhite),
      shouldIconPulse: true,
      titleText: Text(
        title,
        style: TextStyle(color: kBackGroundWhite),
      ),
      messageText: Text(
        message,
        style: TextStyle(color: kBackGroundWhite),
      ),
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: kErrorRed,
    );
  }
}
