import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  static const _keyEmail = 'loggedInUser';
  static const _keyToken = 'authToken';
  static const _keyRemember = 'rememberMe';

  static Future<void> saveLogin(String email, String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_keyEmail, email);
    await prefs.setString(_keyToken, token);
    await prefs.setBool(_keyRemember, true);
  }

  static Future<void> clearLogin() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_keyEmail);
    await prefs.remove(_keyToken);
    await prefs.remove(_keyRemember);
  }

  static Future<String?> getLoggedInUser() async {
    final prefs = await SharedPreferences.getInstance();
    final remember = prefs.getBool(_keyRemember) ?? false;

    if (remember) {
      return prefs.getString(_keyEmail);
    } else {
      return null;
    }
  }

  static Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_keyToken);
  }

  static Future<void> logout() async {
    await clearLogin();
  }
}
