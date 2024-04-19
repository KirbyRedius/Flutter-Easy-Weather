import 'package:http/http.dart' as http;
import 'dart:convert';

class ApiOptions {
  String baseUrl = "https://freeipapi.com/api/json";
  Map<String, String> headers = {"User-Agent": "Ip Api Client"};
}

class IpApiClient {
  ApiOptions options = ApiOptions();

  Future<dynamic> request(String path) async {
    var url = Uri.parse('${options.baseUrl}/$path');

    try {
      var response = await http.get(
        url,
        headers: options.headers,
      );
      return jsonDecode(response.body);
    } catch (error) {}
  }

  Future<IpData> getIpInfo(String ip) async {
    var data = await request(ip);
    return IpData.fromJson(data);
  }

  Future<IpData> getMyIpInfo() async {
    var data = await request("");
    return IpData.fromJson(data);
  }
}

class IpData {
  final int ipVersion;
  final String ipAddress;
  final double latitude;
  final double longitude;
  final String countryName;
  final String countryCode;
  final String timeZone;
  final String zipCode;
  final String cityName;
  final String regionName;
  final String continent;
  final String continentCode;
  final bool isProxy;

  IpData({
    required this.ipVersion,
    required this.ipAddress,
    required this.latitude,
    required this.longitude,
    required this.countryName,
    required this.countryCode,
    required this.timeZone,
    required this.zipCode,
    required this.cityName,
    required this.regionName,
    required this.continent,
    required this.continentCode,
    required this.isProxy,
  });

  factory IpData.fromJson(Map<String, dynamic> data) {
    return IpData(
        ipVersion: data['ipVersion'],
        ipAddress: data['ipAddress'],
        latitude: data['latitude'],
        longitude: data['longitude'],
        countryName: data['countryName'],
        countryCode: data['countryCode'],
        timeZone: data['timeZone'],
        zipCode: data['zipCode'],
        cityName: data['cityName'],
        regionName: data['regionName'],
        continent: data['continent'],
        continentCode: data['continentCode'],
        isProxy: data['isProxy']);
  }
}
