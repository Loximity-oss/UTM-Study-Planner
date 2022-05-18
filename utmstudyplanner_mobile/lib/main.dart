
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:utmstudyplanner_mobile/views/onboarding.dart';
import 'dart:async';

import 'package:utmstudyplanner_mobile/server/conn.dart';
import 'views/login/login.dart';
import 'views/home/homescreen.dart';

void main() async{
  await Hive.initFlutter();
  await Hive.openBox('');
  runApp(MaterialApp(home: SplashScreen()));
}

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}
class _SplashScreenState extends State<SplashScreen> {
  final box = Hive.box('');

  void autoLogIn() async{
    // get Stored Usernames
    String a = box.get('email');
    String b = box.get('password');


    //check if cleared.
    //TODO corruption check
    if(a.isNotEmpty && b.isNotEmpty){
      var db = Mysql();
      String query = 'SELECT * FROM `users` WHERE `email` = "'+ a +'" AND password = "' + b + '"';
      var result = await db.execQuery(query);

      
      //todo shorten
      if(result.numOfRows == 1){
        Timer(const Duration(seconds: 5),
                ()=>Navigator.pushReplacement(context,
                MaterialPageRoute(builder:
                    (context) => homepage()
                )
            )
        );
      } else {
        box.put('email', '');
        box.put('password', '');

        box.put('nickname', '');
        box.put('matricID','');
        box.put('image','');
        box.put('coursecode','');

        Timer(const Duration(seconds: 5),
                ()=>Navigator.pushReplacement(context,
                MaterialPageRoute(builder:
                    (context) => const loginPage()
                )
            )
        );
      }
    } else {
      Timer(const Duration(seconds: 5),
              ()=>Navigator.pushReplacement(context,
              MaterialPageRoute(builder:
                  (context) => const loginPage()
              )
          )
      );
    }
  }

  @override
  void initState()  {
    super.initState();

    // firstTime Launch
    // if null or true, proceed to onBoarding.
    // set LaunchKey False when user clicks onDone() in onboarding.

    if(box.get('firstLaunchKey') ?? true){
      box.put('password', '');
      box.put('email', '');
      box.put('nickname', '');
      box.put('matricID','');
      box.put('coursecode','');
      Timer(const Duration(seconds: 5),
              ()=>Navigator.pushReplacement(context,
              MaterialPageRoute(builder:
                  (context) => const IntroductionPage()
              )
          )
      );
    } else {
      autoLogIn();
    }

  }

  @override
  Widget build(BuildContext context) {
    return Container(
        color: Colors.white,
        child: Image.asset("assets/splash.png")
    );
  }
}
