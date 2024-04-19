import 'dart:math';

import 'package:easyweather/api/hello-weather/client.dart';
import 'package:easyweather/custom_widgets/pages_with_dots.dart';
import 'package:easyweather/pages/weather/weather_by_hours.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:easyweather/globals.dart' as globals;

class SoonWeatherInfo extends StatefulWidget {
  final WeatherForecast weather;
  const SoonWeatherInfo({super.key, required this.weather});

  @override
  State<SoonWeatherInfo> createState() => _SoonWeatherInfoState();
}

class _SoonWeatherInfoState extends State<SoonWeatherInfo> {
  @override
  Widget build(BuildContext context) {
    DateTime dateTime =
        DateFormat("yyyy-MM-dd HH:mm").parse(widget.weather.location.localtime);
    int localHour = dateTime.hour;
    List<Hour> hours = [];
    int _startIndex = 0;
    for (Hour hourForecast in widget.weather.forecast.forecastDay[0].hours) {
      if (DateTime.parse(hourForecast.time).hour != localHour) {
        _startIndex += 1;
      } else {
        break;
      }
    }

    int dayIndex = 0;
    while (hours.length < 17) {
      hours.add(
          widget.weather.forecast.forecastDay[dayIndex].hours[_startIndex]);
      _startIndex += 1;
      if (_startIndex ==
          widget.weather.forecast.forecastDay[dayIndex].hours.length) {
        dayIndex += 1;
        _startIndex = 0;
      }
    }

    double minT, maxT;

    if (globals.showFahrenheit) {
      minT = hours.map((h) => h.tempF).reduce(min);
      maxT = hours.map((h) => h.tempF).reduce(max);
    } else {
      minT = hours.map((h) => h.tempC).reduce(min);
      maxT = hours.map((h) => h.tempC).reduce(max);
    }

    PageController pageController = PageController();
    return PagesWithDots(
      pageController: pageController,
      children: [
        WeatherByHours(
          hours: hours.sublist(0, 8),
          minT: minT,
          maxT: maxT,
          pageController: pageController,
        ),
        WeatherByHours(
          hours: hours.sublist(8, 16),
          minT: minT,
          maxT: maxT,
          pageController: pageController,
        ),
      ],
    );
  }
}
