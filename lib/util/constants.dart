import 'package:flutter/material.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';

const kBackGroundWhite = const Color(0xFFFEFDFB);
const kBackGroundBlack = const Color(0xFF363636);

//-- Orange Theme --
const kDeepOrange = const Color(0xFFFF9936);
const kLightOrange = const Color(0xFFFFAB4A);

//-- Red Theme --
const kDeepRed = const Color(0xFFC80032);
const kLightRed = const Color(0xFFFF465A);

//-- Blue Theme --
const kDeepBlue = const Color(0xFF0024CB);
const kLightBlue = const Color(0xFF1E72FF);

//-- Green Theme --
const kDeepGreen = const Color(0xFF287B00);
const kLightGreen = const Color(0xFF1EA764);

// Success green
const kSuccessGreen = const Color(0xFF01B154);

//Error red
const kErrorRed = const Color(0xFFD4174E);

//Warning yellow
const kWarningYellow = const Color(0xFFFEC02C);

const kLightSource = LightSource.topLeft;

const NeumorphicStyle kInactiveNeumorphStyle = NeumorphicStyle(
  lightSource: kLightSource,
  depth: 2.0,
  intensity: 1,
  shadowLightColor: Colors.transparent,
  shadowLightColorEmboss: Colors.transparent,
  color: kBackGroundWhite,
  shape: NeumorphicShape.flat,
);

const NeumorphicStyle kActiveNeumorphStyle = NeumorphicStyle(
  lightSource: kLightSource,
  depth: -2.0,
  intensity: 1,
  shadowLightColor: Colors.transparent,
  shadowLightColorEmboss: Colors.transparent,
  color: kDeepOrange,
  shape: NeumorphicShape.flat,
);
