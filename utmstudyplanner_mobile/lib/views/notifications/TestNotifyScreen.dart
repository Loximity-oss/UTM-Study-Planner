import 'package:flutter/material.dart';
import 'LocalNotifyManager.dart';
import 'ScreenSecond.dart';

class TestNotifyScreen extends StatefulWidget {
  const TestNotifyScreen({Key? key}) : super(key: key);

  @override
  State<TestNotifyScreen> createState() => __TestNotifyScreenState();
}

class __TestNotifyScreenState extends State<TestNotifyScreen> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    localNotifyManager.setOnNotificationReceive(onNotificationReceive);
    localNotifyManager.setOnNotificationClick(onNotificationClick);
  }

  onNotificationReceive(receiveNotification notification) {
    print('Notification Receive: ${notification.id}');
  }

  onNotificationClick(String? payload) {
    print('Payload: $payload');
    Navigator.push(context, MaterialPageRoute(builder: (context) {
      return ScreenSecond(payload: payload);
    }));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Local Notifications"),
        ),
        body: Center(
            child: TextButton(
                onPressed: () async {
                  await localNotifyManager.showNotification();
                  // await localNotifyManager.scheduleNotification();
                },
                child: Text("Send Notification"))));
  }
}
