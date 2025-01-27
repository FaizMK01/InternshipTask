// import 'package:shared_preferences/shared_preferences.dart';
//
// class SharedPreferencesHelper {
//   static Future<void> saveUserInfo(String name, String email) async {
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     await prefs.setString('userName', name);
//     await prefs.setString('userEmail', email);
//   }
//
//   static Future<Map<String, String?>> getUserInfo() async {
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     String? name = prefs.getString('userName');
//     String? email = prefs.getString('userEmail');
//     return {'name': name, 'email': email};
//   }
//
//   static Future<void> clearUserInfo() async {
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     await prefs.remove('userName');
//     await prefs.remove('userEmail');
//   }
// }
