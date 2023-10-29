import 'dart:io';

import 'package:ecommerce/controller/notification_provider.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:video_player/video_player.dart';
import 'package:workmanager/workmanager.dart';

import '../controller/auth_provider.dart';
import '../controller/product_create_provider.dart';

void callbackDispatcher(String task, Map<String, dynamic> inputData) {
  // Now you can access inputData, including the 'authToken'.
  final authToken = inputData['authToken'];

  // Check if the authToken is not null before proceeding.
  if (authToken != null) {
    // Proceed with the background task using authToken.
    final uploadProductsProvider = UploadProductsProvider(authToken);
    // Call the method you need on the uploadProvider.
    uploadProductsProvider.postProductData();
    if (uploadProductsProvider.isPostSuccessful == true) {
      final notificationProvider = NotificationProvider();

      notificationProvider.showNotification(
        title: 'Success',
        body: 'Data added successfully',
      );
    }
  }
}

class UploadProductScreen extends StatefulWidget {
  const UploadProductScreen({super.key});

  @override
  State<UploadProductScreen> createState() => _UploadProductScreenState();
}

class _UploadProductScreenState extends State<UploadProductScreen> {
  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final uploadProductsProvider = Provider.of<UploadProductsProvider>(context);
    final authProvider = Provider.of<AuthProvider>(context);
    if (authProvider.isAuthenticated) {
      // final authToken = authProvider.authToken;

      return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          centerTitle: true,
          toolbarHeight: 65,
          backgroundColor: Colors.white,
          leading: IconButton(
            icon: const Icon(
              Icons.arrow_back_ios_new,
              color: Colors.black,
            ),
            onPressed: () {
              if (uploadProductsProvider.videoController != null) {
                uploadProductsProvider.videoController!.pause();
              }

              Navigator.of(context).pop();
            },
          ),
          title: const Text(
            "Post Product",
            style: TextStyle(
                color: Colors.black, fontWeight: FontWeight.bold, fontSize: 18),
          ),
        ),
        body: SingleChildScrollView(
          child: Container(
            padding: const EdgeInsets.all(12.0),
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              SizedBox(
                height: screenHeight / 50,
              ),
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
                    'Enter Your Details',
                    style: TextStyle(
                      fontSize: 18.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: screenHeight / 26,
              ),
              const Padding(
                padding: EdgeInsets.only(bottom: 8),
                child: Text(
                  "product code",
                  style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      fontSize: 14),
                ),
              ),
              TextField(
                controller: uploadProductsProvider.productCodeController,
                decoration: InputDecoration(
                  hintText: 'PRDTSLNO125456',
                  hintStyle:
                      TextStyle(color: Colors.grey.shade400, fontSize: 12),
                  filled: true,
                  fillColor: Colors.white,
                  contentPadding:
                      const EdgeInsets.symmetric(vertical: 18, horizontal: 25),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(5),
                    borderSide:
                        BorderSide(color: Colors.grey.shade300, width: 2),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(5),
                    borderSide:
                        BorderSide(color: Colors.grey.shade300, width: 2),
                  ),
                ),
              ),
              SizedBox(
                height: screenHeight / 26,
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: RichText(
                    text: const TextSpan(children: [
                  TextSpan(
                    text: "*",
                    style: TextStyle(
                        color: Colors.red,
                        fontWeight: FontWeight.bold,
                        fontSize: 14),
                  ),
                  TextSpan(
                    text: "product name",
                    style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: 14),
                  )
                ])),
              ),
              TextField(
                controller: uploadProductsProvider.productNameController,
                decoration: InputDecoration(
                  hintText: 'Enter your product name',
                  hintStyle:
                      TextStyle(color: Colors.grey.shade400, fontSize: 12),
                  filled: true,
                  fillColor: Colors.white,
                  contentPadding:
                      const EdgeInsets.symmetric(vertical: 18, horizontal: 25),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(5),
                    borderSide:
                        BorderSide(color: Colors.grey.shade300, width: 2),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(5),
                    borderSide:
                        BorderSide(color: Colors.grey.shade300, width: 2),
                  ),
                ),
              ),
              SizedBox(
                height: screenHeight / 26,
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: RichText(
                    text: const TextSpan(children: [
                  TextSpan(
                    text: "*",
                    style: TextStyle(
                        color: Colors.red,
                        fontWeight: FontWeight.bold,
                        fontSize: 14),
                  ),
                  TextSpan(
                    text: "product price",
                    style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: 14),
                  )
                ])),
              ),
              TextField(
                controller: uploadProductsProvider.productPriceController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  hintText: 'Enter your product price',
                  hintStyle:
                      TextStyle(color: Colors.grey.shade400, fontSize: 12),
                  filled: true,
                  fillColor: Colors.white,
                  contentPadding:
                      const EdgeInsets.symmetric(vertical: 18, horizontal: 25),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(5),
                    borderSide:
                        BorderSide(color: Colors.grey.shade300, width: 2),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(5),
                    borderSide:
                        BorderSide(color: Colors.grey.shade300, width: 2),
                  ),
                ),
              ),
              SizedBox(
                height: screenHeight / 26,
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: RichText(
                    text: const TextSpan(children: [
                  TextSpan(
                    text: "*",
                    style: TextStyle(
                        color: Colors.red,
                        fontWeight: FontWeight.bold,
                        fontSize: 14),
                  ),
                  TextSpan(
                    text: "Description",
                    style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: 14),
                  )
                ])),
              ),
              TextField(
                controller: uploadProductsProvider.productDescriptionController,
                decoration: InputDecoration(
                  hintText: 'Add Your Description Here',
                  hintStyle:
                      TextStyle(color: Colors.grey.shade400, fontSize: 12),
                  filled: true,
                  fillColor: Colors.white,
                  contentPadding:
                      const EdgeInsets.symmetric(vertical: 58, horizontal: 25),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(5),
                    borderSide:
                        BorderSide(color: Colors.grey.shade300, width: 2),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(5),
                    borderSide:
                        BorderSide(color: Colors.grey.shade300, width: 2),
                  ),
                ),
              ),
              SizedBox(
                height: screenHeight / 20,
              ),
              if (uploadProductsProvider.image != null ||
                  uploadProductsProvider.video != null)
                Align(
                  alignment: Alignment.centerRight,
                  child: SizedBox(
                    width: 150,
                    height: 40,
                    child: OutlinedButton(
                      style: OutlinedButton.styleFrom(
                        foregroundColor: Colors.red.shade700,
                        side: BorderSide(
                            color: Colors.red.shade700), // Border color
                        shape: RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.circular(10.0), // Circular edges
                        ),
                      ),
                      onPressed: () {
                        uploadProductsProvider.showImageOrVideoDialog(context);
                      },
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.replay_outlined,
                            color: Colors.red.shade700,
                          ),
                          const SizedBox(width: 8.0),
                          Text(
                            'Re-Upload',
                            style: TextStyle(color: Colors.red.shade900),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              if (uploadProductsProvider.image != null ||
                  uploadProductsProvider.video != null)
                SizedBox(
                  height: screenHeight / 26,
                ),
              uploadProductsProvider.image != null
                  ? Image.file(
                      File(uploadProductsProvider.image!.path),
                      fit: BoxFit.cover,
                      height: screenHeight / 2,
                      width: double.infinity,
                    )
                  : GestureDetector(
                      child: uploadProductsProvider.videoController != null
                          ? Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: AspectRatio(
                                aspectRatio: uploadProductsProvider
                                    .videoController!.value.aspectRatio,
                                child: VideoPlayer(
                                    uploadProductsProvider.videoController!),
                              ),
                            )
                          : Container(),
                    ),
              if (uploadProductsProvider.image == null &&
                  uploadProductsProvider.video == null)
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: OutlinedButton(
                    style: OutlinedButton.styleFrom(
                      foregroundColor: Colors.red.shade700,
                      side: BorderSide(
                          color: Colors.red.shade700), // Border color
                      shape: RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius.circular(10.0), // Circular edges
                      ),
                    ),
                    onPressed: () {
                      uploadProductsProvider.showImageOrVideoDialog(context);
                    },
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.file_upload_outlined,
                          color: Colors.red.shade700,
                        ),
                        const SizedBox(width: 8.0),
                        Text(
                          'Upload product image/ video',
                          style: TextStyle(color: Colors.red.shade900),
                        ),
                      ],
                    ),
                  ),
                ),
              SizedBox(
                height: screenHeight / 20,
              ),
              SizedBox(
                width: 400.0,
                height: 45,
                child: ElevatedButton(
                  onPressed: () async {
                    final productName =
                        uploadProductsProvider.productNameController.text;
                    final productPrice =
                        uploadProductsProvider.productPriceController.text;
                    final productDescription = uploadProductsProvider
                        .productDescriptionController.text;

                    if (productName.isEmpty ||
                        productPrice.isEmpty ||
                        productDescription.isEmpty) {
                      // Show an error message in a SnackBar.
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          backgroundColor: Colors.red,
                          content: Text('Please fill in all required fields.'),
                        ),
                      );
                    } else {
                      // Provide feedback to the user, indicating that the upload task is in progress.
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          duration: Duration(milliseconds: 1000),
                          backgroundColor: Colors.blue,
                          content: Text(
                              'Uploading product data in the background...'),
                        ),
                      );
                      // Use the `compute` function to run the background task

                      await uploadProductsProvider.postProductData();

                      // Get the authToken from SharedPreferences
                      //final prefs = await SharedPreferences.getInstance();
                      //  final authToken = prefs.getString('auth_token');

                      // Workmanager().registerOneOffTask(
                      //   'postProductData',
                      //   'simpleTaskKey',
                      //   initialDelay: const Duration(
                      //       seconds: 10), // Add a delay if needed
                      //   inputData: <String, dynamic>{
                      //     'authToken':
                      //         authToken, // Make sure authToken is defined
                      //   },
                      // );
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.black,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: uploadProductsProvider.isPosting
                      ? const CircularProgressIndicator() // Show a circular progress indicator
                      : const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "Post ",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold),
                            ),
                            Icon(
                              Icons.telegram, // Paper plane icon
                              color: Colors.white,
                            ),
                          ],
                        ),
                ),
              ),
            ]),
          ),
        ),
      );
    } else {
      return const Scaffold(
        body: Center(
          child: Text("User is not authenticated. Please log in."),
        ),
      );
    }
  }
}
