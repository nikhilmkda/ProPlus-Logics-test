import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

class AuthProvider with ChangeNotifier {
  String? authToken;
  bool get isAuthenticated => authToken != null;

  AuthProvider(String? authToken) {
    // Initialize the authToken from shared_preferences when the app starts
    _initAuthToken();
  }

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

    if (response.statusCode == 200) {
      authToken = jsonDecode(response.body)['data']['token'];
      // Save the authentication token to shared_preferences
      await _saveAuthToken(authToken);
      notifyListeners();
    } else {
      throw Exception('Login failed');
    }
  }

  void logout() {
    authToken = null;

    _removeAuthToken();

    notifyListeners();
  }

  // Helper function to save the authentication token to shared_preferences
  Future<void> _saveAuthToken(String? token) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString('auth_token', token ?? '');
    print(token);
  }

  // Helper function to get the authentication token from shared_preferences
  Future<void> _initAuthToken() async {
    final prefs = await SharedPreferences.getInstance();
    authToken = prefs.getString('auth_token');
    notifyListeners();
  }

  // Helper function to remove the authentication token from shared_preferences
  Future<void> _removeAuthToken() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.remove('auth_token');
  }
}
