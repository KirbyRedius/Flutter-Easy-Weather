// ignore_for_file: prefer_const_constructors

import 'package:easyweather/api/ipapi/client.dart';
import 'package:easyweather/pages/weather/bottom_panel.dart';
import 'package:easyweather/pages/weather/weather_show.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_sizer/flutter_sizer.dart';
import 'package:geolocator/geolocator.dart';
import 'package:easyweather/globals.dart' as globals;

class WeatherPage extends StatefulWidget {
  const WeatherPage({super.key});

  @override
  State<WeatherPage> createState() => _WeatherPageState();
}

// проверить сохранённый город
// попробовать определить город по ip + запросить геолокацию
// если дали геолокацию то сохраним город по геолокации

class _WeatherPageState extends State<WeatherPage> {
  var storage = FlutterSecureStorage();
  String? locationType;

  Future<Position?> _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return null;
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return null;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return null;
    }

    return await Geolocator.getCurrentPosition();
  }

  Future<String> getSavedCityOrUpdate() async {
    var position = await storage.read(key: "position");
    var savedCity = await storage.read(key: "city");

    // если уже есть сохранённый город - вернём его
    // если нет, то:
    // просим геолокацию, при отказе определим IP и город по нему

    if (savedCity != null) {
      return savedCity;
    }
    if (position != null) {
      return position;
    }
    Position? pos = await _determinePosition();
    if (pos != null) {
      String posString = "${pos.latitude},${pos.longitude}";
      await storage.write(key: "position", value: posString);
      locationType = "position";
      return posString;
    }

    IpApiClient ipApiClient = IpApiClient();
    IpData ipData = await ipApiClient.getMyIpInfo();
    await storage.write(key: "city", value: ipData.cityName);
    locationType = "city";
    return ipData.cityName;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: getSavedCityOrUpdate(),
      builder: (BuildContext context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child: CircularProgressIndicator(),
          );
        } else if (snapshot.hasError) {
          return Center(
            child: Text(
              'Произошла ошибка\n👾 👾 👾',
              style: TextStyle(
                color: globals.appColors[globals.turnDarkTheme].textColor,
                fontSize: 25.dp,
              ),
              textAlign: TextAlign.center,
            ),
          );
        } else {
          String location = snapshot.data ?? "";
          String cityName = location;
          if (locationType == "position") {
            cityName = "Your geolocation";
          }
          return Column(
            children: [
              WeatherBottomPanel(location: cityName),
              Expanded(
                child: WeatherShow(
                  location: location,
                ),
              ),
            ],
          );
        }
      },
    );
  }
}
