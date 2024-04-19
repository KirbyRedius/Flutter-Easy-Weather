
// import 'package:chai_web/pages/main_page/waiting_page.dart';
// import 'package:chai_web/pages/welcome_page/page.dart';
// import 'package:flutter/material.dart';
// import 'package:hive/hive.dart';
// import 'package:requests/requests.dart';
// import 'exceptions.dart';
// import 'package:http/http.dart' as http;
// import 'dart:convert';
// import 'package:chai_web/globals.dart' as globals;

// class ApiOptions {
//   String apiServer = 'http://185.250.44.93:8080';
//   Map<String, String> headers = {"Content-Type": "application/json"};
// }

// class ChaiWebApi {
//   ApiOptions options = ApiOptions();
//   String boxStorageName = 'authBox';
//   String? uid;
//   String? token;

//   Future<void> initialize() async {
//     uid = await getStorageValue("uid");
//     token = await getStorageValue("token");
//   }

//   Future<dynamic> getStorageValue(String key) async {
//     var boxStorage = await Hive.openBox(boxStorageName);
//     dynamic value = boxStorage.get(key);
//     // await boxStorage.close();
//     return value;
//   }

//   Future<void> setStorageValue(String key, dynamic value) async {
//     var boxStorage = await Hive.openBox(boxStorageName);
//     await boxStorage.put(key, value);
//     // await boxStorage.close();
//   }

//   Future<Map<String, dynamic>> request(String path, Map body) async {
//     token = await getStorageValue("token");
//     uid = await getStorageValue("uid");

//     if (token != null) {
//       options.headers.addAll({"token": token!});
//     }

//     if (uid != null) {
//       options.headers.addAll({"uid": uid!});
//     }

//     try {
//       final response = await http.post(
//         Uri.parse('${options.apiServer}/$path'), // Замените на ваш URL
//         body: jsonEncode(body),
//         headers: options.headers, // Заголовки
//       );

//       if (response.statusCode == 401) {
//         throw AuthorizationException();
//       }
//       var json = response.json();
//       return json;
//     } on HTTPException {
//       print("HTTPException!");
//       return {};
//     } on AuthorizationException {
//       globals.navigatorKey.currentState!.push(
//         MaterialPageRoute(builder: (context) => WelcomePage()),
//       );
//       return {};
//       // await silentAuthWithGoogle();
//       // return request(path, body);
//     } catch (error) {
//       globals.navigatorKey.currentState!.push(
//         MaterialPageRoute(builder: (context) => WaitingPage()),
//       );
//       return {};
//     }
//   }

//   Future<bool> googleTokenAuth(String idToken) async {
//     var body = {'token': idToken};
//     var result = await request("auth", body);
//     if (!result.containsKey("token")) {
//       return false;
//     }
//     // options.headers.addAll({"token": result["token"]});
//     // options.headers.addAll({"uid": result["uid"]});
//     await setStorageValue("token", result["token"]);
//     await setStorageValue("uid", result["uid"]);
//     uid = result["uid"];
//     return true;
//   }

//   Future<UserProfile> getUser(String? uid) async {
//     Map<String, String?> body = {'uid': uid};
//     var result = await request("get-user", body);
//     return UserProfile.fromJson(result);
//   }
// }

// class UserProfile {
//   final String? uid;
//   final String? nickname;
//   final String? avatar;
//   final bool isOnline;
//   final bool isBot;

//   UserProfile({
//     this.uid,
//     this.nickname,
//     this.avatar,
//     this.isOnline = false,
//     this.isBot = false,
//   });

//   factory UserProfile.fromJson(Map<String, dynamic> json) {
//     return UserProfile(
//       uid: json['uid'] as String?,
//       nickname: json['nickname'] as String?,
//       avatar: json['avatar'] as String?,
//       isOnline: json['is_online'] as bool? ?? false,
//       isBot: json['is_bot'] as bool? ?? false,
//     );
//   }

//   String strInfo() {
//     return "$uid | $nickname | $avatar";
//   }
// }
