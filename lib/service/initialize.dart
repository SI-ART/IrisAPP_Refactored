import 'dart:io';

import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:iris/service/user/user.dart';
import 'package:iris/utilities/globals.dart';

class IrisInitialize {
  void initIrisApp() {
    FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
        FlutterLocalNotificationsPlugin();
    var initializationSettingsAndroid =
        const AndroidInitializationSettings('ic_notification');
    var initializationSettings =
        InitializationSettings(android: initializationSettingsAndroid);
    flutterLocalNotificationsPlugin.initialize(initializationSettings);
    _messagingFistInit();
    _changeStatusBar();
    _persistenceEnabled();
  }

  FirebaseMessaging messaging = FirebaseMessaging.instance;
  final _reference = FirebaseDatabase.instance
      .reference()
      .child('Users')
      .child(UserData.uid)
      .child('Profile');

  void _messagingFistInit() {
    messaging.subscribeToTopic("messaging");
    messaging.getToken().then((value) {
      _reference.child('token').once().then((DataSnapshot data) {
        if (data.value != value) _reference.update({'token': value});
      });
    });
  }

  void _changeStatusBar() {
    if (Platform.isAndroid) {
      SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.dark.copyWith(
        statusBarColor: Global.white_background,
        systemNavigationBarColor: Global.black_background,
      ));
    }
  }

  void _persistenceEnabled() {
    FirebaseDatabase.instance.setPersistenceEnabled(true);
  }
}
