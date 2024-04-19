import 'dart:math';

import 'package:easyweather/api/hello-weather/client.dart';
import 'package:easyweather/utils/weather_icon.dart';
import 'package:flutter/material.dart';
import 'package:easyweather/globals.dart' as globals;
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_sizer/flutter_sizer.dart';
import 'package:intl/intl.dart';

class WeatherByDays extends StatefulWidget {
  final WeatherForecast weather;
  const WeatherByDays({super.key, required this.weather});

  @override
  State<WeatherByDays> createState() => _WeatherByDaysState();
}

class _WeatherByDaysState extends State<WeatherByDays> {
  late final int minChance;
  late final int maxChance;

  String dayName(int dayOfWeek) {
    switch (dayOfWeek) {
      case 1:
        return "Monday";
      case 2:
        return "Tuesday";
      case 3:
        return "Wednesday";
      case 4:
        return "Thursday";
      case 5:
        return "Friday";
      case 6:
        return "Saturday";
      case 7:
        return "Sunday";
      default:
        return "";
    }
  }

  List<Widget> percentWidget(BuildContext context, int percent, int minChance,
      int maxChance, ForecastDay forecastDay) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    if (percent != 0) {
      return [
        Animate(
          effects: [
            MoveEffect(
                duration: const Duration(seconds: 1),
                begin: Offset(width / 15, 0))
          ],
          child: Container(
            decoration: const BoxDecoration(
              color: Color.fromARGB(255, 0, 140, 255),
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(10),
                bottomLeft: Radius.circular(10),
              ),
            ),
            width: (width * 0.1) +
                (percent - minChance) / (maxChance - minChance) * (width / 10),
            height: height / 25,
            child: Align(
              alignment: Alignment.centerLeft,
              child: Padding(
                padding: const EdgeInsets.only(left: 8),
                child: Text(
                  "$percent%",
                  style: TextStyle(
                    color: globals
                        .appColors[globals.turnDarkTheme].textColorOnBackground,
                    fontSize: 16.dp,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ),
        ),
        Container(
          decoration: const BoxDecoration(
            color: Color.fromARGB(255, 16, 115, 196),
            borderRadius: BorderRadius.only(
              topRight: Radius.circular(10),
              bottomRight: Radius.circular(10),
            ),
          ),
          width: width * 0.1,
          height: height / 25,
          child: Align(
            alignment: Alignment.centerRight,
            child: WeatherIcon(
              radius: 5.h,
              isDay: null,
              icon: forecastDay.day.condition.icon,
            ),
          ),
        ),
      ];
    } else {
      return [
        Container(
          decoration: const BoxDecoration(
            color: Color.fromARGB(255, 16, 115, 196),
            borderRadius: BorderRadius.only(
              topRight: Radius.circular(10),
              bottomRight: Radius.circular(10),
              bottomLeft: Radius.circular(10),
              topLeft: Radius.circular(10),
            ),
          ),
          width: width * 0.1,
          height: height / 25,
          child: Align(
            alignment: Alignment.centerRight,
            child: WeatherIcon(
              radius: 5.h,
              isDay: null,
              icon: forecastDay.day.condition.icon,
            ),
          ),
        ),
      ];
    }
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> daysWeather = [];
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    double minT, maxT;

    if (globals.showFahrenheit) {
      maxT = widget.weather.forecast.forecastDay
          .map((h) => h.day.maxtempF)
          .reduce(max);

      minT = widget.weather.forecast.forecastDay
          .map((h) => h.day.maxwindKph)
          .reduce(min);
    } else {
      maxT = widget.weather.forecast.forecastDay
          .map((h) => h.day.maxtempC)
          .reduce(max);

      minT = widget.weather.forecast.forecastDay
          .map((h) => h.day.mintempC)
          .reduce(min);
    }

    int maxChanceRain = widget.weather.forecast.forecastDay
        .map((day) => day.day.dailyChanceOfRain)
        .reduce(max);
    int minChanceRain = widget.weather.forecast.forecastDay
        .map((day) => day.day.dailyChanceOfRain)
        .reduce(min);
    int maxChanceSnow = widget.weather.forecast.forecastDay
        .map((day) => day.day.dailyChanceOfSnow)
        .reduce(max);
    int minChanceSnow = widget.weather.forecast.forecastDay
        .map((day) => day.day.dailyChanceOfSnow)
        .reduce(min);

    int maxChance = maxChanceRain;
    int minChance = minChanceRain;

    if (maxChanceSnow > maxChance) {
      maxChance = maxChanceSnow;
    }
    if (minChanceSnow < minChance) {
      minChance = minChanceSnow;
    }

    for (ForecastDay forecastDay in widget.weather.forecast.forecastDay) {
      DateTime dateTime = DateFormat("yyyy-MM-dd").parse(forecastDay.date);
      String dayOfWeek =
          dayName(dateTime.weekday).substring(0, 3).toUpperCase();

      int percent = 0;
      if (forecastDay.day.dailyWillItRain > 0) {
        percent = forecastDay.day.dailyChanceOfRain;
      }
      if (forecastDay.day.dailyWillItSnow > 0) {
        percent = forecastDay.day.dailyChanceOfSnow;
      }

      double maxTDay, minTDay;

      if (globals.showFahrenheit) {
        maxTDay = forecastDay.day.maxtempF;
        minTDay = forecastDay.day.mintempF;
      } else {
        maxTDay = forecastDay.day.maxtempC;
        minTDay = forecastDay.day.mintempC;
      }
      daysWeather.add(
        Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Expanded(
                  child: Align(
                    alignment: Alignment.centerRight,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: percentWidget(
                          context, percent, minChance, maxChance, forecastDay),
                    ),
                  ),
                ),
                Expanded(
                  child: Column(
                    children: [
                      SizedBox(
                        width: width,
                        child: Text(
                          dayOfWeek,
                          style: TextStyle(
                            color: globals
                                .appColors[globals.turnDarkTheme].textColor,
                            fontSize: 16.dp,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      Text(
                        dateTime.day.toString(),
                        style: TextStyle(
                          color: globals
                              .appColors[globals.turnDarkTheme].textColor,
                          fontSize: 12.dp,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: Row(
                    children: [
                      Container(
                        width: width * 0.1,
                        height: height / 25,
                        decoration: const BoxDecoration(
                          color: Color.fromARGB(255, 16, 115, 196),
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(10),
                            bottomLeft: Radius.circular(10),
                          ),
                        ),
                        child: Center(
                          child: Text(
                            "${minTDay.toInt()}°",
                            style: TextStyle(
                              color: globals.appColors[globals.turnDarkTheme]
                                  .textColorOnBackground,
                              fontSize: 17.dp,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                      Animate(
                        effects: [
                          MoveEffect(
                            duration: const Duration(seconds: 1),
                            begin: Offset(-width / 50, 0),
                          )
                        ],
                        child: Container(
                          width: (width * 0.08) +
                              (maxTDay - minT) / (maxT - minT) * (width / 8),
                          height: height / 25,
                          decoration: BoxDecoration(
                            color: globals.appColors[globals.turnDarkTheme]
                                .weekWeatherColor,
                            borderRadius: const BorderRadius.only(
                              topRight: Radius.circular(10),
                              bottomRight: Radius.circular(10),
                            ),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.only(right: 5),
                            child: Align(
                              alignment: Alignment.centerRight,
                              child: Text(
                                "${maxTDay.toInt()}°",
                                style: TextStyle(
                                  color: globals
                                      .appColors[globals.turnDarkTheme]
                                      .textColorOnBackground,
                                  fontSize: 17.dp,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(
              height: height * 0.005,
            )
          ],
        ),
      );
    }

    return Column(
      children: daysWeather,
    );
  }
}
