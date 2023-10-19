import 'package:ecommerce/controller/product_create_provider.dart';
import 'package:ecommerce/view/product_list_screen.dart';
import 'package:ecommerce/view/login_screen.dart';
import 'package:ecommerce/view/product_create_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:workmanager/workmanager.dart';

// ignore: unnecessary_import
import 'controller/auth_provider.dart';
import 'controller/product_list_provider.dart';

void callbackDispatcher(String task, Map<String, dynamic> inputData) {
  // Now you can access inputData, including the 'authToken'.
  final authToken = inputData['authToken'];

  // Check if the authToken is not null before proceeding.
  if (authToken != null) {
    // Proceed with the background task using authToken.
    final uploadProvider = UploadProductsProvider(authToken);
    // Call the method you need on the uploadProvider.
    uploadProvider.postProductData();
  }
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Workmanager().initialize(callbackDispatcher);
  final prefs = await SharedPreferences.getInstance();
  final authToken = prefs.getString('auth_token');

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider(authToken)),
        ChangeNotifierProvider(
          create: (context) => ProductListProvider(
            Provider.of<AuthProvider>(context, listen: false),
          ),
        ),
        ChangeNotifierProvider(
          create: (context) => UploadProductsProvider(
            Provider.of<AuthProvider>(context, listen: false),
          ),
        ),
      ],
      child: MyApp(authToken: authToken),
    ),
  );
}

class MyApp extends StatelessWidget {
  final String? authToken;

  MyApp({this.authToken});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: authToken != null ? const HomePage() : LoginPage(),
      routes: {
        '/homepage': (context) => const HomePage(),
        '/postProductScreen': (context) => const UploadProductScreen(),
      },
    );
  }
}
