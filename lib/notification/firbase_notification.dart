import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class PushNotification {
  AndroidNotificationChannel channel = const AndroidNotificationChannel(
      'high_importance_channel', // id
      'High Importance Notifications', // title
      'This channel is used for important notifications.', // description
      importance: Importance.high,
      playSound: true);
  var androidInitializationSettings =
      AndroidInitializationSettings('@mipmap/ic_launcher');
  // Settings for iOS
  var iosInitializationSettings = IOSInitializationSettings();

  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();
  var platformChannelSpecifics;

  Future<void> notifyUser(String title, String func) async {
    flutterLocalNotificationsPlugin.initialize(
      InitializationSettings(
        android: androidInitializationSettings,
        iOS: iosInitializationSettings,
      ),
    );

    var androidPlatformChannelSpecifics = const AndroidNotificationDetails(
      'Notification Test',
      'Notification Test',
      '',
    );
    var iOSPlatformChannelSpecifics = IOSNotificationDetails();
    platformChannelSpecifics = NotificationDetails(
        android: androidPlatformChannelSpecifics,
        iOS: iOSPlatformChannelSpecifics);

    await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(channel);

    if (func.toLowerCase().startsWith("a")) {
      showAddNotification(title);
    }
    if (func.toLowerCase().startsWith("u")) {
      showUpdatedNotification(title);
    }
    if (func.toLowerCase().startsWith("d")) {
      showDeleteNotification(title);
    }
  }

  void showAddNotification(String title) {
    flutterLocalNotificationsPlugin.show(
        0, "Task Added", "Title: $title", platformChannelSpecifics);
  }

  void showUpdatedNotification(String title) {
    flutterLocalNotificationsPlugin.show(
        0, "Task Updated", "Title: $title", platformChannelSpecifics);
  }

  void showDeleteNotification(String title) {
    flutterLocalNotificationsPlugin.show(
        0, "Task Deleted", "Title: $title", platformChannelSpecifics);
  }
}
