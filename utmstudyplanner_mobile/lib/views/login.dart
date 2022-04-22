import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'onboarding.dart';

class loginPage extends StatelessWidget {
  const loginPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final box = Hive.box('');
    box.put('introduction', true);
    bool firstTimeState = box.get('introduction') ?? true;
    return firstTimeState
        ? const IntroductionPage()
        : Scaffold(
      appBar: AppBar(),
      body: const Center(
        child: Text('Your Home Page'),
      ),
    );
  }
}