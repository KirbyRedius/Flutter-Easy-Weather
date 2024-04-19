import 'package:easyweather/api/hello-weather/client.dart';
import 'package:easyweather/utils/weather_icon.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_sizer/flutter_sizer.dart';
import 'package:intl/intl.dart';
import 'package:easyweather/globals.dart' as globals;

class WeatherByHours extends StatefulWidget {
  final List<Hour> hours;
  final double minT;
  final double maxT;
  final PageController? pageController;

  const WeatherByHours(
      {super.key,
      required this.hours,
      required this.minT,
      required this.maxT,
      this.pageController});
  @override
  State<WeatherByHours> createState() => _WeatherByHoursState();
}

class _WeatherByHoursState extends State<WeatherByHours> {
  bool reverseAnimation = false;

  @override
  Widget build(BuildContext context) {
    List<Widget> hoursWeather = [];
    double maxT = widget.maxT;
    double minT = widget.minT;

    double height = MediaQuery.of(context).size.height;

    double spaceWidth = MediaQuery.of(context).size.width * 0.01;

    int hoursAdded = 0;
    int duration = 250;
    int prirost = 150;

    int maxPrirost = prirost * widget.hours.length;

    if (widget.pageController!.position.haveDimensions) {
      if (widget.pageController!.page! > 0.5) {
        reverseAnimation = true;
      } else {
        reverseAnimation = false;
      }
    }

    for (Hour hour in widget.hours) {
      int temp;
      if (globals.showFahrenheit) {
        temp = hour.tempF.toInt();
      } else {
        temp = hour.tempC.toInt();
      }

      int delay = reverseAnimation
          ? maxPrirost - prirost * hoursAdded
          : prirost * hoursAdded;
      int hourInt = DateFormat("yyyy-MM-dd HH:mm").parse(hour.time).hour;
      var hourString = hourInt.toString();
      if (hourString.length == 1) {
        hourString = "0$hourString";
      }
      hourString = "$hourString:00";
      hoursWeather.add(
        Container(
          width: MediaQuery.of(context).size.width / 8 - spaceWidth * 1,
          height: MediaQuery.of(context).size.height,
          alignment: Alignment.bottomCenter,
          child: Animate(
            effects: [
              FadeEffect(
                duration: Duration(milliseconds: duration),
                delay: Duration(milliseconds: delay),
                curve: Curves.linear,
              ),
            ],
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Container(
                  width: MediaQuery.of(context).size.width,
                  height: (height / 12) +
                      (temp - minT) / (maxT - minT) * (height / 20),
                  decoration: BoxDecoration(
                    color: globals
                        .appColors[globals.turnDarkTheme].hourWeatherColor,
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Column(
                    children: [
                      Align(
                        alignment: Alignment.topCenter,
                        child: Text(
                          "$temp°",
                          style: TextStyle(
                            color: globals.appColors[globals.turnDarkTheme]
                                .textColorOnBackground,
                            fontSize: 20.dp,
                          ),
                        ),
                      ),
                      const Spacer(),
                      Text(
                        hour.windMph.toString(),
                        style: TextStyle(
                          color: globals.appColors[globals.turnDarkTheme]
                              .textColorOnBackground,
                          fontSize: 15.dp,
                          height: 0,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      Text(
                        "m/h",
                        style: TextStyle(
                          color: globals.appColors[globals.turnDarkTheme]
                              .textColorOnBackground,
                          fontSize: 10.dp,
                          height: 0,
                        ),
                        textAlign: TextAlign.center,
                        softWrap: true,
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.006,
                ),
                Center(
                  child: Text(
                    hourString,
                    style: TextStyle(
                      color: globals.appColors[globals.turnDarkTheme].textColor,
                      fontSize: 14.dp,
                    ),
                  ),
                ),
                Center(
                  child: WeatherIcon(
                    radius: 7.w,
                    isDay: hour.isDay,
                    icon: hour.condition.icon,
                  ),
                ),
              ],
            ),
          ),
        ),
      );
      hoursAdded += 1;
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: hoursWeather,
    );
  }
}


// class WeatherByHours extends StatefulWidget {
//   final List<Hour> hours;

//   const WeatherByHours({super.key, required this.hours});
//   @override
//   State<WeatherByHours> createState() => _WeatherByHoursState();
// }

// class _WeatherByHoursState extends State<WeatherByHours> {
//   @override
//   Widget build(BuildContext context) {
//     print(widget.hours);

//     List<Widget> hoursWeather = [];

//     // double maxC = -99;
//     // for (Hour hour in widget.hours) {
//     //   if (hour.tempC > maxC) {
//     //     maxC = hour.tempC;
//     //   }
//     // }
//     double maxC = widget.hours.map((h) => h.tempC).reduce(max);
//     double minC = widget.hours.map((h) => h.tempC).reduce(min);

//     double spaceWidth = MediaQuery.of(context).size.width * 0.01;
//     for (Hour hour in widget.hours) {
//       int hourInt = DateFormat("yyyy-MM-dd HH:mm").parse(hour.time).hour;
//       var hourString = hourInt.toString();
//       if (hourString.length == 1) {
//         hourString = "0$hourString";
//       }
//       hourString = "$hourString:00";

//       hoursWeather.add(
//         Container(
//           width: MediaQuery.of(context).size.width / 8 - spaceWidth * 1,
//           height: MediaQuery.of(context).size.height,
//           alignment: Alignment.bottomCenter,
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.end,
//             children: [
//               Container(
//                 width: MediaQuery.of(context).size.width,
//                 height: MediaQuery.of(context).size.height *
//                     (hour.tempC / maxC) /
//                     8,
//                 decoration: BoxDecoration(
//                   color: Color.fromARGB(255, 0, 247, 255),
//                   borderRadius: BorderRadius.circular(4),
//                 ),
//                 child: Column(
//                   children: [
//                     Align(
//                       alignment: Alignment.topCenter,
//                       child: Text(
//                         "${hour.tempC.toInt()}°",
//                         style: TextStyle(
//                           color: const Color.fromARGB(255, 0, 0, 0),
//                           fontSize: 20.dp,
//                         ),
//                       ),
//                     ),
//                     Text(
//                       hour.windMph.toString(),
//                       style: TextStyle(
//                         color: const Color.fromARGB(255, 0, 0, 0),
//                         fontSize: 15.dp,
//                         height: 0,
//                       ),
//                       textAlign: TextAlign.center,
//                     ),
//                     Text(
//                       "m/h",
//                       style: TextStyle(
//                           color: const Color.fromARGB(255, 0, 0, 0),
//                           fontSize: 10.dp,
//                           height: 0),
//                       textAlign: TextAlign.center,
//                       softWrap: true,
//                     ),
//                   ],
//                 ),
//               ),
//               SizedBox(
//                 height: MediaQuery.of(context).size.height * 0.006,
//               ),
//               Center(
//                 child: Text(
//                   hourString,
//                   style: TextStyle(
//                     color: Colors.white,
//                     fontSize: 14.dp,
//                   ),
//                 ),
//               ),
//               Center(
//                 child: WeatherIcon(
//                   radius: MediaQuery.of(context).size.width * 0.08,
//                   isDay: hour.isDay,
//                   icon: hour.condition.icon,
//                 ),
//               ),
//             ],
//           ),
//         ),
//       );
//     }

//     return Row(
//       mainAxisAlignment: MainAxisAlignment.spaceAround,
//       children: hoursWeather,
//     );
//   }
// }
