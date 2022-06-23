import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:mysql_client/mysql_client.dart';
import 'dart:io' show Platform;
import 'package:rxdart/subjects.dart';
import '/../../server/conn.dart';
import 'dart:convert';
import 'package:timezone/standalone.dart' as tz;

class LocalNotifyManager {
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      new FlutterLocalNotificationsPlugin();

  var initSetting;

  BehaviorSubject<receiveNotification> get didReceiveLocalNotificationSubject =>
      BehaviorSubject<receiveNotification>();

  LocalNotifyManager.init() {
    if (Platform.isIOS) {
      requestIOSPermission();
    }
    initializePlatform();
  }

  requestIOSPermission() {
    flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            IOSFlutterLocalNotificationsPlugin>()
        ?.requestPermissions(alert: true, badge: true, sound: true);
  }

  initializePlatform() {
    var initSettingAndroid = AndroidInitializationSettings('logo');
    var initSettingIOS = IOSInitializationSettings(
        requestAlertPermission: true,
        requestBadgePermission: true,
        requestSoundPermission: true,
        onDidReceiveLocalNotification: (int id, title, body, payload) async {
          receiveNotification notification = receiveNotification(
              id: id, title: title, body: body, payload: payload);
          didReceiveLocalNotificationSubject.add(notification);
        });

    initSetting = InitializationSettings(
        android: initSettingAndroid, iOS: initSettingIOS);
  }

  setOnNotificationReceive(Function onNotificationReceive) {
    didReceiveLocalNotificationSubject.listen((notification) {
      onNotificationReceive(notification);
    });
  }

  setOnNotificationClick(Function onNotificationClick) async {
    await flutterLocalNotificationsPlugin.initialize(initSetting,
        onSelectNotification: (String? payload) async {
      onNotificationClick(payload);
    });
  }

  Future showNotification() async {
    var androidChannel = AndroidNotificationDetails(
      'CHANNEL_ID',
      'CHANNEL_NAME',
      channelDescription: 'CHANNEL_DESCRIPTION',
      importance: Importance.max,
      priority: Priority.high,
      playSound: true,
    );

    var iosChannel = IOSNotificationDetails();
    var platformChannel =
        NotificationDetails(android: androidChannel, iOS: iosChannel);

    await flutterLocalNotificationsPlugin.show(
        0, 'Test Title', 'Test Body', platformChannel,
        payload: 'New Payload');
  }

  Future scheduleNotification(IResultSet result) async {
    var androidChannel = AndroidNotificationDetails(
      'CHANNEL_ID',
      'CHANNEL_NAME',
      channelDescription: 'CHANNEL_DESCRIPTION',
      importance: Importance.max,
      priority: Priority.high,
      playSound: true,
    );

    var iosChannel = IOSNotificationDetails();
    var platformChannel =
        NotificationDetails(android: androidChannel, iOS: iosChannel);

    for (var row in result.rows) {
      String scheduleNotificationDateTime =
          row.colByName('fromEvent').toString();

      DateTime dt = DateTime.parse(scheduleNotificationDateTime);

      if (dt.compareTo(DateTime.now()) > 0) {
        var dateType = row.colByName('reminder_date');
        var reminderNumber = int.parse(row.colByName('reminder_number')!);

        if (dateType == "hours") {
          dt = dt.add(Duration(minutes: reminderNumber));
        } else if (dateType == "days") {
          dt = dt.add(Duration(days: reminderNumber));
        } else if (dateType == "weeks") {
          dt = dt.add(Duration(days: reminderNumber * 7));
        }

        await flutterLocalNotificationsPlugin.schedule(
            int.parse(row.colByName('eventID')!),
            row.colByName('eventName'),
            null,
            dt,
            platformChannel,
            payload: 'New Payload');
      }
    }
  }
}

LocalNotifyManager localNotifyManager = LocalNotifyManager.init();

class receiveNotification {
  final int id;
  final String? title;
  final String? body;
  final String? payload;

  receiveNotification(
      {required this.id,
      required this.title,
      required this.body,
      required this.payload});
}
