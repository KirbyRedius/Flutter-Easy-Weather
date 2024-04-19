import 'package:easyweather/api/hello-weather/client.dart';
import 'package:easyweather/pages/weather/soon_weather_info.dart';
import 'package:easyweather/pages/weather/weather_by_days.dart';
import 'package:easyweather/pages/weather/weather_short_info.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_sizer/flutter_sizer.dart';
import 'package:easyweather/globals.dart' as globals;

class WeatherShow extends StatefulWidget {
  final String city;
  const WeatherShow({super.key, required this.city});

  @override
  State<WeatherShow> createState() => _WeatherShowState();
}

class _WeatherShowState extends State<WeatherShow> {
  WeatherForecast? weather;

  Future<void> updateWeatherInfo(bool force) async {
    if (weather == null || force) {
      HelloWeatherClient weatherClient = HelloWeatherClient();
      WeatherForecast _weather =
          await weatherClient.getForecast(widget.city, 7);
      setState(() {
        weather = _weather;
      });
    }
  }

  Future<void> userAskUpdateWeather() async {
    await updateWeatherInfo(true);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: updateWeatherInfo(false),
      builder: (BuildContext context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else {
          return RefreshIndicator(
            onRefresh: userAskUpdateWeather,
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Container(
                    margin: const EdgeInsets.only(
                      left: 10,
                    ),
                    alignment: Alignment.centerLeft,
                    child: Animate(
                      effects: const [
                        FadeEffect(
                          duration: Duration(milliseconds: 900),
                          delay: Duration(milliseconds: 50),
                        ),
                      ],
                      child: Text(
                        "Right now",
                        style: TextStyle(
                          color: globals
                              .appColors[globals.turnDarkTheme].textColor,
                          fontSize: 30.dp,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.only(
                      left: 10,
                    ),
                    alignment: Alignment.centerLeft,
                    child: Animate(
                      effects: const [
                        FadeEffect(
                          duration: Duration(milliseconds: 900),
                          delay: Duration(milliseconds: 150),
                        ),
                      ],
                      child: Text(
                        weather!.current.condition.text,
                        style: TextStyle(
                          color: globals
                              .appColors[globals.turnDarkTheme].textColor,
                          fontSize: 20.dp,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 100.w,
                    height: 25.h,
                    child: WeatherShortInfo(
                      weather: weather!,
                    ),
                  ),
                  SizedBox(
                    height: 5.h,
                  ),
                  Container(
                    margin: const EdgeInsets.only(
                      left: 10,
                    ),
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "In the coming hours",
                      style: TextStyle(
                        color:
                            globals.appColors[globals.turnDarkTheme].textColor,
                        fontSize: 30.dp,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  SizedBox(
                    width: 100.w,
                    height: 25.h,
                    child: SoonWeatherInfo(
                      weather: weather!,
                    ),
                  ),
                  SizedBox(
                    height: 5.h,
                  ),
                  Container(
                    margin: const EdgeInsets.only(
                      left: 10,
                    ),
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "This week",
                      style: TextStyle(
                        color:
                            globals.appColors[globals.turnDarkTheme].textColor,
                        fontSize: 30.dp,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  SizedBox(
                    height: 2.h,
                  ),
                  SizedBox(
                    width: 100.w,
                    height: 45.h,
                    child: WeatherByDays(
                      weather: weather!,
                    ),
                  ),
                  SizedBox(
                    height: 1.h,
                  ),
                ],
              ),
            ),
          );
        }
      },
    );
  }
}
