import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class AuthProvider with ChangeNotifier {
  String? authToken;
  bool get isAuthenticated => authToken != null;

  bool loginsuccess = false;

  Future<void> login(String email, String password) async {
    final url = Uri.parse('https://spotit.cloud/interview/api/login');
    final response = await http.post(
      url,
      body: jsonEncode({
        'email': email,
        'password': password,
      }),
      headers: {
        'Content-Type': 'application/json',
      },
    );

    print('Login response status code: ${response.statusCode}');
    print('Login response body: ${response.body}');

    if (response.statusCode == 200) {
      authToken = jsonDecode(response.body)['data']['token'];
      loginsuccess = true;
      print('Authentication token: $authToken');

      notifyListeners();
    } else {
      loginsuccess = false;
      print('Login failed. Error message: ${response.body}');
      throw Exception('Login failed');
    }
  }

  void logout() {
    authToken = null;
    loginsuccess = false;
    notifyListeners();
  }
}
