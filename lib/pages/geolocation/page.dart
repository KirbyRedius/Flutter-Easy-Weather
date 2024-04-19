import 'package:easyweather/api/hello-weather/client.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_sizer/flutter_sizer.dart';
import 'package:easyweather/globals.dart' as globals;

class CitySearchPage extends StatefulWidget {
  final PageController pageController;

  const CitySearchPage({super.key, required this.pageController});

  @override
  State<CitySearchPage> createState() => _CitySearchPageState();
}

class _CitySearchPageState extends State<CitySearchPage> {
  List<City> cities = []; // Здесь храните список городов
  HelloWeatherClient weatherClient = HelloWeatherClient();

  Future<void> getCities(String query) async {
    if (query.isNotEmpty) {
      var _cities = await weatherClient.search(query);

      setState(() {
        cities = _cities;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    TextStyle citiesStyle = TextStyle(
      color: globals.appColors[globals.turnDarkTheme].textColor,
      fontSize: 15.dp,
      fontWeight: FontWeight.w500,
    );

    return Column(
      children: [
        Align(
          alignment: Alignment.topLeft,
          child: Padding(
            padding: const EdgeInsets.only(top: 25, left: 15),
            child: Text(
              "Locations",
              style: TextStyle(
                color: globals.appColors[globals.turnDarkTheme].textColor,
                fontSize: 25.dp,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(10),
          child: TextField(
            onChanged: getCities,
            decoration: InputDecoration(
              hintText: 'Search cities',
              hintStyle: TextStyle(
                color: globals.appColors[globals.turnDarkTheme].textColor,
              ),
              border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide(
                      width: 11,
                      color:
                          globals.appColors[globals.turnDarkTheme].textColor)),
            ),
            style: TextStyle(
              color: globals.appColors[globals.turnDarkTheme].textColor,
              fontSize: 18.dp,
            ),
          ),
        ),
        Expanded(
          child: ListView.builder(
            itemCount: cities.length,
            itemBuilder: (context, index) {
              final city = cities[index];
              return ListTile(
                title: Text(
                  city.name,
                  style: citiesStyle,
                ),
                subtitle: Text(
                  '${city.region}, ${city.country}',
                  style: citiesStyle,
                ),
                onTap: () async {
                  var storage = const FlutterSecureStorage();
                  await storage.write(key: "city", value: city.name);
                  await storage.write(key: "cityType", value: "choosed");
                  FocusManager.instance.primaryFocus?.unfocus();
                  widget.pageController.animateToPage(
                    1,
                    duration: const Duration(milliseconds: 650),
                    curve: Curves.linear,
                  );
                },
              );
            },
          ),
        ),
      ],
    );
  }
}
