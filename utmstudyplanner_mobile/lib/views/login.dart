import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'home/homescreen.dart';
import 'onboarding.dart';

class loginPage extends StatelessWidget {
  const loginPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final box = Hive.box('');
    bool firstTimeState = box.get('introduction') ?? true;
    return firstTimeState
        ? const IntroductionPage()
        : homepage();
  }
}