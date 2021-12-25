import 'package:flutter_neumorphic/flutter_neumorphic.dart';

const kBackGroundWhite = Color(0xFFFEFDFB);
const kBackGroundBlack = Color(0xFF363636);

//-- Orange Theme --
const kDeepOrange = Color(0xFFFF9936);
const kLightOrange = Color(0xFFFFB454);

//-- Red Theme --
const kDeepRed = Color(0xFFC80032);
const kLightRed = Color(0xFFFF465A);

//-- Blue Theme --
const kDeepBlue = Color(0xFF0024CB);
const kLightBlue = Color(0xFF1E72FF);

//-- Green Theme --
const kDeepGreen = Color(0xFF287B00);
const kLightGreen = Color(0xFF1EA764);

// Success green
const kSuccessGreen = Color(0xFF01B154);

//Error red
const kErrorRed = Color(0xFFD4174E);

//Warning yellow
const kWarningYellow = Color(0xFFFEC02C);

const kLightSource = LightSource.topLeft;

const regexPattern = r"[\d]+-[\d]+";

const NeumorphicStyle kInactiveNeumorphStyle = NeumorphicStyle(
  depth: 2.0,
  intensity: 1,
  shadowLightColor: Colors.transparent,
  shadowLightColorEmboss: Colors.transparent,
  color: kBackGroundWhite,
);

const NeumorphicStyle kActiveNeumorphStyle = NeumorphicStyle(
  depth: -2.0,
  intensity: 1,
  shadowLightColor: Colors.transparent,
  shadowLightColorEmboss: Colors.transparent,
  color: kDeepOrange,
);
