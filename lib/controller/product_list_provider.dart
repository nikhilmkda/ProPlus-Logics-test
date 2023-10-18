import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:dio/dio.dart';
import '../model/product_model.dart';
import 'auth_provider.dart';

class ProductListProvider with ChangeNotifier {
  final AuthProvider authProvider;

  ProductListProvider(this.authProvider);

  String? get authToken => authProvider.authToken;

  List<Product> products =
      []; // Add this property to store the fetched products

  Future<void> fetchData() async {
    final authToken = authProvider.authToken; // Get the authToken

    if (authToken == null) {
      // Handle the case where the user is not authenticated
      //   print('User is not authenticated');
      return;
    }

    final url = Uri.parse('https://spotit.cloud/interview/api/products/data');

    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json', // Set your content type if needed
        'Authorization': 'Bearer $authToken', // Include the authToken
        // Add any other headers if required
      },
    );
    print('Response body: ${response.body}');

    if (response.statusCode == 200) {
      final Map<String, dynamic> jsonResponse = jsonDecode(response.body);
      final List<dynamic> data = jsonResponse['data'];

      if (data != null && data is List) {
        products = data.map((productData) {
          return Product(
            productCode: productData['ProductCode'],
            productName: productData['ProductName'],
            mrp: productData['SalesRate'].toDouble(),
            description: 'Product description',
            productImage: productData['ProductImage'],
          );
        }).toList();

        notifyListeners(); // Notify listeners when data is updated
      } else {
        // Handle the case where the 'data' key is not a list
        print('Invalid data format');
      }
    } else {
      // Handle API error
      print('Failed to fetch data. Status code: ${response.statusCode}');
    }
  }
}
