import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:introduction_screen/introduction_screen.dart';
import 'package:utmstudyplanner_mobile/views/login.dart';

import 'login.dart';

class IntroductionPage extends StatelessWidget {
  const IntroductionPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final box = Hive.box('');

    return Scaffold(
      body: IntroductionScreen(
        pages: [
          PageViewModel(
            title: 'Title of 1st Page', //Basic String Title
            body: 'Body of 1st Page', //Basic String Body
            decoration:
            const PageDecoration(), //Page decoration Contain all page customizations
            image: Center(
              child: Image.asset(
                  'assets/onboarding/onboarding-1.png'),
            ), //If you want to you can also wrap around Alignment
            reverse: false, //If widget Order is reverse - body before image
            footer: const Text('Footer'), //You can add button here for instance
          ),
          PageViewModel(

            title: 'Title of 1st Page', //Basic String Title
            body: 'Body of 1st Page', //Basic String Body
            decoration:
            const PageDecoration(), //Page decoration Contain all page customizations
            image: Center(
              child: Image.asset(
                  'assets/onboarding/onboarding-2.png'),
            ), //If you want to you can also wrap around Alignment
            reverse: false, //If widget Order is reverse - body before image
            footer: const Text('Footer'), //You can add button here for instance
          ),
          PageViewModel(
            title: 'Title of 1st Page', //Basic String Title
            body: 'Body of 1st Page', //Basic String Body
            decoration:
            const PageDecoration(), //Page decoration Contain all page customizations
            image: Center(
              child: Image.asset(
                  'assets/onboarding/onboarding-3.png'),
            ), //If you want to you can also wrap around Alignment
            reverse: false, //If widget Order is reverse - body before image
            footer: const Text('Footer'), //You can add button here for instance
          ),

        ],
        onDone: () {
          box.put('introduction', false);
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(
              builder: (BuildContext context) {
                return const loginPage();
              },
            ),
          );
        },
        skip: const Icon(Icons.skip_next),
        next: const Icon(Icons.forward),
        done: const Text("Done", style: TextStyle(fontWeight: FontWeight.w600)),
        dotsDecorator: DotsDecorator(
            size: const Size.square(10.0),
            activeSize: const Size(20.0, 10.0),
            activeColor: Colors.blue,
            color: Colors.black26,
            spacing: const EdgeInsets.symmetric(horizontal: 3.0),
            activeShape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(25.0))),
      ),
    );
  }
}