import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:utmstudyplanner_mobile/views/register.dart';

class registerPage extends StatefulWidget {
  const registerPage({Key? key}) : super(key: key);

  @override
  State<registerPage> createState() => _registerPageState();
}

class _registerPageState extends State<registerPage> {
  final TextEditingController nameInput = TextEditingController();
  final TextEditingController courseInput = TextEditingController();
  final TextEditingController emailInput = TextEditingController();
  final TextEditingController usernameInput = TextEditingController();
  final TextEditingController passwordInput = TextEditingController();
  @override
  Widget build(BuildContext context) {
        return Scaffold(
      body: Center(
        child: SingleChildScrollView(
        reverse: true,
        padding: EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text('Welcome Aboard!',
              style: TextStyle(
              color: Colors.black,
                fontSize: 25,
            ),
            ),
            Padding(padding: EdgeInsets.only(
              left: 50,
              right: 50,
              bottom: 10,
            ),
              child: TextField(
                controller: nameInput,
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 18,
                ),
                cursorColor: Colors.black,
                decoration: InputDecoration(
                    hintText: 'Full Name',
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
              bottom: 10,
            ),
              child: TextField(
                controller: courseInput,
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 18,
                ),
                cursorColor: Colors.black,
                decoration: InputDecoration(
                    hintText: 'Course Code',
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
              bottom: 10,
            ),
              child: TextField(
                controller: emailInput,
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 18,
                ),
                cursorColor: Colors.black,
                decoration: InputDecoration(
                    hintText: 'E-mail',
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
              bottom: 10,
            ),
              child: TextField(
                controller: usernameInput,
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 18,
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
              bottom: 40,
            ),
              child: TextField(
                controller: passwordInput,
                obscureText: true,
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 18,
                ),
                cursorColor: Colors.black,
                decoration: InputDecoration(
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
              width: MediaQuery.of(context).size.width / 1.5,
              height: 45,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(35.0),
                color: Colors.red,
              ),
              child: MaterialButton(
                onPressed: () {
                  print('Username: '+usernameInput.text);
                  print('Password: '+passwordInput.text);
                },
                child: Text('Sign Up',
                  style: TextStyle(
                    fontSize: 20,
                  color: Colors.white,
                ),
                ),

              ),
            ),

          ],
        ),
      ),
      ),
    );
  }
}