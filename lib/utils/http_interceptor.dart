import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class HttpInterceptor {
  static Future<bool> checkTokenExpiry(http.Response response) async {
    if (response.statusCode == 401) {
      final data = jsonDecode(response.body);
      
      if (data['error'] == 'TOKEN_EXPIRED') {
        // Hapus token
        final prefs = await SharedPreferences.getInstance();
        await prefs.remove('token');
        await prefs.remove('user');
        
        return true; // Token expired
      }
    }
    return false; // Token masih valid
  }
}