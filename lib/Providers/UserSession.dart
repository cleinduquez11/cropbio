import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../Models/UserModel.dart';

class UserSession {

  static const String _keyUser = "logged_in_user";

  /// SAVE USER
  static Future<void> saveUser(AppUser user) async {

    final prefs =
        await SharedPreferences.getInstance();

    await prefs.setString(
      _keyUser,
      jsonEncode(user.toJson()),
    );
  }

  /// GET USER
  static Future<AppUser?> getUser() async {

    final prefs =
        await SharedPreferences.getInstance();

    final data =
        prefs.getString(_keyUser);

    if (data == null) return null;

    return AppUser.fromJson(
      jsonDecode(data),
    );
  }

  /// CLEAR SESSION
  static Future<void> clearUser() async {

    final prefs =
        await SharedPreferences.getInstance();

    await prefs.remove(_keyUser);
  }

  /// CHECK IF LOGGED IN
  static Future<bool> isLoggedIn() async {

    final prefs =
        await SharedPreferences.getInstance();

    return prefs.containsKey(_keyUser);
  }
}