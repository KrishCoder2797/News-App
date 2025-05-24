import 'package:shared_preferences/shared_preferences.dart';

class SessionLogin {
  Future<void> saveUserCredentials(String token) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('userToken', token);
  }

  Future<void> logout() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('userToken');
  }
}
