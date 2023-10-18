import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:dio/dio.dart';

import 'auth_provider.dart';

class UploadProductsProvider with ChangeNotifier {
  final AuthProvider authProvider;

  UploadProductsProvider(this.authProvider); // Constructor
  PlatformFile? selectedFile;
  String? selectedImage;
  bool _isPostSuccessful = false;

  bool get isPostSuccessful => _isPostSuccessful;

  bool _isPosting = false;

  bool get isPosting => _isPosting;

  void toggleIsPosting(bool value) {
    _isPosting = value;
    notifyListeners();
  }

  // Define controllers for  text fields
  final TextEditingController productCodeController = TextEditingController();
  final TextEditingController productNameController = TextEditingController();
  final TextEditingController productPriceController = TextEditingController();
  final TextEditingController productDescriptionController =
      TextEditingController();

  Future<void> selectFile() async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['jpg', 'jpeg', 'png', 'gif', 'mp4', 'mov', 'avi'],
      );

      if (result != null && result.files.isNotEmpty) {
        PlatformFile file = result.files.single;

        // Check if the selected file is an image based on its extension
        if (['jpg', 'jpeg', 'png', 'gif'].contains(file.extension)) {
          // Set the selected image path to the selectedImage property
          selectedImage = file.path!;
        }

        // Assign the selected file to the selectedFile property
        selectedFile = file;
        notifyListeners();
      }
    } catch (e) {
      print("File picking error: $e");
    }
  }

  Future<void> postProductData() async {
    try {
      // Get the authToken from the authProvider
      final authToken = authProvider.authToken;

      if (authToken == null) {
        // Handle the case where authToken is null (user not authenticated)
        // print('User is not authenticated');
        return;
      }

      // Create a FormData object for the request
      FormData formData = FormData.fromMap({
        'ProductCode': productCodeController.text,
        'ProductName': productNameController.text,
        'MRP': productPriceController.text,
        'product_description': productDescriptionController.text,
        'PurchaseRate': '',
        'SalesRate': '',
        'ProductImage': await MultipartFile.fromFile(selectedImage!),
      });

      // Send the POST request using Dio with the authToken in the headers
      final response = await Dio().post(
        'https://spotit.cloud/interview/api/products/create',
        data: formData,
        options: Options(headers: {
          'Authorization': 'Bearer $authToken',
        }),
      );

      if (response.statusCode == 200) {
        _isPostSuccessful = true;
        // Request was successful
        print('Product data posted successfully');
      } else {
        // Handle errors or provide feedback to the user
        print(
            'Failed to post product data. Status code: ${response.statusCode}');
      }
    } catch (e) {
      print('Error posting product data: $e');
    }
  }

  // Function to clear of controllers and remove the selected image
  void clearControllers() {
    productCodeController.clear();
    productNameController.clear();
    productPriceController.clear();
    productDescriptionController.clear();

    notifyListeners();
  }
}
