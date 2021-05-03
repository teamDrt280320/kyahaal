import 'package:flutter/material.dart';

const kPrimaryDarkColor = Color(0xFF2422DE);
const kPrimaryColor = Color(0xFF7199F7);
const kPrimaryLightColor = Color(0xFFF2F5FC);
const kDarkPurple = Color(0xFF1A1355);
const kPurple = Color(0xFFB3B3DD);
const kLightPurple = Color(0xFFEAEAF3);
const kAmber = Color(0xFFF2A61E);
const kDarkGray = Color(0xFF3F3836);
Color primary = Color(0xffF6F8FE);
Color primary1 = Color(0xff0D0D0E);
Color secondary = Color(0xff3D52FF);

const kPrimaryGradientColor = LinearGradient(
  begin: Alignment.topLeft,
  end: Alignment.bottomRight,
  colors: [
    kPrimaryColor,
    kPrimaryLightColor,
  ],
);
const kSecondaryColor = Color(0xFF979797);
const kTextColor = Color(0xFF37303A);
const kAnimationDuration = Duration(milliseconds: 200);
final boxShadow = <BoxShadow>[
  BoxShadow(
    color: kPrimaryDarkColor.withOpacity(0.1),
    blurRadius: 16.0,
    offset: Offset(3, 3),
  ),
  BoxShadow(
    color: kPrimaryDarkColor.withOpacity(0.1),
    blurRadius: 16.0,
    offset: Offset(-3, -3),
  ),
];
BorderRadius defaultRadius = BorderRadius.circular(20);

double getElevation(Set<MaterialState> states) {
  const Set<MaterialState> interactiveStates = <MaterialState>{
    MaterialState.pressed,
    MaterialState.hovered,
    MaterialState.focused,
  };
  if (states.any(interactiveStates.contains)) {
    return 15;
  }
  return 5;
}
