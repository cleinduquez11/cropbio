import 'dart:convert';
import 'package:cropbio/Configs/config.dart';
import 'package:http/http.dart' as http;
import '../Models/UserModel.dart';

class AuthService {

  /// SIGN UP POST REQUEST
  static Future<bool> signUp(AppUser user) async {
    try {
      final url = Uri.parse("${Config.baseUrl}/signup");

      final response = await http.post(
        url,
        headers: {
          "Content-Type": "application/json",
        },
        body: jsonEncode(user.toJson()),
      );

      if (response.statusCode == 200 ||
          response.statusCode == 201) {

        print("Signup Success");
        print(response.body);

        return true;
      } else {
        print("Signup Failed");
        print(response.body);

        return false;
      }
    } catch (e) {
      print("Signup Error: $e");
      return false;
    }
  }

static Future<AppUser?> signIn(
  String email,
  String password,
) async {

  try {

    final url =
        Uri.parse("${Config.baseUrl}/signin");

    final response = await http.post(
      url,
      headers: {
        "Content-Type": "application/json",
      },
      body: jsonEncode({
        "email": email,
        "password": password,
      }),
    );

    final data = jsonDecode(response.body);

    /// LOGIN SUCCESS
    if (response.statusCode == 200) {

      final user =
          AppUser.fromJson(data["user"]);

      return user;
    }

    /// EMAIL NOT VERIFIED
    else if (response.statusCode == 403) {

      print("Email not verified");

      return null;
    }

    /// LOGIN FAILED
    else {

      print("Login Failed");
      print(data["message"]);

      return null;
    }

  } catch (e) {

    print("Login Error: $e");

    return null;
  }
}





}