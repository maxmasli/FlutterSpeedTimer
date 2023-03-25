import 'package:flutter/material.dart';

class ThemeDataBuilder {
  static ThemeData buildThemeData(Color primaryColor, Color secondaryColor,
      Color textColor) {
    return ThemeData(
        colorScheme: ColorScheme(
          onError: Colors.white,
          brightness: Brightness.light,
          background: primaryColor,
          error: Colors.white,
          onBackground: primaryColor,
          onPrimary: primaryColor,
          onSecondary: secondaryColor,
          onSurface: primaryColor,
          primary: primaryColor,
          secondary: secondaryColor,
          surface: primaryColor,
        ),
        textTheme: TextTheme(
            bodyMedium: TextStyle(color: textColor)
        )
    );
  }
}