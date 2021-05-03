import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'constants.dart';

ThemeData theme() {
  return ThemeData(
    scaffoldBackgroundColor: kPrimaryLightColor,
    fontFamily: GoogleFonts.openSans().fontFamily,
    appBarTheme: appBarTheme(),
    textTheme: textTheme(),
    inputDecorationTheme: kInputDecorationTheme(),
    backgroundColor: kPrimaryLightColor,
    primaryColor: kPrimaryColor,
    visualDensity: VisualDensity.adaptivePlatformDensity,
    brightness: Brightness.light,
  );
}

kInputDecorationTheme() {
  OutlineInputBorder outlineInputBorder = OutlineInputBorder(
    borderRadius: BorderRadius.circular(8),
    borderSide: BorderSide(color: kSecondaryColor),
    gapPadding: 10,
  );
  return InputDecorationTheme(
    floatingLabelBehavior: FloatingLabelBehavior.always,
    contentPadding: EdgeInsets.symmetric(
      horizontal: 24,
      vertical: 20,
    ),
    enabledBorder: outlineInputBorder,
    focusedBorder: outlineInputBorder,
    labelStyle: GoogleFonts.openSans(
      fontWeight: FontWeight.w700,
    ),
    border: outlineInputBorder,
  );
}

InputDecorationTheme inputDecorationTheme2() {
  OutlineInputBorder outlineInputBorder = OutlineInputBorder(
    borderRadius: BorderRadius.circular(8),
    borderSide: BorderSide(color: kSecondaryColor),
    gapPadding: 10,
  );
  return InputDecorationTheme(
    floatingLabelBehavior: FloatingLabelBehavior.always,
    contentPadding: EdgeInsets.symmetric(
      horizontal: 4,
      vertical: 20,
    ),
    enabledBorder: outlineInputBorder,
    focusedBorder: outlineInputBorder,
    labelStyle: GoogleFonts.openSans(
      fontWeight: FontWeight.w700,
    ),
    border: outlineInputBorder,
  );
}

TextTheme textTheme() {
  return TextTheme(
    bodyText1: GoogleFonts.openSans(color: kTextColor),
    bodyText2: GoogleFonts.openSans(color: kTextColor),
    headline1: GoogleFonts.openSans(
      color: kTextColor,
      fontWeight: FontWeight.bold,
      fontSize: 28,
    ),
  );
}

AppBarTheme appBarTheme() {
  return AppBarTheme(
    color: Colors.transparent,
    elevation: 0,
    brightness: Brightness.dark,
    actionsIconTheme: IconThemeData(
      color: kTextColor,
    ),
    iconTheme: IconThemeData(color: kTextColor),
    centerTitle: true,
    textTheme: TextTheme(
      headline6: GoogleFonts.openSans(
        color: kSecondaryColor,
        fontSize: 18,
      ),
    ),
  );
}
