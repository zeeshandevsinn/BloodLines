import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get_storage/get_storage.dart';
import 'package:bloodlines/config.dart';

const AndroidInitializationSettings initializationSettingsAndroid =
    AndroidInitializationSettings('playstore');

/// Note: permissions aren't requested here just to demonstrate that can be
/// done later
final DarwinInitializationSettings initializationSettingsIOS =
    DarwinInitializationSettings(
  requestAlertPermission: false,
  requestBadgePermission: false,
  requestSoundPermission: false,
);

final InitializationSettings initializationSettings = InitializationSettings(
  android: initializationSettingsAndroid,
  iOS: initializationSettingsIOS,
);

Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  // If you're going to use other Firebase services in the background, such as Firestore,
  // make sure you call `initializeApp` before using other Firebase services.

  await GetStorage.init();
  await Firebase.initializeApp(
    options: DefaultFirebaseConfig.platformOptions,
  );
  await FirebaseMessaging.instance.requestPermission();
}

/// Create a [AndroidNotificationChannel] for heads up notifications
late AndroidNotificationChannel channel;

/// Initialize the [FlutterLocalNotificationsPlugin] package.
late FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;

@pragma('vm:entry-point')
void notificationTapBackground(
    NotificationResponse notificationResponse) async {
  WidgetsFlutterBinding.ensureInitialized();
  await GetStorage.init();
  await Firebase.initializeApp(
    options: DefaultFirebaseConfig.platformOptions,
  );
  if (notificationResponse.input?.isNotEmpty ?? false) {
    // ignore: avoid_print
    print(
        'notification action tapped with input: ${notificationResponse.input}');
  }
  onTapBackground(notificationResponse);
  // handle action
}

Future<dynamic> onTapBackground(payload) async {
  if (payload != null) {}
}

noti(notification, data) {
  flutterLocalNotificationsPlugin.show(
    notification.hashCode,
    notification.title,
    notification.body,
    NotificationDetails(
      android: AndroidNotificationDetails(
        channel.id,
        channel.name,
        priority: Priority.max,
        channelDescription: channel.description,
        playSound: true,
        enableVibration: true,
        icon: 'ic_launcher',
      ),
    ),
    //payload: json.encode(orderDetails.toJson())

    // payload: action
  );
}

Future<dynamic> onSelectNotification(
  payload,
) async {}

initStateNotification() {
  flutterLocalNotificationsPlugin.initialize(initializationSettings,
      onDidReceiveBackgroundNotificationResponse: notificationTapBackground,
      onDidReceiveNotificationResponse: onSelectNotification);

  FirebaseMessaging.instance.getInitialMessage().then((RemoteMessage? message) {
    if (message != null) {}
  });
  FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
    print(message);
    RemoteNotification? notification = message.notification;
    AndroidNotification? android = message.notification?.android;
    noti(
      notification,
      message.data,
    );
    if (notification != null && android != null && !kIsWeb) {
      String action = message.data['response'].toString();
      print(action);
    }
  });

  FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
    RemoteNotification? notification = message.notification;
    AndroidNotification? android = message.notification?.android;
    noti(
      notification,
      message.data,
    );
    if (notification != null && android != null && !kIsWeb) {
      String action = message.data['response'].toString();
      print(action);
    }
  });
}
