/**
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:utmstudyplanner_mobile/views/register.dart';
import '../home/homescreen.dart';
import '../onboarding.dart';

class loginPage extends StatelessWidget {
  const loginPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    TextEditingController usernameInput = TextEditingController();
    TextEditingController passwordInput = TextEditingController();
    final box = Hive.box('');
    bool firstTimeState = box.get('introduction') ?? true;
    return firstTimeState
        ? const IntroductionPage()
        : Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text("Logo"),
            Padding(padding: EdgeInsets.only(
              left: 50,
              right: 50,
              bottom: 10,
            ),
              child: TextField(
                controller: usernameInput,
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 22,
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
                  fontSize: 22,
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
              width: MediaQuery.of(context).size.width / 1.3,
              height: 50,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(35.0),
                color: Colors.amber,
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
                child: Text('Login'),

              ),
            ),

            TextButton(
              child: Text("Don't have an account? Click me!"),
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
    );
  }
}

import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:utmstudyplanner_mobile/views/login/login.dart';
import 'onboarding.dart';

void main() => runApp(const registerPage());

class registerPage extends StatelessWidget {
  const registerPage({Key? key}) : super(key: key);

  static const String _title = 'Flutter Code Sample';

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: _title,
      home: Scaffold(
        appBar: AppBar(title: const Text(_title)),
        body: const MyStatefulWidget(),
      ),
    );
  }
}



// REGISTER TEMP
class MyStatefulWidget extends StatefulWidget {
  const MyStatefulWidget({Key? key}) : super(key: key);

  @override
  State<MyStatefulWidget> createState() => _MyStatefulWidgetState();
}

class _MyStatefulWidgetState extends State<MyStatefulWidget> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          TextFormField(
            decoration: const InputDecoration(
              hintText: 'Enter your email',
            ),
            validator: (String? value) {
              if (value == null || value.isEmpty) {
                return 'Please enter your email';
              }
              return null;
            },
          ),
          TextFormField(
            decoration: const InputDecoration(
              hintText: 'Enter your username',
            ),
            validator: (String? value) {
              if (value == null || value.isEmpty) {
                return 'Please enter a username';
              }
              return null;
            },
          ),

          TextFormField(
            decoration: const InputDecoration(
              hintText: 'Enter your name',
            ),
            validator: (String? value) {
              if (value == null || value.isEmpty) {
                return 'Please enter your name';
              }
              return null;
            },
          ),

          Padding(
            padding: const EdgeInsets.symmetric(vertical: 16.0),
            child: ElevatedButton(
              onPressed: () {
                // Validate will return true if the form is valid, or false if
                // the form is invalid.
                if (_formKey.currentState!.validate()) {
                  // Process data.
                }
              },
              child: const Text('Submit'),
            ),
          ),
        ],
      ),
    );
  }
}
**/
