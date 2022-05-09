import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:utmstudyplanner_mobile/views/home/calendar.dart';
import 'package:utmstudyplanner_mobile/views/home/calendarv2.dart';
import 'package:utmstudyplanner_mobile/views/onboarding.dart';
import 'dart:async';
import 'views/login/login.dart';
import 'views/home/homescreen.dart';

import 'package:http/http.dart' as http;


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
    String email, password;
    email = box.get('email');
    password = box.get('password');

    if(email.isNotEmpty && password.isNotEmpty){
      // SERVER LOGIN API URL
      var url = Uri.parse('http://192.168.68.104/login.php');
      // Store all data with Param Name.
      var data = {'email': email, 'password' : password};
      // Starting Web API Call.
      var response = await http.post(
          url,
          headers: {"Content-Type": "application/json"},
          body: json.encode(data)
      );
      // Getting Server response into variable.
      var message = jsonDecode(response.body);
      if(message == "True") {
        Timer(const Duration(seconds: 5),
                ()=>Navigator.pushReplacement(context,
                MaterialPageRoute(builder:
                    (context) => homepage()
                )
            )
        );
      } else {
        box.put('email','');
        box.put('password','');
      }
    } else {
      Timer(const Duration(seconds: 5),
              ()=>Navigator.pushReplacement(context,
              MaterialPageRoute(builder:
                  (context) => loginPage()
              )
          )
      );
    }
  }

  @override
  void initState()  {
    super.initState();
    bool firstTimeState = box.get('introduction') ?? true;
    print(firstTimeState);

    Timer(const Duration(seconds: 5),
            ()=>Navigator.pushReplacement(context,
            MaterialPageRoute(builder:
                (context) => CalendarApp()
            )
        )
    );

    /*if(firstTimeState){
      Timer(const Duration(seconds: 5),
              ()=>Navigator.pushReplacement(context,
              MaterialPageRoute(builder:
                  (context) => IntroductionPage()
              )
          )
      );
    } else {
      //autoLogIn();
    }*/
  }
  @override
  Widget build(BuildContext context) {
    return Container(
        color: Colors.white,
        child: Image.asset("assets/splash.png")
    );
  }
}
