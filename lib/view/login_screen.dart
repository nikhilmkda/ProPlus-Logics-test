import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../controller/auth_provider.dart';

class LOginPage extends StatelessWidget {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  LOginPage({super.key});

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);

    // Function to handle the login process
    void handleLogin() {
      final email = emailController.text;
      final password = passwordController.text;

      authProvider.login(email, password).then((_) {
        if (authProvider.isAuthenticated) {
          Navigator.pushReplacementNamed(context, '/homepage'); // Redirect to the homepage if the login is successful
        }
      }).catchError((error) {
        // Handle login error, e.g., show an error message in a SnackBar
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
              const SizedBox(height: 40.0),
              Image.asset(
                'assets/login.jpg', // Replace with your image path
                width: 450.0,
              ),
              const SizedBox(height: 10.0),
              Container(
                width: double.infinity,
                decoration: const BoxDecoration(
                  border: Border(
                    bottom: BorderSide(
                      color: Colors.black, // Color of the underline
                      width: 0.5, // Thickness of the underline
                    ),
                  ),
                ),
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
              const SizedBox(height: 60.0),
              TextField(
                controller: emailController,
                decoration: InputDecoration(
                  hintText: 'E-mail',
                  hintStyle: TextStyle(color: Colors.grey.shade400, fontSize: 14),
                  suffixIcon: Icon(Icons.email_rounded, color: Colors.grey.shade400),
                  filled: true,
                  fillColor: Colors.grey.shade100,
                  contentPadding: const EdgeInsets.symmetric(vertical: 18, horizontal: 25),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(color: Colors.grey.shade300, width: 2),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(color: Colors.grey.shade300, width: 2),
                  ),
                ),
              ),
              const SizedBox(height: 25.0),
              TextField(
                controller: passwordController,
                decoration: InputDecoration(
                  hintText: 'Password',
                  hintStyle: TextStyle(color: Colors.grey.shade400, fontSize: 14),
                  suffixIcon: Icon(Icons.remove_red_eye, color: Colors.grey.shade400),
                  filled: true,
                  fillColor: Colors.grey.shade100,
                  contentPadding: const EdgeInsets.symmetric(vertical: 18, horizontal: 25),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(color: Colors.grey.shade300, width: 2),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(color: Colors.grey.shade300, width: 2),
                  ),
                ),
              ),
              const SizedBox(height: 20.0),
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
              const SizedBox(height: 50.0),
              ElevatedButton(
                onPressed: () {
                  if (emailController.text.isEmpty || passwordController.text.isEmpty) {
                    // Show an error message in a SnackBar if fields are empty
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        backgroundColor: Colors.red,
                        content: Text('Please fill in all required fields.'),
                      ),
                    );
                  } else {
                    handleLogin(); // Call the login function if fields are not empty
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        backgroundColor: Colors.blue,
                        duration: Duration(seconds: 1),
                        content: Text(
                          'Signing in, please wait',
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
