import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class AuthProvider with ChangeNotifier {
  String? authToken; // This variable holds the authentication token after a successful login.
  bool get isAuthenticated => authToken != null; // Returns true if the user is authenticated.

  Future<void> login(String email, String password) async {
    notifyListeners(); // Notifies listeners that the state of this provider is changing.

    final url = Uri.parse('https://spotit.cloud/interview/api/login'); // Defines the URL for the login API.
    final response = await http.post( // Sends a POST request to the login API.
      url,
      body: jsonEncode({
        'email': email,
        'password': password,
      }),
      headers: {
        'Content-Type': 'application/json',
      },
    );

    print('Login response status code: ${response.statusCode}'); // Logs the HTTP status code of the login response.
    print('Login response body: ${response.body}'); // Logs the response body for debugging.

    if (response.statusCode == 200) {
      authToken = jsonDecode(response.body)['data']['token']; // Extracts the authentication token from the response.
      notifyListeners(); // Notifies listeners that the authentication state has changed.
      print('Authentication token: $authToken'); // Logs the authentication token.
    } else {
      print('Login failed. Error message: ${response.body}'); // Logs an error message if login fails.
      throw Exception('Login failed'); // Throws an exception to indicate a login failure.
    }

   // notifyListeners(); 
  }

  void logout() {
    authToken = null; // Clears the authentication token when the user logs out.

    notifyListeners(); // Notifies listeners that the authentication state has changed (logged out).
  }
}
