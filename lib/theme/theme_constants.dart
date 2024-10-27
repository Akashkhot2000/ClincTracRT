import 'package:clinicaltrac/common/hardcoded.dart';
import 'package:clinicaltrac/helper/app_helper.dart';
import 'package:flutter/material.dart';

///
ThemeData childTheme = ThemeData(
  primarySwatch: AppHelper.createMaterialColor(
    Color(Hardcoded.primaryGreen),
  ),
  scaffoldBackgroundColor: Color(Hardcoded.white),
  primaryColor: Color(Hardcoded.primaryGreen),
  colorScheme: ColorScheme.dark(
    primary: Color(Hardcoded.primaryGreen),
    // primaryContainer: Color(Hardcoded.earnCardColor), //green
    // ///Popup bg color
    // onPrimaryContainer: Color(Hardcoded.darkBlue),

    // surface: Color(Hardcoded.earnCardColor),
    // //List colors
    // secondaryContainer: Color(Hardcoded.listColor1),

    // ///orange
    // onSecondaryContainer: Color(
    //   Hardcoded.listColor2,
    // ), //orange variant

    // ///Dark blue
    // onBackground: Color(Hardcoded.darkBlue),

    // ///Dark orange
    // background: Color(Hardcoded.orange),

    // //GridColors
    // tertiaryContainer: Color(Hardcoded.gridColor1),
    // onTertiaryContainer: Color(
    //   Hardcoded.gridColor2,
    // ), //scaffold bg variant
  ),
  fontFamily: "Poppins",
  textTheme: TextTheme(
    displayLarge: TextStyle(
      fontSize: 25,
      color: Color(Hardcoded.white),
      fontWeight: FontWeight.normal,
    ),
    displayMedium: TextStyle(
      fontSize: 24,
      color: Color(Hardcoded.white),
      fontWeight: FontWeight.normal,
    ),
    displaySmall: TextStyle(
      fontSize: 22,
      color: Color(Hardcoded.white),
      fontWeight: FontWeight.normal,
    ),
    headlineMedium: TextStyle(
      fontSize: 20,
      color: Color(Hardcoded.white),
      fontWeight: FontWeight.normal,
    ),
    headlineSmall: TextStyle(
      fontSize: 18,
      color: Color(Hardcoded.white),
      fontWeight: FontWeight.normal,
    ),
    titleLarge: TextStyle(
      fontSize: 17,
      color: Color(Hardcoded.white),
      fontWeight: FontWeight.normal,
    ),
    bodyLarge: TextStyle(
      fontSize: 16,
      color: Color(Hardcoded.white),
      fontWeight: FontWeight.normal,
    ),
    bodyMedium: TextStyle(
      fontSize: 14,
      color: Color(Hardcoded.white),
      fontWeight: FontWeight.bold,
    ),
    titleMedium: TextStyle(
      fontSize: 13,
      color: Color(Hardcoded.white),
      fontWeight: FontWeight.normal,
    ),
    titleSmall: TextStyle(
      fontSize: 12,
      color: Color(Hardcoded.white),
      fontWeight: FontWeight.normal,
    ),
    labelLarge: TextStyle(
      fontSize: 11,
      color: Color(Hardcoded.white),
      fontWeight: FontWeight.normal,
    ),
    bodySmall: TextStyle(
      fontSize: 10,
      color: Color(Hardcoded.white),
      fontWeight: FontWeight.normal,
    ),
    labelSmall: TextStyle(
      fontSize: 8,
      color: Color(Hardcoded.white),
      fontWeight: FontWeight.normal,
    ),
  ),
  textSelectionTheme: TextSelectionThemeData(
    cursorColor: Color.fromARGB(255, 1, 167, 80),
    selectionColor: Color.fromARGB(255, 67, 129, 126),
    selectionHandleColor: Color.fromARGB(255, 1, 167, 80),
  ),
);
