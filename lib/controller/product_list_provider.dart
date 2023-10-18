import 'package:flutter/foundation.dart';
import 'package:dio/dio.dart'; // Import the Dio package

import '../model/product_model.dart';
import 'auth_provider.dart';

class ProductListProvider with ChangeNotifier {
  final AuthProvider authProvider;
  final Dio _dio = Dio(); // Create a Dio instance
  bool hasNetworkError = false;

  ProductListProvider(this.authProvider);

  String? get authToken => authProvider.authToken;

  List<Product> products = [];

  Future<void> fetchData() async {
    final authToken = authProvider.authToken;

    if (authToken == null) {
      // Handle the case where the user is not authenticated
      return;
    }

    int retryCount = 0;
    int maxRetries = 5; // Set a maximum number of retries

    Future<void> fetchWithRetries() async {
      while (retryCount < maxRetries) {
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
                  productCode: productData['ProductCode'],
                  productName: productData['ProductName'],
                  mrp: productData['SalesRate'].toDouble(),
                  description: 'Product description',
                  productImage: productData['ProductImage'],
                );
              }).toList();

              notifyListeners();
              break; // Break out of the retry loop if successful
            } else {
              print('Invalid data format');
            }
          } else if (response.statusCode == 429) {
            // Handle 429 error by implementing exponential backoff
            int delayInSeconds = 2 ^ retryCount;
            await Future.delayed(Duration(seconds: delayInSeconds));
            retryCount++;
          } else {
            print('Failed to fetch data. Status code: ${response.statusCode}');
            hasNetworkError = true;
            break; // Stop retrying for other errors
          }
        } on DioException catch (e) {
          if (e.response != null && e.response!.statusCode == 429) {
            // Handle 429 error by implementing exponential backoff
            int delayInSeconds = 2 ^ retryCount;
            await Future.delayed(Duration(seconds: delayInSeconds));
            retryCount++;
          } else {
            // Handle other Dio errors (e.g., network issues, server errors)
            print('Dio Error: $e');
            hasNetworkError = true;
            break; // Stop retrying for other Dio errors
          }
        } catch (e) {
          // Handle other exceptions
          print('Error: $e');
          hasNetworkError = true;
          break; // Stop retrying for other exceptions
        }
      }
    }

    // Start fetching data with retries
    await fetchWithRetries();
  }
}
