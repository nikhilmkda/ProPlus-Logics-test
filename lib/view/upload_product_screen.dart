import 'dart:io';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:workmanager/workmanager.dart';

import '../controller/auth_provider.dart';
import '../controller/upload_products_provider.dart';

class UploadProductScreen extends StatefulWidget {
  const UploadProductScreen({super.key});

  @override
  State<UploadProductScreen> createState() => _UploadProductScreenState();
}

class _UploadProductScreenState extends State<UploadProductScreen> {
  @override
  Widget build(BuildContext context) {
    final postProductsProvider = Provider.of<UploadProductsProvider>(context);
    final authProvider = Provider.of<AuthProvider>(context);
    if (authProvider.isAuthenticated) {
      final authToken = authProvider.authToken;

      return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          toolbarHeight: 65,
          backgroundColor: Colors.white,
          actions: [
            IconButton(
              icon: Icon(
                Icons.home,
                color: Colors.black,
              ),
              onPressed: () {
                postProductsProvider.clearControllers();
                Navigator.pushNamed(context, '/homepage');
              },
            ),
          ],
          leading: IconButton(
            icon: Icon(
              Icons.arrow_back_ios_new,
              color: Colors.black,
            ),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          title: Text(
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
              const SizedBox(
                height: 20,
              ),
              Container(
                width: double
                    .infinity, // Make the container take up the full screen width
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: Text(
                    'Enter Your Details',
                    style: TextStyle(
                      fontSize: 18.0,
                      fontWeight: FontWeight.bold,
                    ),
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
              const SizedBox(
                height: 30,
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
                controller: postProductsProvider.productCodeController,
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
              const SizedBox(
                height: 30,
              ),
              Padding(
                padding: EdgeInsets.only(bottom: 8),
                child: RichText(
                    text: TextSpan(children: [
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
                controller: postProductsProvider.productNameController,
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
              const SizedBox(
                height: 30,
              ),
              Padding(
                padding: EdgeInsets.only(bottom: 8),
                child: RichText(
                    text: TextSpan(children: [
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
                controller: postProductsProvider.productPriceController,
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
              const SizedBox(
                height: 30,
              ),
              Padding(
                padding: EdgeInsets.only(bottom: 8),
                child: RichText(
                    text: TextSpan(children: [
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
                controller: postProductsProvider.productDescriptionController,
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
              const SizedBox(
                height: 40,
              ),
              if (postProductsProvider.selectedFile != null)
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
                        postProductsProvider.selectFile();
                      },
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.replay_outlined,
                            color: Colors.red.shade700,
                          ),
                          SizedBox(width: 8.0),
                          Text(
                            'Re-Upload',
                            style: TextStyle(color: Colors.red.shade900),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              if (postProductsProvider.selectedFile != null)
                const SizedBox(
                  height: 25,
                ),
              if (postProductsProvider.selectedFile != null)
                SizedBox(
                  height: 200,
                  width: double.infinity,
                  child: Image.file(
                    File(postProductsProvider.selectedImage ??
                        ''), // Provide the file path as a string
                    fit: BoxFit
                        .cover, // You can adjust the fit as per your requirements
                  ),
                ),
              if (postProductsProvider.selectedFile == null)
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
                      postProductsProvider.selectFile();
                    },
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.file_upload_outlined,
                          color: Colors.red.shade700,
                        ),
                        SizedBox(width: 8.0),
                        Text(
                          'Upload product image/ video',
                          style: TextStyle(color: Colors.red.shade900),
                        ),
                      ],
                    ),
                  ),
                ),
              const SizedBox(
                height: 40,
              ),
              Container(
                width: 400.0,
                height: 45,
                child: ElevatedButton(
                  onPressed: () async {
                    final productName =
                        postProductsProvider.productNameController.text;
                    final productPrice =
                        postProductsProvider.productPriceController.text;
                    final productDescription =
                        postProductsProvider.productDescriptionController.text;

                    if (productName.isEmpty ||
                        productPrice.isEmpty ||
                        productDescription.isEmpty) {
                      // Show an error message in a SnackBar.
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          backgroundColor: Colors.red,
                          content: Text('Please fill in all required fields.'),
                        ),
                      );
                    } else {
                      //  postProductsProvider.postProductData();

                      Workmanager().registerOneOffTask(
                        'postProductData',
                        'simpleTaskKey',
                        inputData: <String, dynamic>{
                          'authToken': authToken,
                        },
                      );
                      // postProductsProvider.postProductData();

                      // Provide feedback to the user, indicating that the upload task is in progress.
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          backgroundColor: Colors.blue,
                          content: Text(
                              'Uploading product data in the background...'),
                        ),
                      );
                      if (postProductsProvider.isPostSuccessful) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            backgroundColor: Colors.green,
                            content: Text('Uploaded post successfully'),
                          ),
                        );
                      }
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.black,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: postProductsProvider.isPosting
                      ? CircularProgressIndicator() // Show a circular progress indicator
                      : Row(
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
