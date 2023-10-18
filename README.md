# E-Commerce App README

This README provides an overview of the structure and functionality of the E-Commerce mobile app, which is built using Flutter.

## App Overview

The E-Commerce app is designed for online shopping and product listing. It includes features such as user authentication, product posting, and product browsing.
## App Structure
The app is structured as follows:

lib: This directory contains the main source code for the app.
controller: Contains the providers for user authentication and product data.
view: Contains the app's screens and UI components.
main.dart: The entry point of the app.
workmanager.dart: Background task dispatcher for background product posting.

# App Screens
The E-Commerce app includes the following screens:

Login Screen (LOginPage): Allows users to log in with their credentials. User authentication is handled by the AuthProvider class.

Home Page (HomePage): Displays a list of products available for purchase.

Product Details Screen (ExpandedProduct): Displays Details of products available for purchase.

Product Posting Screen (UploadProductScreen): Allows authenticated users to post new products. Product data is posted in the background using the Workmanager package.

# Background Task
The workmanager.dart file is used to execute background tasks for posting product data. It dispatches background tasks to post product data based on an authentication token.

## Dependencies

- [Flutter SDK](https://flutter.dev/)
- [Cupertino Icons](https://pub.dev/packages/cupertino_icons)
- [Provider](https://pub.dev/packages/provider)
- [HTTP](https://pub.dev/packages/http)
- [File Picker](https://pub.dev/packages/file_picker)
- [Dio](https://pub.dev/packages/dio)
- [Workmanager](https://pub.dev/packages/workmanager)
- [Video Player](https://pub.dev/packages/video_player)
