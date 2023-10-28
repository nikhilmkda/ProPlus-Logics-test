import 'dart:io';

import 'package:ecommerce/controller/notification_provider.dart';
import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:video_player/video_player.dart';

import 'auth_provider.dart';

class UploadProductsProvider with ChangeNotifier {
  final AuthProvider authProvider;

  UploadProductsProvider(this.authProvider); // Constructor

  bool _isPostSuccessful = false;
  File? _image;
  File? _video;
  VideoPlayerController? _videoController;

  File? get image => _image;
  File? get video => _video;
  VideoPlayerController? get videoController => _videoController;
  void disposeVideoController() {
    if (_videoController != null) {
      _videoController!.dispose();
      _videoController = null;
    }
  }

  bool get isPostSuccessful =>
      _isPostSuccessful; // Getter for post success status

  bool _isPosting = false;

  bool get isPosting => _isPosting; // Getter for posting status

  void toggleIsPosting(bool value) {
    _isPosting = value; // Toggle the posting status
    notifyListeners(); // Notify listeners about the change in posting status
  }

  // Define controllers for text fields
  final TextEditingController productCodeController = TextEditingController();
  final TextEditingController productNameController = TextEditingController();
  final TextEditingController productPriceController = TextEditingController();
  final TextEditingController productDescriptionController =
      TextEditingController();

  Future<void> selectImageFromDevice(BuildContext context) async {
    //_video = null;
    final imageSource = await showDialog<ImageSource>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Select Image Source'),
        actions: [
          TextButton(
            child: Text('Camera'),
            onPressed: () => Navigator.of(context).pop(ImageSource.camera),
          ),
          TextButton(
            child: Text('Gallery'),
            onPressed: () => Navigator.of(context).pop(ImageSource.gallery),
          ),
        ],
      ),
    );

    if (imageSource != null) {
      final pickedFile = await ImagePicker().pickImage(source: imageSource);
      try {
        if (pickedFile != null) {
          _image = File(pickedFile.path);
          // Load and display the image
          notifyListeners();
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              backgroundColor: Colors.red,
              content: Text('image error'),
            ),
          );
        }
      } catch (e) {
        print('Error loading image: $e');
      }
    }
  }

  Future<void> selectVideoFromDevice(BuildContext context) async {
    _image = null;
    final pickedFile = await ImagePicker().pickVideo(
      source: ImageSource.gallery,
      maxDuration: const Duration(minutes: 1), // Adjust duration as needed
    );

    try {
      if (pickedFile != null) {
        disposeVideoController();
        _video = File(pickedFile.path);
        _videoController = VideoPlayerController.file(File(pickedFile.path))
          ..initialize().then((_) {
            _videoController!.setLooping(false);
            _videoController!.play();
            notifyListeners();
          });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            backgroundColor: Colors.red,
            content: Text('Video selection error'),
          ),
        );
      }
    } catch (e) {
      print('Error loading video: $e');
    }
  }

  Future<void> showImageOrVideoDialog(BuildContext context) async {
    final result = await showDialog<String>(
      context: context,
      builder: (BuildContext context) {
        return SimpleDialog(
          title: const Text('Select Image or Video'),
          children: <Widget>[
            SimpleDialogOption(
              onPressed: () {
                Navigator.pop(context, 'image');
              },
              child: const Text('Image'),
            ),
            SimpleDialogOption(
              onPressed: () {
                Navigator.pop(context, 'video');
              },
              child: const Text('Video'),
            ),
          ],
        );
      },
    );

    if (result == 'image') {
      selectImageFromDevice(context);
    } else if (result == 'video') {
      selectVideoFromDevice(context);
    }
  }

  Future<void> postProductData() async {
    print("posting data...");
    try {
      // Get the authToken from the authProvider
      final authToken = authProvider.authToken;

      if (authToken == null) {
        // Handle the case where authToken is null (user not authenticated)
        // print('User is not authenticated');
        return;
      }

      // Create a FormData object for the request
      FormData formData = FormData();

      formData.fields
        ..add(MapEntry('ProductCode', productCodeController.text))
        ..add(MapEntry('ProductName', productNameController.text))
        ..add(MapEntry('MRP', productPriceController.text))
        ..add(
            MapEntry('product_description', productDescriptionController.text))
        ..add(const MapEntry('PurchaseRate', ''))
        ..add(const MapEntry('SalesRate', ''));

      if (image != null) {
        formData.files.add(MapEntry(
          'ProductImage',
          await MultipartFile.fromFile(image!.path),
        ));
      } else if (videoController != null) {
        if (video != null) {
          formData.files.add(MapEntry(
            'ProductVideo',
            await MultipartFile.fromFile(video!.path, filename: 'video.mp4'),
          ));
        } else {
          print('video/image file is null');
        }
      }

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
        NotificationProvider().showNotification(
          title: 'Upload Success',
          body: 'Product data uploaded successfully',
        );
        // Request was successful
        print(_isPostSuccessful);
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

  // Function to clear controllers
  void clearControllers() {
    productCodeController.clear();
    productNameController.clear();
    productPriceController.clear();
    productDescriptionController.clear();

    notifyListeners(); // Notify listeners about controller clearing
  }
}
