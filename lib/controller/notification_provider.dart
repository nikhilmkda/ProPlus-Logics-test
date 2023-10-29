import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationProvider with ChangeNotifier {
  final FlutterLocalNotificationsPlugin notificationsPlugin =
      FlutterLocalNotificationsPlugin();

  void initializeNotifications() async {
    AndroidInitializationSettings initializationSettingsAndroid =
        const AndroidInitializationSettings('@mipmap/ic_launcher');

    var initializationSettings =
        InitializationSettings(android: initializationSettingsAndroid);
    await notificationsPlugin.initialize(initializationSettings,
        onDidReceiveNotificationResponse:
            (NotificationResponse notificationResponse) async {});
  }

  NotificationDetails notificationDetails({
    String? description, // Add description parameter
  }) {
    // Create a style for the notification, including the description
    final style = BigTextStyleInformation(description ?? ''); // Use the provided description or an empty string if none is provided
    return NotificationDetails(
      android: AndroidNotificationDetails(
        'channelId',
        'channelName',
        importance: Importance.high,
        styleInformation: style, // Set the styleInformation property
      ),
    );
  }

  Future<void> showNotification({
    int id = 0,
    required String title,
    required String body,
    String? description, // Add description parameter
    String? payload,
  }) async {
    return notificationsPlugin.show(
      id,
      title,
      body,
      notificationDetails(description: description), // Pass the description to notificationDetails
    );
  }
}
