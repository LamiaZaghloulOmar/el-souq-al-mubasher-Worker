import 'package:flutter/material.dart';

ThemeData dark = ThemeData(
  fontFamily: 'Tajawal',
  primaryColor: Color(0xFF70BCFF),
  secondaryHeaderColor: Color(0xFF009f67),
  disabledColor: Color(0xFF6f7275),
  errorColor: Color(0xFFdd3135),
  brightness: Brightness.dark,
  hintColor: Color(0xFFbebebe),
  cardColor: Colors.black,
  colorScheme: ColorScheme.dark(primary: Color(0xFF70BCFF), secondary: Color(0xFFffbd5c)),
  textButtonTheme: TextButtonThemeData(style: TextButton.styleFrom(primary: Color(0xFFffbd5c))),
);
