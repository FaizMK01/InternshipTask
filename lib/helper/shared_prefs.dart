import 'package:shared_preferences/shared_preferences.dart';

class SharedPrefService {
  Future<void> saveUserData(String name, String email, String uid) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('name', name); // Save user's name
    await prefs.setString('email', email); // Save user's email
    await prefs.setString('uid', uid); // Save user's unique ID
  }

  Future<Map<String, String?>> getUserData() async {
    final prefs = await SharedPreferences.getInstance();
    return {
      'name': prefs.getString('name'),
      'email': prefs.getString('email'),
      'uid': prefs.getString('uid'),
    };
  }

  Future<void> clearUserData() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('name');
    await prefs.remove('email');
    await prefs.remove('uid');
  }

  Future<bool> isUserLoggedIn() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('uid') != null;
  }
}