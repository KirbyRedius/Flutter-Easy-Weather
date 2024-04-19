// ignore_for_file: prefer_const_constructors

import 'package:easyweather/api/ipapi/client.dart';
import 'package:easyweather/pages/weather/bottom_panel.dart';
import 'package:easyweather/pages/weather/weather_show.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_sizer/flutter_sizer.dart';
import 'package:geolocator/geolocator.dart';

class WeatherPage extends StatefulWidget {
  const WeatherPage({super.key});

  @override
  State<WeatherPage> createState() => _WeatherPageState();
}

/// проверить сохранённый город
/// попробовать определить город по ip + запросить геолокацию
/// если дали геолокацию то сохраним город по геолокации

class _WeatherPageState extends State<WeatherPage> {
  var storage = FlutterSecureStorage();

  Future<Position?> _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Test if location services are enabled.
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

    // Permissions are granted, so we can continue accessing the position.
    return await Geolocator.getCurrentPosition();
  }

  Future<String> getSavedCityOrUpdate() async {
    var position = await storage.read(key: "position");
    var savedCity = await storage.read(key: "city");
    var savedCityType = await storage.read(key: "cityType");

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
      return posString;
    }

    IpApiClient ipApiClient = IpApiClient();
    IpData ipData = await ipApiClient.getMyIpInfo();
    await storage.write(key: "city", value: ipData.cityName);
    await storage.write(key: "cityType", value: "auto");
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
          return Center(child: Text('Error: ${snapshot.error}'));
        } else {
          String city = snapshot.data ?? "";
          return Column(
            children: [
              WeatherBottomPanel(city: city),
              Expanded(
                child: WeatherShow(
                  city: city,
                ),
              ),
            ],
          );
        }
      },
    );
  }
}
