import 'package:flutter/material.dart';
import 'package:flutter_sizer/flutter_sizer.dart';
import 'package:easyweather/globals.dart' as globals;

class WeatherBottomPanel extends StatefulWidget {
  final String location;
  const WeatherBottomPanel({super.key, required this.location});

  @override
  State<WeatherBottomPanel> createState() => _WeatherBottomPanelState();
}

class _WeatherBottomPanelState extends State<WeatherBottomPanel> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: 3.h,
        ),
        SizedBox(
          width: 100.w,
          height: 4.h,
          child: Row(
            children: [
              SizedBox(
                width: 2.w,
              ),
              Text(
                widget.location,
                style: TextStyle(
                  color: globals.appColors[globals.turnDarkTheme].textColor,
                  fontSize: 20.dp,
                ),
              ),
            ],
          ),
        ),
        Divider(
          thickness: 0.3.h,
          indent: 1.h,
          endIndent: 1.h,
          height: 1,
        ),
      ],
    );
  }
}
