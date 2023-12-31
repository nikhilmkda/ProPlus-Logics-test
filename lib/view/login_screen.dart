import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../controller/auth_provider.dart';

class LoginPage extends StatelessWidget {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenwidth = MediaQuery.of(context).size.width;
    final authProvider = Provider.of<AuthProvider>(context, listen: false);

    // Check if the user is already authenticated using shared_preferences

    void handleLogin() {
      final email = emailController.text;
      final password = passwordController.text;

      authProvider.login(email, password).then((_) {
        if (authProvider.isAuthenticated) {
          // Redirect to the homepage after successful login
          Navigator.pushReplacementNamed(context, '/homepage');
        }
      }).catchError((error) {
        // Handle login error, e.g., show an error message
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            backgroundColor: Colors.red,
            content: Text('Login failed. Please check your credentials.'),
          ),
        );
      });
    }

    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(height: screenHeight / 20),
              Image.asset(
                'assets/login.jpg', // Replace with your image path
                width: screenwidth,
              ),
              SizedBox(height: screenHeight / 40),
              Container(
                width: double.infinity,
                decoration: const BoxDecoration(
                  border: Border(
                    bottom: BorderSide(
                      color: Colors.black, // Color of the underline
                      width: 0.5, // Thickness of the underline
                    ),
                  ),
                ), // Make the container take up the full screen width
                child: const Padding(
                  padding: EdgeInsets.only(bottom: 12),
                  child: Text(
                    'Sign in',
                    style: TextStyle(
                      fontSize: 20.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              SizedBox(height: screenHeight / 13),
              TextField(
                controller: emailController,
                decoration: InputDecoration(
                  hintText: 'E-mail',
                  hintStyle:
                      TextStyle(color: Colors.grey.shade400, fontSize: 14),
                  suffixIcon:
                      Icon(Icons.email_rounded, color: Colors.grey.shade400),
                  filled: true,
                  fillColor: Colors.grey.shade100,
                  contentPadding:
                      const EdgeInsets.symmetric(vertical: 18, horizontal: 25),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide:
                        BorderSide(color: Colors.grey.shade300, width: 2),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide:
                        BorderSide(color: Colors.grey.shade300, width: 2),
                  ),
                ),
              ),
              SizedBox(height: screenHeight / 30),
              TextField(
                obscureText: true,
                controller: passwordController,
                decoration: InputDecoration(
                  hintText: 'Password',
                  hintStyle:
                      TextStyle(color: Colors.grey.shade400, fontSize: 14),
                  suffixIcon:
                      Icon(Icons.remove_red_eye, color: Colors.grey.shade400),
                  filled: true,
                  fillColor: Colors.grey.shade100,
                  contentPadding:
                      const EdgeInsets.symmetric(vertical: 18, horizontal: 25),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide:
                        BorderSide(color: Colors.grey.shade300, width: 2),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide:
                        BorderSide(color: Colors.grey.shade300, width: 2),
                  ),
                ),
              ),
              SizedBox(height: screenHeight / 35),
              const Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text(
                    'Forgot password?',
                    style: TextStyle(
                        color: Colors.red, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              SizedBox(
                height: screenHeight / 12,
              ),
              ElevatedButton(
                onPressed: () {
                  if (emailController.text.isEmpty ||
                      passwordController.text.isEmpty) {
                    // Show an error message in a SnackBar.
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        backgroundColor: Colors.red,
                        content: Text('Please fill in all required fields.'),
                      ),
                    );
                  } else {
                    handleLogin();
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        backgroundColor: Colors.blue,
                        duration: Duration(seconds: 1),
                        content: Text(
                          'signing in please wait',
                        ),
                      ),
                    );
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black,
                  minimumSize: const Size(double.infinity, 45),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(25),
                  ),
                ),
                child: const Text(
                  'Sign In',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18.0,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
