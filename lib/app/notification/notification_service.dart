import 'dart:developer';
import 'dart:io';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:scheduler/app/database/sql_helper.dart';
import 'package:scheduler/app/database/student_lecture_model.dart';
import 'package:scheduler/app/notification/push_notification.dart';
import 'package:shared_preferences/shared_preferences.dart';

class NotificationService {
  static final FlutterLocalNotificationsPlugin
      _flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

  static const AndroidNotificationChannel pushChannel =
      AndroidNotificationChannel(
    'high_importance_channel', // id
    'High Importance Notifications', // title
    importance: Importance.high,
  );

  static Future<void> _firebaseMessagingBackgroundHandler(
      RemoteMessage message) async {
    await Firebase.initializeApp();
    if (Platform.isIOS) {
      final PushNotification notification = PushNotification(
        title: message.notification?.title,
        body: message.notification?.body,
        dataTitle: message.data['title'] as String?,
        dataBody: message.data['body'] as String?,
      );
      final AndroidNotification? android = message.notification?.android;
      _flutterLocalNotificationsPlugin.show(
        // showing notifications in background
        notification.hashCode,
        notification.title,
        notification.body,

        NotificationDetails(
          android: AndroidNotificationDetails(
            pushChannel.id,
            pushChannel.name,
            channelDescription: pushChannel.description,
            icon: android!.smallIcon,
            importance: Importance.max,
            priority: Priority.high,
          ),
          iOS: const IOSNotificationDetails(
            presentSound: true,
            presentBadge: true,
            presentAlert: true,
          ),
        ),
      );
    }

    await SQLHelper.createItem(StudentLectureModel.fromJson(message.data));
  }

  static Future<void> initializeFirebaseAndNotification() async {
    await Firebase.initializeApp();

    const initialzationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    const initializationSettingsIOS = IOSInitializationSettings(
        onDidReceiveLocalNotification: onDidReceiveLocalNotification);

    const initializationSettings = InitializationSettings(
        android: initialzationSettingsAndroid, iOS: initializationSettingsIOS);

    _flutterLocalNotificationsPlugin.initialize(initializationSettings,
        onSelectNotification: onSelectNotification);

    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
    await _flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(pushChannel);
  }

  static void foregroundNotificationListener() {
    FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
      //Parse the message received
      final PushNotification notification = PushNotification(
        title: message.notification?.title,
        body: message.notification?.body,
        dataTitle: message.data['title'] as String?,
        dataBody: message.data['body'] as String?,
      );

      log("foregroundNotificationListener()");

      log("RemoteMessage foreground: ${message.toString()} ${message.notification.toString()} ${message.notification?.title}, ${message.notification?.body}, ${message.data['title']}, ${message.data['body']}, ${message.data}");

      _flutterLocalNotificationsPlugin.show(
          // showing notifications in background
          notification.hashCode,
          notification.title,
          notification.body,
          NotificationDetails(
            android: AndroidNotificationDetails(
              pushChannel.id,
              pushChannel.name,
              channelDescription: pushChannel.description,
              icon: '@mipmap/ic_launcher',
              importance: Importance.max,
              priority: Priority.high,
            ),
            iOS: const IOSNotificationDetails(
                badgeNumber: 1,
                presentSound: true,
                presentBadge: true,
                presentAlert: true),
          ));

      await SQLHelper.createItem(StudentLectureModel.fromJson(message.data));
    });
  }

  static Future<void> subcribeToTopic(String topic) async {
    await FirebaseMessaging.instance.subscribeToTopic(topic);
  }

  static Future<void> checkForInitialMessage() async {
    await Firebase.initializeApp();
    final RemoteMessage? initialMessage =
        await FirebaseMessaging.instance.getInitialMessage();

    log("checkForInitialMessage()");

    if (initialMessage != null) {
      final PushNotification notification = PushNotification(
        title: initialMessage.notification?.title,
        body: initialMessage.notification?.body,
        dataTitle: initialMessage.data['title'] as String?,
        dataBody: initialMessage.data['body'] as String?,
      );

      _flutterLocalNotificationsPlugin.show(
          notification.hashCode,
          notification.title,
          notification.body,
          NotificationDetails(
            android: AndroidNotificationDetails(
              pushChannel.id,
              pushChannel.name,
              channelDescription: pushChannel.description,
              importance: Importance.max,
              priority: Priority.high,
              icon: '@mipmap/ic_launcher',
            ),
            iOS: const IOSNotificationDetails(
                presentSound: true, presentBadge: true, presentAlert: true),
          ));
    }
  }

  static Future<void> setupFirebaseCloudMessaging() async {
    await _requestNotificationPermissions();
    await _fetchAndUpdatePushNotificationToken();
  }

  static Future<void> _requestNotificationPermissions() async {
    log("requestNotificationPermissions()");
    await _flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            IOSFlutterLocalNotificationsPlugin>()
        ?.requestPermissions(
          alert: true,
          badge: true,
          sound: true,
        );
    final FirebaseMessaging messaging = FirebaseMessaging.instance;
    final NotificationSettings settings = await messaging.requestPermission(
      announcement: true,
      criticalAlert: true,
    );

    log('User granted permission: ${settings.authorizationStatus}');

    // Auto enable notification sounds for some devices
    final status = await Permission.notification.request().isGranted;
    log('User Granted Notificatrion Permissions: $status');

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      log('User granted permission');
      foregroundNotificationListener();
    } else if (settings.authorizationStatus ==
        AuthorizationStatus.provisional) {
      log('User granted provisional permission');
    } else {
      log('User declined or has not accepted permission');
    }
  }

  static Future<void> _fetchAndUpdatePushNotificationToken() async {
    log("fetchAndUpdatePushNotificationToken()");

    try {
      final FirebaseMessaging messaging = FirebaseMessaging.instance;
      final String? token = await messaging.getToken();

      log("push notification token: $token");

      _updatePushNotificationToken(token);
      // Any time the token refreshes, store this in the database too.
      messaging.onTokenRefresh.listen(_updatePushNotificationToken);
    } catch (e) {
      log("fetchAndUpdatePushNotificationToken() error: $e");
    }
  }

  static Future<void> _updatePushNotificationToken(String? token) async {
    if (token != null) {
      // To save the token so we can use it else where
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString('notificationToken', token);
    }
  }

  static Future onSelectNotification(String? payload) async {}

  static Future onDidReceiveLocalNotification(
      int id, String? title, String? body, String? payload) async {
    log('Notification RECEIVED');
    return Future.value(0);
  }
}
