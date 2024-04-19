import 'package:easyweather/api/hello-weather/client.dart';
import 'package:easyweather/custom_widgets/pages_with_dots.dart';
import 'package:easyweather/utils/weather_icon.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_sizer/flutter_sizer.dart';
import 'package:easyweather/globals.dart' as globals;

class WeatherShortInfo extends StatefulWidget {
  final WeatherForecast weather;
  const WeatherShortInfo({super.key, required this.weather});

  @override
  State<WeatherShortInfo> createState() => _WeatherShortInfoState();
}

class _WeatherShortInfoState extends State<WeatherShortInfo> {
  double spaceWidth = 5.w;
  double spaceHeight = 1.5.h;
  double iconRadius = 5.w;
  TextStyle additionalyInfoStyle = TextStyle(
    color: globals.appColors[globals.turnDarkTheme].textColor,
    fontSize: 20.dp,
    fontWeight: FontWeight.w400,
  );

  @override
  Widget build(BuildContext context) {
    var weather = widget.weather.current;

    var currentT = globals.showFahrenheit
        ? widget.weather.current.tempF
        : widget.weather.current.tempC;

    var feelsT = globals.showFahrenheit
        ? widget.weather.current.feelslikeF
        : widget.weather.current.feelslikeC;

    return PagesWithDots(
      children: [
        Row(
          children: [
            SizedBox(
              width: 5.w,
            ),
            Animate(
              effects: const [
                FadeEffect(
                  duration: Duration(milliseconds: 600),
                  delay: Duration(milliseconds: 10),
                ),
              ],
              child: WeatherIcon(
                radius: 30.w,
                isDay: weather.isDay,
                icon: weather.condition.icon,
              ),
            ),
            SizedBox(
              width: 8.w,
            ),
            Column(
              children: [
                SizedBox(
                  height: 5.h,
                ),
                Animate(
                  effects: const [
                    FadeEffect(
                      duration: Duration(milliseconds: 900),
                      delay: Duration(milliseconds: 150),
                    ),
                  ],
                  child: Text(
                    "${currentT.toInt()}°",
                    style: TextStyle(
                      fontSize: 45.dp,
                      fontWeight: FontWeight.w700,
                      color: globals.appColors[globals.turnDarkTheme].textColor,
                    ),
                  ),
                ),
                Animate(
                  effects: const [
                    FadeEffect(
                      duration: Duration(milliseconds: 900),
                      delay: Duration(milliseconds: 300),
                    ),
                  ],
                  child: Text(
                    "Feels like ${feelsT.toInt()}°",
                    style: TextStyle(
                      fontSize: 20.dp,
                      fontWeight: FontWeight.w700,
                      color: globals.appColors[globals.turnDarkTheme].textColor,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
        Column(
          children: [
            SizedBox(
              height: spaceHeight,
            ),
            Animate(
              effects: const [
                FadeEffect(
                  duration: Duration(milliseconds: 600),
                  delay: Duration(
                    milliseconds: 200,
                  ),
                ),
              ],
              child: Row(
                children: [
                  SizedBox(
                    width: spaceWidth,
                  ),
                  Image.asset(
                    "images/wind.png",
                    width: iconRadius,
                    height: iconRadius,
                    color: globals.appColors[globals.turnDarkTheme].textColor,
                  ),
                  SizedBox(
                    width: spaceWidth,
                  ),
                  Text(
                    "${weather.windMph} m/h\nVisibility ${weather.visKm} kilometers.",
                    style: additionalyInfoStyle,
                  ),
                ],
              ),
            ),
            SizedBox(
              height: spaceHeight,
            ),
            Animate(
              effects: const [
                FadeEffect(
                  duration: Duration(milliseconds: 600),
                  delay: Duration(milliseconds: 500),
                ),
              ],
              child: Row(
                children: [
                  SizedBox(
                    width: spaceWidth,
                  ),
                  Image.asset(
                    "images/humidity.png",
                    width: iconRadius,
                    height: iconRadius,
                  ),
                  SizedBox(
                    width: spaceWidth,
                  ),
                  Text(
                    "Humidity ${weather.humidity}%",
                    style: additionalyInfoStyle,
                  ),
                ],
              ),
            ),
            SizedBox(
              height: spaceHeight,
            ),
            Animate(
              effects: const [
                FadeEffect(
                  duration: Duration(milliseconds: 600),
                  delay: Duration(milliseconds: 1000),
                ),
              ],
              child: Row(
                children: [
                  SizedBox(
                    width: spaceWidth,
                  ),
                  Image.asset(
                    "images/pressure.png",
                    width: iconRadius,
                    height: iconRadius,
                  ),
                  SizedBox(
                    width: spaceWidth,
                  ),
                  Text(
                    "Pressure ${weather.pressureMb} hPa",
                    style: additionalyInfoStyle,
                  ),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }
}
