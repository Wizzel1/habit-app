import 'package:Marbit/util/constants.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

TextTheme _textTheme(TextTheme standard) {
  return standard.copyWith(
    headline1: standard.headline1.copyWith(
        fontFamily: 'Lexend',
        color: kBackGroundWhite,
        fontSize: 80,
        fontWeight: FontWeight.w400),
    headline2: standard.headline2.copyWith(
        fontFamily: 'Lexend',
        color: kBackGroundWhite,
        fontSize: 60,
        fontWeight: FontWeight.w400),
    headline3: standard.headline3.copyWith(
        fontFamily: 'Lexend',
        color: kBackGroundWhite,
        fontSize: 40,
        fontWeight: FontWeight.w400),
    headline4: standard.headline4.copyWith(
        fontFamily: 'Lexend',
        color: kBackGroundWhite,
        fontSize: 30,
        fontWeight: FontWeight.w400),
    button: standard.button.copyWith(
      fontFamily: 'Lexend',
      fontWeight: FontWeight.bold,
    ),
    subtitle1: standard.subtitle1.copyWith(
        fontFamily: 'Lexend',
        color: kBackGroundWhite,
        fontSize: 24,
        fontWeight: FontWeight.w400),
    subtitle2: standard.subtitle2.copyWith(
        fontFamily: 'Lexend',
        color: kBackGroundWhite,
        fontSize: 20,
        fontWeight: FontWeight.w400),
    bodyText1: standard.bodyText1.copyWith(
        fontFamily: 'Lexend',
        color: kBackGroundWhite,
        fontSize: 16,
        fontWeight: FontWeight.w400),
    // bodyText2: standard.bodyText2.copyWith(
    //     fontFamily: GoogleFonts.dmSans().fontFamily,
    //     color: kBackGroundWhite,
    //     fontSize: 80,
    //     fontWeight: FontWeight.w400),
    caption: standard.caption.copyWith(
        fontFamily: 'Lexend',
        color: kBackGroundWhite,
        fontSize: 14,
        fontWeight: FontWeight.w400),
  );
}

ThemeData orangeTheme() {
  final ThemeData standard = ThemeData.light();

  return standard.copyWith(
    textTheme: _textTheme(standard.textTheme),
    primaryColor: kLightOrange,
    accentColor: kDeepOrange,
    backgroundColor: kBackGroundWhite,
  );
}

ThemeData redTheme() {
  final ThemeData standard = ThemeData.light();

  return standard.copyWith(
    textTheme: _textTheme(standard.textTheme),
    primaryColor: kLightRed,
    accentColor: kDeepRed,
    backgroundColor: kBackGroundWhite,
  );
}

ThemeData blueTheme() {
  final ThemeData standard = ThemeData.light();

  return standard.copyWith(
    textTheme: _textTheme(standard.textTheme),
    primaryColor: kLightBlue,
    accentColor: kDeepBlue,
    backgroundColor: kBackGroundWhite,
  );
}

ThemeData greenTheme() {
  final ThemeData standard = ThemeData.light();

  return standard.copyWith(
    textTheme: _textTheme(standard.textTheme),
    primaryColor: kLightGreen,
    accentColor: kDeepGreen,
    backgroundColor: kBackGroundWhite,
  );
}

ThemeData darkTheme(BuildContext context) {
  return Theme.of(context).copyWith(backgroundColor: kBackGroundBlack);
}
