import 'package:flutter/material.dart';

class LightThemeData {
  static ThemeData themeData() => ThemeData(
      colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      useMaterial3: true,
      textTheme: const TextTheme(
        titleMedium: TextStyle(
            fontSize: 20, fontWeight: FontWeight.w700, color: Colors.black),
        titleSmall: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.normal,
            color: Color(0xFF212529)),
        bodyMedium: TextStyle(fontSize: 20, color: Colors.black),
        displayLarge: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w400,
            color: Color(0xFF212529)),
        displayMedium: TextStyle(
            fontSize: 12,
            color: Color(0xFF9C9C9C),
            fontWeight: FontWeight.w400),
      ));
}
