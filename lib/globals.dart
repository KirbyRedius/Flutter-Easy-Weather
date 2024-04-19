import 'package:flutter/material.dart';

bool showFahrenheit = false;
int turnDarkTheme = 1;

List<AppColors> appColors = [
  AppColors(
    backgroundColor: Colors.white,
    textColor: Colors.black,
    textColorOnBackground: Colors.white,
    hourWeatherColor: const Color.fromARGB(255, 5, 196, 72),
    weekWeatherColor: Colors.blue,
    weekWeatherColorSecond: const Color.fromARGB(255, 16, 115, 196),
    switchActiveColor: const Color.fromARGB(255, 0, 17, 255),
  ),
  AppColors(
    backgroundColor: Colors.black,
    textColor: Colors.white,
    textColorOnBackground: Colors.black,
    hourWeatherColor: const Color.fromARGB(255, 0, 247, 255),
    weekWeatherColor: Colors.blue,
    weekWeatherColorSecond: const Color.fromARGB(255, 16, 115, 196),
    switchActiveColor: const Color.fromARGB(255, 45, 152, 234),
  ),
];

class AppColors {
  final Color backgroundColor;
  final Color textColor;
  final Color textColorOnBackground;
  final Color hourWeatherColor;
  final Color weekWeatherColor;
  final Color weekWeatherColorSecond;
  final Color switchActiveColor;
  AppColors({
    required this.backgroundColor,
    required this.textColor,
    required this.textColorOnBackground,
    required this.hourWeatherColor,
    required this.weekWeatherColor,
    required this.weekWeatherColorSecond,
    required this.switchActiveColor,
  });
}
