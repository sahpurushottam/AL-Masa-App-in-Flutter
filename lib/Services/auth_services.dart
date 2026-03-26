import 'dart:convert';
import 'package:ai_masa/global/Global.dart';
import 'package:http/http.dart' as http;

class AuthServices {
  static Future<dynamic> login(data) async {
    try {
      final url = '$API_BASE_URL/distributor/login';
      final uri = Uri.parse(url);
      final response = await http.post(
        uri,
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $app_auth_token",
        },
        body: jsonEncode(data),
      );
      print(response.statusCode);
      if (response.statusCode == 200) {
        final response_data = jsonDecode(response.body) as Map;
        print(response_data);
        return response_data;
      } else {
        return null;
      }
    } catch (e) {
      // Handle exception
      print('Exception occurred: $e');
      return null;
    }
  }

  static Future<dynamic> logout() async {
    final url = '$API_BASE_URL/distributor/logout';
    final uri = Uri.parse(url);
    final response = await http.get(
      uri,
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $app_auth_token",
      },
    );
    if (response.statusCode == 200) {
      final response_data = jsonDecode(response.body) as Map;
      return response_data;
    } else {
      return null;
    }
  }

  static Future<dynamic> change_distributor_password(
    old_password,
    new_password,
    confirm_password,
  ) async {
    try {
      final url = '$API_BASE_URL/change_distributor_password';
      final uri = Uri.parse(url);
      final response = await http.post(
        uri,
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $app_auth_token",
        },
        body: jsonEncode({
          'old_password': old_password,
          'new_password': new_password,
          'confirm_password': confirm_password,
        }),
      );
      print(response.statusCode);
      if (response.statusCode == 200) {
        final response_data = jsonDecode(response.body) as Map;
        return response_data;
      } else {
        return null;
      }
    } catch (e) {
      print('Exception occurred: $e');
      return null;
    }
  }
}
