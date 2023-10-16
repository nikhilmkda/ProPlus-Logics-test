import 'package:flutter/material.dart';

class LOginPage extends StatefulWidget {
  const LOginPage({super.key});

  @override
  State<LOginPage> createState() => _LOginPageState();
}

class _LOginPageState extends State<LOginPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Container(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'assets/login.jpg', // Replace with your image path
              width: 450.0,
              height: 450.0,
            ),
            const SizedBox(height: 10.0),
            Container(
              width: double
                  .infinity, // Make the container take up the full screen width
              child: Text(
                'Sign in',
                style: TextStyle(
                  fontSize: 20.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(
                    color: Colors.black, // Color of the underline
                    width: 0.5, // Thickness of the underline
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20.0),
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10.0), // Rounded border
                border: Border.all(
                    color: Colors.grey.shade300, width: 2), // Grey border
                color: Colors.grey.shade100, // White background
              ),
              child: TextField(
                decoration: InputDecoration(
                  labelText: ' Email',
                  suffixIcon: Icon(
                    Icons.email,
                    color: Colors.grey.shade300,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 10.0),
            TextFormField(
              obscureText: true,
              decoration: InputDecoration(
                labelText: 'Password',
              ),
            ),
            const SizedBox(height: 10.0),
            const Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text(
                  'Forgot password?',
                  style:
                      TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            const SizedBox(height: 20.0),
            ElevatedButton(
              onPressed: () {
                // Implement your sign-in logic here
              },
              style: ElevatedButton.styleFrom(
                
                backgroundColor: Colors.black,
                minimumSize: const Size(double.infinity, 50),
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
    );
  }
}
