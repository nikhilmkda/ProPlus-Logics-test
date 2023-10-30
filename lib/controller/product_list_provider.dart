import 'package:flutter/foundation.dart';
import 'package:dio/dio.dart'; // Import the Dio package

import '../model/product_model.dart';
import 'auth_provider.dart';

class ProductListProvider with ChangeNotifier {
  final AuthProvider authProvider;
  final Dio _dio = Dio(); // Create a Dio instance
  bool hasNetworkError = false;
  bool isLoading = false;
  ProductListProvider(this.authProvider);

  String? get authToken => authProvider.authToken;

  List<Product> products = [];

//avoid fetching data multiple times
  Future<dynamic> fetchDataFromAPIOnce() async {
    if (products.isEmpty) {
      final result = await fetchData();
      return result;
    }
    return products;
  }

//fetch data from the api
  Future<void> fetchData() async {
    products.clear();
    final authToken = authProvider.authToken;

    if (authToken == null) {
      // Handle the case where the user is not authenticated
      return;
    }
    // Check if the data has already been fetched

    try {
      final response = await _dio.post(
        'https://spotit.cloud/interview/api/products/data',
        data: {
          // Add your request payload if needed
        },
        options: Options(
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $authToken',
            // Add any other headers if required
          },
        ),
      );
      print('Response data: ${response.data}');

      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonResponse = response.data;
        final List<dynamic> data = jsonResponse['data'];

        // ignore: unnecessary_type_check
        if (data is List) {
          products = data.map((productData) {
            return Product(
              productCode: productData['ProductCode'] ?? 'Not Found!',
              productName: productData['ProductName'] ?? 'Not Found!',
              mrp: productData['SalesRate'].toDouble() ?? 'Not Found!',
              description: productData['description'] ?? 'Not Found!',
              productImage: productData['ProductImage'] ?? 'Not Found!',
            );
          }).toList();

          notifyListeners();
        }
      } else {
        print('Failed to fetch data. Status code: ${response.statusCode}');
        hasNetworkError = true;
      }
    } catch (e) {
      // Handle other exceptions
      print('Error: $e');
      hasNetworkError = true;
    }
  }
}
