import 'package:easyweather/pages/geolocation/page.dart';
import 'package:easyweather/pages/settings/page.dart';
import 'package:easyweather/pages/weather/page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_sizer/flutter_sizer.dart';
import 'package:easyweather/globals.dart' as globals;

void main() async {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  Future<void> configStorage() async {
    var storage = const FlutterSecureStorage();
    var turnDarkTheme = await storage.read(key: "turnDarkTheme");
    var showFahrenheit = await storage.read(key: "showFahrenheit");
    if (turnDarkTheme != null) {
      globals.turnDarkTheme = 0;
    }

    if (showFahrenheit != null) {
      globals.showFahrenheit = true;
    }
  }

  @override
  Widget build(BuildContext context) {
    return FlutterSizer(
      builder: (context, orientation, screenType) {
        return FutureBuilder(
          future: configStorage(),
          builder: (BuildContext context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
            return MaterialApp(
              title: 'Flutter Demo',
              theme: ThemeData(
                colorScheme: ColorScheme.fromSeed(
                  seedColor: Colors.black,
                  background:
                      globals.appColors[globals.turnDarkTheme].backgroundColor,
                ),
                useMaterial3: true,
              ),
              home: const MyHomePage(),
              debugShowCheckedModeBanner: false,
            );
          },
        );
      },
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _selectedIndex = 1;
  PageController pageControllerProvider = PageController(initialPage: 1);

  void _onItemTapped(int index) {
    pageControllerProvider.animateToPage(
      index,
      duration: const Duration(milliseconds: 800),
      curve: Curves.easeInOut,
    );
  }

  void reloadState() {
    setState(() {});
  }

  List<Widget> pages = [];

  @override
  Widget build(BuildContext context) {
    if (pages.isEmpty) {
      setState(() {
        pages = [
          CitySearchPage(
            pageController: pageControllerProvider,
          ),
          const WeatherPage(),
          SettingsPage(
            reloadState: reloadState,
          ),
        ];
      });
    }

    return Scaffold(
      backgroundColor: globals.appColors[globals.turnDarkTheme].backgroundColor,
      body: PageView(
        controller: pageControllerProvider,
        pageSnapping: true,
        onPageChanged: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        children: pages,
      ),
      resizeToAvoidBottomInset: false,
      bottomNavigationBar: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.location_on),
            label: "Locations",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.align_vertical_bottom_outlined),
            label: "Forecast",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: "Settings",
          ),
        ],
        onTap: _onItemTapped,
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.blue,
        unselectedItemColor: const Color.fromARGB(255, 143, 143, 143),
        backgroundColor:
            globals.appColors[globals.turnDarkTheme].backgroundColor,
      ),
    );
  }
}

class PageControllerProvider with ChangeNotifier {
  final PageController controller = PageController();

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }
}
