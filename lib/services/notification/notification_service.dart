import 'dart:io';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:myevents/utility/locator.dart';
import 'package:myevents/utility/shared_prefs/prefs_keys.dart';

class NotificationService {
  static final _firebaseMessaging = FirebaseMessaging.instance;
  static final _localNotifications = FlutterLocalNotificationsPlugin();

  static Future<void> initialize() async {
    // Request permissions
    await _firebaseMessaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
      provisional: false,
    );

    // Initialize local notifications
    const android = AndroidInitializationSettings('@mipmap/launcher_icon');
    const ios = DarwinInitializationSettings();
    const settings = InitializationSettings(android: android, iOS: ios);
    await _localNotifications.initialize(settings);

    FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) async {
      await firebaseMessagingBackgroundHandler(message);
    });

    // Handle foreground messages
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      if (message.notification != null &&
              DI.prefs.getBool(PrefsKeys.notificationEnabled) == true ||
          DI.prefs.getBool(PrefsKeys.notificationEnabled) == null) {
        _showNotification(message);
      }
      firebaseMessagingBackgroundHandler(message);
    });
  }

  static void subscribeToTopic(String topic) {
    _firebaseMessaging.subscribeToTopic(topic);
  }

  static void unsubscribeToTopic(String topic) async {
    await _firebaseMessaging.unsubscribeFromTopic(topic);
  }

  static Future<void> _showNotification(RemoteMessage message) async {
    const androidDetails = AndroidNotificationDetails(
      'default_channel',
      'Default',
      importance: Importance.max,
      priority: Priority.high,
    );
    const iosDetails = DarwinNotificationDetails();
    const details = NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
    );

    await _localNotifications.show(
      message.hashCode,
      message.notification?.title,
      message.notification?.body,
      details,
    );
  }

  static Future<String?> getToken() async {
    final apnsToken = await FirebaseMessaging.instance.getAPNSToken();
    if (Platform.isAndroid) {
      return await FirebaseMessaging.instance.getToken();
    } else if (apnsToken != null && Platform.isIOS) {
      // Safe to call getToken, subscribeToTopic, etc.
      return await FirebaseMessaging.instance.getToken();
      // ...other messaging logic...
    } else {
      // Handle the case where APNS token is not yet available
    }
  }
}

Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  //Map<String, dynamic> map = message.data;
  // Handle background operations based on the message data
  // if (map['action'] == 'delete') {
  //   var eventId = map['event_id'];
  //   if (eventId != null && eventId is String) {
  //     var list = await DI.prefs.getAllEvents();
  //     list.removeWhere((event) => event.event_id == eventId);
  //     await DI.prefs.setString(PrefsKeys.eventDetails, jsonEncode(list));
  //   }
  // }
}
