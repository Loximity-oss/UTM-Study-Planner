import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:introduction_screen/introduction_screen.dart';
import 'package:utmstudyplanner_mobile/views/home/homescreen.dart';

import 'login.dart';

class IntroductionPage extends StatelessWidget {
  const IntroductionPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final box = Hive.box('');

    return Scaffold(
      appBar: AppBar(backgroundColor: const Color.fromRGBO(93, 6, 29, 1.0), title: const Text('Welcome')),
      body: IntroductionScreen(
        globalBackgroundColor: Colors.white,
        pages: [
          PageViewModel(
            title: "Stay organized",
            body: "This application intends to automate your university life planning easier.",
            image: Center(
              child: Image.asset(
                  'assets/onboarding/onboarding-1.png'),
            ),
          ),
          PageViewModel(
            title: "Timetable syncing with faculty",
            body: "Avoid last minute changes by academic staff by having to sort your timetable.",
            image: Center(
              child: Image.asset(
                  'assets/onboarding/onboarding-2.png'),
            ),
          ),
          PageViewModel(
            title: "Available in Mobile and Web",
            body: "Access this system anywhere you wish.",
            image: Center(
              child: Image.asset(
                  'assets/onboarding/onboarding-3.png'),
            ),
          ),
        ],
        onDone: () {
          box.put('introduction', false);
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(
              builder: (BuildContext context) {
                return homepage();
              },
            ),
          );
        },
        skip: const Icon(Icons.skip_next, color: Color.fromRGBO(93, 6, 29, 1.0)),
        next: const Icon(Icons.forward, color: Color.fromRGBO(93, 6, 29, 1.0)),
        done: const Text("Done", style: TextStyle(fontWeight: FontWeight.w600, color: Color.fromRGBO(93, 6, 29, 1.0))),
        dotsDecorator: DotsDecorator(
            size: const Size.square(10.0),
            activeSize: const Size(20.0, 10.0),
            activeColor: const Color.fromRGBO(93, 6, 29, 1.0),
            color: Colors.black26,
            spacing: const EdgeInsets.symmetric(horizontal: 3.0),
            activeShape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(25.0))),
      ),
    );
  }
}