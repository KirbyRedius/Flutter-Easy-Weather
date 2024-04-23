import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiOptions {
  String baseUrl = "api.weatherapi.com";
  String apiDefaultPath = "/v1/";
  Map<String, String> headers = {
    "User-Agent": "Hello Weather Client",
    "Content-type": "application/json; charset=utf-8"
  };
  String apiKey = "cca8f0cfbc084206b0a94750242304";
}

class HelloWeatherClient {
  ApiOptions options = ApiOptions();

  Future<dynamic> request(String path, Map<String, dynamic> params) async {
    params.addAll({"key": options.apiKey});

    String fullPath = options.apiDefaultPath + path;

    final url = Uri.https(options.baseUrl, fullPath, params);
    print(url);
    var response = await http.get(
      url,
      headers: options.headers,
    );

    return json.decode(utf8.decode(response.bodyBytes));
  }

  Future<dynamic> getRealTimeWeather(String city) async {
    Map<String, dynamic> params = {"q": city};
    var data = await request("current.json", params);
    return Weather.fromJson(data);
  }

  Future<dynamic> getForecast(String city, int days) async {
    Map<String, dynamic> params = {"q": city, "days": days.toString()};

    var data = await request("forecast.json", params);
    List test = [];
    for (var t in data["forecast"]["forecastday"]) {
      test.add(t);
    }
    print("testtttt ${test.length}");
    return WeatherForecast.fromJson(data);
  }

  Future<List<City>> search(String city) async {
    Map<String, dynamic> params = {"q": city};
    var data = await request("search.json", params);
    List<City> cities = [];
    for (var city in data) {
      cities.add(City.fromJson(city));
    }
    return cities;
  }
}

class Weather {
  final Location location;
  final Current current;

  Weather({required this.location, required this.current});

  factory Weather.fromJson(Map<String, dynamic> json) {
    return Weather(
      location: Location.fromJson(json['location']),
      current: Current.fromJson(json['current']),
    );
  }
}

class City {
  final int id;
  final String name;
  final String region;
  final String country;
  final double lat;
  final double lon;
  final String url;

  City({
    required this.id,
    required this.name,
    required this.region,
    required this.country,
    required this.lat,
    required this.lon,
    required this.url,
  });

  factory City.fromJson(Map<String, dynamic> json) {
    return City(
      id: json['id'],
      name: json['name'],
      region: json['region'],
      country: json['country'],
      lat: json['lat'],
      lon: json['lon'],
      url: json['url'],
    );
  }
}

class WeatherForecast {
  final Location location;
  final Current current;
  final Forecast forecast;

  WeatherForecast(
      {required this.location, required this.current, required this.forecast});

  factory WeatherForecast.fromJson(Map<String, dynamic> json) {
    return WeatherForecast(
        location: Location.fromJson(json['location']),
        current: Current.fromJson(json['current']),
        forecast: Forecast.fromJson(json['forecast']));
  }
}

class Forecast {
  final List<ForecastDay> forecastDay;

  Forecast({required this.forecastDay});

  factory Forecast.fromJson(Map<String, dynamic> json) {
    List<ForecastDay> forecastDayNew = [];
    for (var day in json['forecastday']) {
      print("testt");
      print(day);
      forecastDayNew.add(ForecastDay.fromJson(day));
    }
    return Forecast(forecastDay: forecastDayNew);
  }
}

class ForecastDay {
  final String date;
  final int dateEpoch;
  final Day day;
  final List<Hour> hours;

  ForecastDay({
    required this.date,
    required this.dateEpoch,
    required this.day,
    required this.hours,
  });

  factory ForecastDay.fromJson(Map<String, dynamic> json) {
    List<Hour> hours = [];
    for (var day in json['hour']) {
      hours.add(Hour.fromJson(day));
    }

    return ForecastDay(
        date: json['date'],
        dateEpoch: json['date_epoch'],
        day: Day.fromJson(json['day']),
        hours: hours);
  }
}

class Hour {
  final int timeEpoch;
  final String time;
  final double tempC;
  final double tempF;
  final int isDay;
  final double windMph;
  final double windKph;
  final int windDegree;
  final String windDir;
  final double pressureMb;
  final double pressureIn;
  final double precipMm;
  final double precipIn;
  final double snowCm;
  final int humidity;
  final int cloud;
  final double feelslikeC;
  final double feelslikeF;
  final double windchillC;
  final double windchillF;
  final double heatindexC;
  final double heatindexF;
  final double dewpointC;
  final double dewpointF;
  final int willItRain;
  final int chanceOfRain;
  final int willItSnow;
  final int chanceOfSnow;
  final double visKm;
  final double visMiles;
  final double gustMph;
  final double gustKph;
  final double uv;
  final Condition condition;

  Hour(
      {required this.timeEpoch,
      required this.time,
      required this.tempC,
      required this.tempF,
      required this.isDay,
      required this.windMph,
      required this.windKph,
      required this.windDegree,
      required this.windDir,
      required this.pressureMb,
      required this.pressureIn,
      required this.precipMm,
      required this.precipIn,
      required this.snowCm,
      required this.humidity,
      required this.cloud,
      required this.feelslikeC,
      required this.feelslikeF,
      required this.windchillC,
      required this.windchillF,
      required this.heatindexC,
      required this.heatindexF,
      required this.dewpointC,
      required this.dewpointF,
      required this.willItRain,
      required this.chanceOfRain,
      required this.willItSnow,
      required this.chanceOfSnow,
      required this.visKm,
      required this.visMiles,
      required this.gustMph,
      required this.gustKph,
      required this.uv,
      required this.condition});

  factory Hour.fromJson(Map<String, dynamic> json) {
    return Hour(
        timeEpoch: json['time_epoch'],
        time: json['time'],
        tempC: json['temp_c'],
        tempF: json['temp_f'],
        isDay: json['is_day'],
        windMph: json['wind_mph'],
        windKph: json['wind_kph'],
        windDegree: json['wind_degree'],
        windDir: json['wind_dir'],
        pressureMb: json['pressure_mb'],
        pressureIn: json['pressure_in'],
        precipMm: json['precip_mm'],
        precipIn: json['precip_in'],
        snowCm: json['snow_cm'],
        humidity: json['humidity'],
        cloud: json['cloud'],
        feelslikeC: json['feelslike_c'],
        feelslikeF: json['feelslike_f'],
        windchillC: json['windchill_c'],
        windchillF: json['windchill_f'],
        heatindexC: json['heatindex_c'],
        heatindexF: json['heatindex_f'],
        dewpointC: json['dewpoint_c'],
        dewpointF: json['dewpoint_f'],
        willItRain: json['will_it_rain'],
        chanceOfRain: json['chance_of_rain'],
        willItSnow: json['will_it_snow'],
        chanceOfSnow: json['chance_of_snow'],
        visKm: json['vis_km'],
        visMiles: json['vis_miles'],
        gustMph: json['gust_mph'],
        gustKph: json['gust_kph'],
        uv: json['uv'],
        condition: Condition.fromJson(json["condition"]));
  }
}

class Day {
  final double maxtempC;
  final double maxtempF;
  final double mintempC;
  final double mintempF;
  final double avgtempC;
  final double avgtempF;
  final double maxwindMph;
  final double maxwindKph;
  final double totalprecipMm;
  final double totalprecipIn;
  final double totalsnowCm;
  final double avgvisKm;
  final double avgvisMiles;
  final double uv;
  final int avghumidity;
  final int dailyWillItRain;
  final int dailyChanceOfRain;
  final int dailyWillItSnow;
  final int dailyChanceOfSnow;
  final Condition condition;

  Day({
    required this.maxtempC,
    required this.maxtempF,
    required this.mintempC,
    required this.mintempF,
    required this.avgtempC,
    required this.avgtempF,
    required this.maxwindMph,
    required this.maxwindKph,
    required this.totalprecipMm,
    required this.totalprecipIn,
    required this.totalsnowCm,
    required this.avgvisKm,
    required this.avgvisMiles,
    required this.uv,
    required this.avghumidity,
    required this.dailyWillItRain,
    required this.dailyChanceOfRain,
    required this.dailyWillItSnow,
    required this.dailyChanceOfSnow,
    required this.condition,
  });

  factory Day.fromJson(Map<String, dynamic> json) {
    return Day(
      maxtempC: json['maxtemp_c'],
      maxtempF: json['maxtemp_f'],
      mintempC: json['mintemp_c'],
      mintempF: json['mintemp_f'],
      avgtempC: json['avgtemp_c'],
      avgtempF: json['avgtemp_f'],
      maxwindMph: json['maxwind_mph'],
      maxwindKph: json['maxwind_kph'],
      totalprecipMm: json['totalprecip_mm'],
      totalprecipIn: json['totalprecip_in'],
      totalsnowCm: json['totalsnow_cm'],
      avgvisKm: json['avgvis_km'],
      avgvisMiles: json['avgvis_miles'],
      uv: json['uv'],
      avghumidity: json['avghumidity'],
      dailyWillItRain: json['daily_will_it_rain'],
      dailyChanceOfRain: json['daily_chance_of_rain'],
      dailyWillItSnow: json['daily_will_it_snow'],
      dailyChanceOfSnow: json['daily_chance_of_snow'],
      condition: Condition.fromJson(json['condition']),
    );
  }
}

class Location {
  final String name;
  final String region;
  final String country;
  final double lat;
  final double lon;
  final String tzId;
  final int localtimeEpoch;
  final String localtime;

  Location(
      {required this.name,
      required this.region,
      required this.country,
      required this.lat,
      required this.lon,
      required this.tzId,
      required this.localtimeEpoch,
      required this.localtime});

  factory Location.fromJson(Map<String, dynamic> json) {
    return Location(
      name: json['name'],
      region: json['region'],
      country: json['country'],
      lat: json['lat'],
      lon: json['lon'],
      tzId: json['tz_id'],
      localtimeEpoch: json['localtime_epoch'],
      localtime: json['localtime'],
    );
  }
}

class Current {
  final int lastUpdatedEpoch;
  final String lastUpdated;
  final double tempC;
  final double tempF;
  final int isDay;
  final Condition condition;
  final double windMph;
  final double windKph;
  final int windDegree;
  final String windDir;
  final double pressureMb;
  final double pressureIn;
  final double precipMm;
  final double precipIn;
  final int humidity;
  final int cloud;
  final double feelslikeC;
  final double feelslikeF;
  final double visKm;
  final double visMiles;
  final double uv;
  final double gustMph;
  final double gustKph;

  Current({
    required this.lastUpdatedEpoch,
    required this.lastUpdated,
    required this.tempC,
    required this.tempF,
    required this.isDay,
    required this.condition,
    required this.windMph,
    required this.windKph,
    required this.windDegree,
    required this.windDir,
    required this.pressureMb,
    required this.pressureIn,
    required this.precipMm,
    required this.precipIn,
    required this.humidity,
    required this.cloud,
    required this.feelslikeC,
    required this.feelslikeF,
    required this.visKm,
    required this.visMiles,
    required this.uv,
    required this.gustMph,
    required this.gustKph,
  });

  factory Current.fromJson(Map<String, dynamic> json) {
    return Current(
      lastUpdatedEpoch: json['last_updated_epoch'],
      lastUpdated: json['last_updated'],
      tempC: json['temp_c'],
      tempF: json['temp_f'],
      isDay: json['is_day'],
      condition: Condition.fromJson(json['condition']),
      windMph: json['wind_mph'],
      windKph: json['wind_kph'],
      windDegree: json['wind_degree'],
      windDir: json['wind_dir'],
      pressureMb: json['pressure_mb'],
      pressureIn: json['pressure_in'],
      precipMm: json['precip_mm'],
      precipIn: json['precip_in'],
      humidity: json['humidity'],
      cloud: json['cloud'],
      feelslikeC: json['feelslike_c'],
      feelslikeF: json['feelslike_f'],
      visKm: json['vis_km'],
      visMiles: json['vis_miles'],
      uv: json['uv'],
      gustMph: json['gust_mph'],
      gustKph: json['gust_kph'],
    );
  }
}

class Condition {
  final String text;
  final String icon;
  final int code;

  Condition({required this.text, required this.icon, required this.code});

  factory Condition.fromJson(Map<String, dynamic> json) {
    return Condition(
      text: json['text'],
      icon: json['icon'],
      code: json['code'],
    );
  }
}
