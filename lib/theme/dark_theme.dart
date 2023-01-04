import 'package:flutter/material.dart';

ThemeData dark = ThemeData(
  fontFamily: 'Roboto',
  primaryColor: Color(0xB3EF7822),
  secondaryHeaderColor: Color(0xFF009f67),
  disabledColor: Color(0xffa2a7ad),
  backgroundColor: Color(0xFF343636),
  errorColor: Color(0xFFdd3135),
  brightness: Brightness.dark,
  hintColor: Color(0xFFbebebe),
  cardColor: Colors.black,
  colorScheme: ColorScheme.dark(primary: Color(0xFFffbd5c), secondary: Color(0xFFffbd5c)),
  textButtonTheme: TextButtonThemeData(style: TextButton.styleFrom(foregroundColor: Color(0xFFffbd5c))),
);
