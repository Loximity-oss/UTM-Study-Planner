// UTM Study Planner
//
//
//


import 'dart:convert';
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:utmstudyplanner_mobile/server/conn.dart';
import 'package:utmstudyplanner_mobile/views/onboarding.dart';
import 'package:utmstudyplanner_mobile/server/conn.dart';

import 'views/login/login.dart';
import 'views/home/homescreen.dart';



void main() async{
  await Hive.initFlutter();
  await Hive.openBox('');
  runApp(const MaterialApp(home: SplashScreen()));
}

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  _SplashScreenState createState() => _SplashScreenState();
}
class _SplashScreenState extends State<SplashScreen> {
  final box = Hive.box('');

  //  Autologin Feature
  //  Get email/password from local Hive NOSQL.
  //  Verify with DB then go to Dashboard.

  void autoLogIn() async{
    String email, password;
    try{
      email = box.get('email');
      password = box.get('password');

      var db = new Mysql();
      db.getConnection().then((conn) async {
        conn.query("SELECT * FROM user WHERE email = ? AND password = ?", [email, password]).then((results) {
          if(results.length == 1){
            Timer(const Duration(seconds: 5),
                    ()=>Navigator.pushReplacement(context,
                    MaterialPageRoute(builder:
                        (context) => homepage()
                    )
                )
            );
          } else {
            //clear entries if no match.
            box.put('email','');
            box.put('password','');
          }
        });
        conn.close();
      });
    } catch (e){
      Timer(const Duration(seconds: 5),
              ()=>Navigator.pushReplacement(context,
              MaterialPageRoute(builder:
                  (context) => const loginPage()
              )
          )
      );
    }



  }//end AutoLogin


  //  Jump to onboarding if firstTimeState is false.
  //  If true jump to loginPage (after AutoLogin = failed) OR no content in Hive NOSQL

  @override
  void initState()  {
    super.initState();
    bool firstTimeState = box.get('introduction') ?? true;

    if(firstTimeState){
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

  //  SplashScreen

  @override
  Widget build(BuildContext context) {
    return Container(
        color: Colors.white,
        child: Image.asset("assets/splash.png")
    );
  }
}
