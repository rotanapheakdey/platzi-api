import "dart:convert";
import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart';

class AuthService {
  static const String _baseUrl = "https://api.escuelajs.co/api/v1/auth/login";

  Future<String?> login(String email, String password) async {
    try {
      final response = await http.post(
        Uri.parse(_baseUrl),
        headers: {"Content-type": "application/json"},
        body: jsonEncode({
          "email": email,
          "password": password,
        }),
      );
      if (response.statusCode == 201) {
        final data = jsonDecode(response.body);
        return data['access_token'];
      } else {
        debugPrint("Login Failed: ${response.body}");
        return null;  
      }
    } catch (e) {
      debugPrint("Login Exception: $e");
      return null;
    }
  }
}
