import 'package:flutter/material.dart';
import 'package:easyweather/globals.dart' as globals;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_sizer/flutter_sizer.dart';

class SettingsPage extends StatefulWidget {
  final Function reloadState;
  const SettingsPage({super.key, required this.reloadState});

  @override
  State<SettingsPage> createState() => _LocationPageState();
}

class _LocationPageState extends State<SettingsPage> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Align(
          alignment: Alignment.topLeft,
          child: Padding(
            padding: const EdgeInsets.only(top: 25, left: 15),
            child: Text(
              "Settings",
              style: TextStyle(
                color: globals.appColors[globals.turnDarkTheme].textColor,
                fontSize: 25.dp,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ),
        SizedBox(
          height: 5.h,
        ),
        Row(
          children: [
            SizedBox(
              width: 3.w,
            ),
            Text(
              "Show weather in Fahrenheit",
              style: TextStyle(
                color: globals.appColors[globals.turnDarkTheme].textColor,
                fontSize: 22.dp,
                fontWeight: FontWeight.w400,
              ),
            ),
            const Spacer(),
            Switch(
              value: globals.showFahrenheit,
              onChanged: (value) async {
                var storage = const FlutterSecureStorage();
                if (value) {
                  await storage.write(key: "showFahrenheit", value: "1");
                } else {
                  await storage.write(key: "showFahrenheit", value: null);
                }
                setState(() {
                  globals.showFahrenheit = value;
                });
              },
              activeColor:
                  globals.appColors[globals.turnDarkTheme].switchActiveColor,
            ),
          ],
        ),
        Row(
          children: [
            SizedBox(
              width: 3.w,
            ),
            Text(
              "Turn on the dark theme",
              style: TextStyle(
                color: globals.appColors[globals.turnDarkTheme].textColor,
                fontSize: 22.dp,
                fontWeight: FontWeight.w400,
              ),
            ),
            const Spacer(),
            Switch(
              value: globals.turnDarkTheme == 1 ? true : false,
              onChanged: (value) async {
                int turn = 0;
                if (value) {
                  turn = 1;
                }
                var storage = const FlutterSecureStorage();
                if (value) {
                  await storage.write(key: "turnDarkTheme", value: "1");
                } else {
                  await storage.write(key: "showFahrenheit", value: null);
                }
                widget.reloadState();
                setState(() {
                  globals.turnDarkTheme = turn;
                });
              },
              activeColor:
                  globals.appColors[globals.turnDarkTheme].switchActiveColor,
              thumbIcon: globals.turnDarkTheme == 0
                  ? MaterialStateProperty.all(
                      const Icon(
                        Icons.sunny,
                      ),
                    )
                  : MaterialStateProperty.all(
                      const Icon(
                        Icons.dark_mode,
                      ),
                    ),
            ),
          ],
        ),
      ],
    );
  }
}
