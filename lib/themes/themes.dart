import 'package:Marbit/util/constants.dart';
import 'package:flutter/material.dart';

TextTheme _textTheme(TextTheme standard) {
  return standard.copyWith(
    headline1: standard.headline1!.copyWith(
        fontFamily: 'Lexend',
        color: kBackGroundWhite,
        fontSize: 80,
        fontWeight: FontWeight.w500),
    headline2: standard.headline2!.copyWith(
        fontFamily: 'Lexend',
        color: kBackGroundWhite,
        fontSize: 60,
        fontWeight: FontWeight.w500),
    headline3: standard.headline3!.copyWith(
        fontFamily: 'Lexend',
        color: kBackGroundWhite,
        fontSize: 40,
        fontWeight: FontWeight.w500),
    headline4: standard.headline4!.copyWith(
        fontFamily: 'Lexend',
        color: kBackGroundWhite,
        fontSize: 30,
        fontWeight: FontWeight.w500),
    headline5: standard.headline5!.copyWith(
        fontFamily: 'Lexend',
        color: kBackGroundWhite,
        fontSize: 24,
        fontWeight: FontWeight.w500),
    headline6: standard.headline6!.copyWith(
        fontFamily: 'Lexend',
        color: kBackGroundWhite,
        fontSize: 20,
        fontWeight: FontWeight.w500),
    button: standard.button!.copyWith(
      fontSize: 14,
      fontFamily: 'Lexend',
      fontWeight: FontWeight.w600,
    ),
    subtitle1: standard.subtitle1!.copyWith(
        fontFamily: 'Lexend',
        color: kBackGroundWhite,
        fontSize: 24,
        fontWeight: FontWeight.w500),
    subtitle2: standard.subtitle2!.copyWith(
        fontFamily: 'Lexend',
        color: kBackGroundWhite,
        fontSize: 20,
        fontWeight: FontWeight.w500),
    bodyText1: standard.bodyText1!.copyWith(
        fontFamily: 'Lexend',
        color: kBackGroundWhite,
        fontSize: 16,
        fontWeight: FontWeight.w500),
    // bodyText2: standard.bodyText2.copyWith(
    //     fontFamily: GoogleFonts.dmSans().fontFamily,
    //     color: kBackGroundWhite,
    //     fontSize: 80,
    //     fontWeight: FontWeight.w400),
    caption: standard.caption!.copyWith(
        fontFamily: 'Lexend',
        color: kBackGroundWhite,
        fontSize: 14,
        fontWeight: FontWeight.w500),
  );
}

ThemeData orangeTheme() {
  final ThemeData standard = ThemeData.light();

  return standard.copyWith(
    textTheme: _textTheme(standard.textTheme),
    primaryColor: kLightOrange,
    backgroundColor: kBackGroundWhite,
    colorScheme: ColorScheme.fromSwatch().copyWith(secondary: kDeepOrange),
  );
}

ThemeData redTheme() {
  final ThemeData standard = ThemeData.light();

  return standard.copyWith(
    textTheme: _textTheme(standard.textTheme),
    primaryColor: kLightRed,
    backgroundColor: kBackGroundWhite, colorScheme: ColorScheme.fromSwatch().copyWith(secondary: kDeepRed),
  );
}

ThemeData blueTheme() {
  final ThemeData standard = ThemeData.light();

  return standard.copyWith(
    textTheme: _textTheme(standard.textTheme),
    primaryColor: kLightBlue,
    backgroundColor: kBackGroundWhite, colorScheme: ColorScheme.fromSwatch().copyWith(secondary: kDeepBlue),
  );
}

ThemeData greenTheme() {
  final ThemeData standard = ThemeData.light();

  return standard.copyWith(
    textTheme: _textTheme(standard.textTheme),
    primaryColor: kLightGreen,
    backgroundColor: kBackGroundWhite, colorScheme: ColorScheme.fromSwatch().copyWith(secondary: kDeepGreen),
  );
}

ThemeData darkTheme(BuildContext context) {
  return Theme.of(context).copyWith(backgroundColor: kBackGroundBlack);
}
