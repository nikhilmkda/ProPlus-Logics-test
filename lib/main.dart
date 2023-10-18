import 'package:ecommerce/controller/upload_products_provider.dart';
import 'package:ecommerce/view/homepage.dart';
import 'package:ecommerce/view/login_screen.dart';
import 'package:ecommerce/view/upload_product_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:workmanager/workmanager.dart';

// ignore: unnecessary_import
import 'controller/auth_provider.dart';
import 'controller/product_list_provider.dart';

void callbackDispatcher(String task, Map<String, dynamic> inputData) {
  // Now you can access inputData, including the 'authToken'.
  final authToken = inputData['authToken'];
  print(authToken);

  // Check if the authToken is not null before proceeding.
  if (authToken != null) {
    // Proceed with the background task using authToken.
    final uploadProvider = UploadProductsProvider(authToken);
    // Call the method you need on the uploadProvider.
    uploadProvider.postProductData();
  }
}

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  Workmanager().executeTask((task, inputData) {
    callbackDispatcher(task, inputData!);
    return Future.value(true);
  });

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
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
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: '/',
      routes: {
        '/': (context) => LOginPage(),
        '/homepage': (context) => HomePage(),
        '/postProductScreen': (context) => const UploadProductScreen(),
      },
    );
  }
}
