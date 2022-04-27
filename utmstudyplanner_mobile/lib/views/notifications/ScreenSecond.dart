import 'package:flutter/material.dart';

class ScreenSecond extends StatefulWidget {
  final String? payload;

  ScreenSecond({required this.payload});

  @override
  State<ScreenSecond> createState() => _ScreenSecondState();
}

class _ScreenSecondState extends State<ScreenSecond> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Test Screen Second"),
        ),
        body: Center(
          child: Text("widget.payload"),
        ));
  }
}
