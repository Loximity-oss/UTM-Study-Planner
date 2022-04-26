import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:utmstudyplanner_mobile/views/register.dart';
import '../home/homescreen.dart';
import '../onboarding.dart';

class loginPage extends StatefulWidget {
  const loginPage({Key? key}) : super(key: key);

  @override
  State<loginPage> createState() => _loginPageState();
}

class _loginPageState extends State<loginPage> {
  @override
  final TextEditingController usernameInput = TextEditingController();
  final TextEditingController passwordInput = TextEditingController();
  Widget build(BuildContext context) {

    final box = Hive.box('');
    bool firstTimeState = box.get('introduction') ?? true;
    return firstTimeState
        ? const IntroductionPage()
        : Scaffold(
      body: Center(
        child: SingleChildScrollView(
          reverse: true,
          padding: EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(
              width: 350,
              height: 350,
              child: Image.asset('assets/signup/mobile_3.png'),
            ),
            Padding(padding: EdgeInsets.only(
              left: 50,
              right: 50,
              bottom: 10,
            ),
              child: TextField(
                controller: usernameInput,
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 20,
                ),
                cursorColor: Colors.black,
                decoration: InputDecoration(
                    hintText: 'Username',
                    hintStyle: TextStyle(color: Colors.orange),
                    border: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.red)
                    ),
                    focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.red)
                    )
                ),
              ),
            ),


            Padding(padding: EdgeInsets.only(
              left: 50,
              right: 50,
              bottom: 20,
            ),
              child: TextField(
                controller: passwordInput,
                obscureText: true,
                style: const TextStyle(
                  color: Colors.black,
                  fontSize: 20,
                ),
                cursorColor: Colors.black,
                decoration: const InputDecoration(
                    hintText: 'Password',
                    hintStyle: TextStyle(color: Colors.orange),
                    border: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.red)
                    ),
                    focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.red)
                    )
                ),
              ),
            ),

            Container(
              width: MediaQuery.of(context).size.width / 2.0,
              height: 40,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(35.0),
                color: Colors.red[900],
              ),
              child: MaterialButton(
                onPressed: () {
                  print('Username: '+usernameInput.text);
                  print('Password: '+passwordInput.text);

                  //Routing to a different page
                  Navigator.push(context,
                    MaterialPageRoute(builder: (context) => homepage()),
                  );
                },
                child: Text('Login',
                    style: TextStyle(
                      fontSize: 19,
                      color: Colors.white,
                  ),),

              ),
            ),


            TextButton(
              child:
              Text("Don't have an account? Click me!"),
              onPressed: () {
                print('Pressed');
                Navigator.push(context,
                  MaterialPageRoute(builder: (context) => registerPage()),
                );
              },
            ),

          ],
        ),
      ),
      ),
    );
  }
}