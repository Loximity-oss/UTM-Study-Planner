import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:utmstudyplanner_mobile/views/register.dart';
import '../home/homescreen.dart';
import '../onboarding.dart';
import 'package:http/http.dart' as http;

class loginPage extends StatefulWidget {
  const loginPage({Key? key}) : super(key: key);

  @override
  State<loginPage> createState() => _loginPageState();
}

class _loginPageState extends State<loginPage> {
  @override
  final TextEditingController emailInput = TextEditingController();
  final TextEditingController passwordInput = TextEditingController();
  bool visible = false;

  Future userLogin() async{
  // Showing CircularProgressIndicator.
    setState(() {
      visible = true ;
    });

    // Getting value from Controller
    String email = emailInput.text;
    String password = passwordInput.text;

    // SERVER LOGIN API URL
    var url = Uri.parse('https://192.168.56.1/login.php');

    // Store all data with Param Name.
    var data = {'email': email, 'password' : password};

    // Starting Web API Call.
    var response = await http.post(url, body: json.encode(data));

    // Getting Server response into variable.
    var message = jsonDecode(response.body);
    print(message);
    // If the Response Message is Matched.
    if(message == 'Login Matched')
    {

      // Hiding the CircularProgressIndicator.
      setState(() {
        visible = false;
      });

      // Navigate to Profile Screen & Sending Email to Next Screen.
      Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => homepage())
      );
    }else{

      // If Email or Password did not Matched.
      // Hiding the CircularProgressIndicator.
      setState(() {
        visible = false;
      });

      // Showing Alert Dialog with Response JSON Message.
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: new Text(message),
            actions: <Widget>[
              FlatButton(
                child: new Text("OK"),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );}
  }
  var url = "https://externalapp.localhost/login.php";

  Widget build(BuildContext context) {

    final box = Hive.box('');
    bool firstTimeState = box.get('introduction') ?? true;
    return firstTimeState
        ? const IntroductionPage()
        : Scaffold(
      backgroundColor: const Color.fromARGB(255, 255, 249, 235),
      body: SingleChildScrollView(
        padding: const EdgeInsets.only(top: 120, bottom: 100),
        child: Center(
          child: Column(
            children: <Widget>[
              Container(
                width: 300,
                height: 300,
                child: Image.asset('assets/signup/mobile_1.png'),
              ),
              //Username and Password Containers
              Container(
                padding: const EdgeInsets.only(left: 50, right: 50),
                child: Column(
                  children: [
                    const SizedBox(height: 5),
                    const Text('Welcome!', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                    const Text('UTM Study Planner System', style: TextStyle(fontSize: 15)),
                    const SizedBox(height: 20),
                    TextField(controller: emailInput,
                      style: const TextStyle(fontSize: 14),
                      decoration: InputDecoration(
                          contentPadding: const EdgeInsets.only(left: 20, right: 20),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(30.0),
                            borderSide: const BorderSide(
                              width: 0,
                              style: BorderStyle.none,
                            ),
                          ),
                          filled: true,
                          hintStyle: TextStyle(color: Colors.grey[800]),
                          hintText: "Email",
                          fillColor: Colors.white),
                      ),
                    const SizedBox(height: 10),
                    TextField(controller: passwordInput,
                      style: const TextStyle(fontSize: 14),
                      decoration: InputDecoration(
                          contentPadding: const EdgeInsets.only(left: 20, right: 20),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(30.0),
                            borderSide: const BorderSide(
                              width: 0,
                              style: BorderStyle.none,
                            ),
                          ),
                          filled: true,
                          hintStyle: TextStyle(color: Colors.grey[800]),
                          hintText: "Password",
                          fillColor: Colors.white),
                    ),
                    TextButton(
                      child:
                      const Text("Don't have an account? Click me!", style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold)),
                      onPressed: () {
                        print('Pressed');
                        Navigator.push(context,
                          MaterialPageRoute(builder: (context) => registerPage()),
                        );
                      },
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width / 2.0,
                      height: 40,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(35.0),
                        color: const Color.fromARGB(255, 93, 6, 29),
                      ),
                      child: MaterialButton(
                        onPressed: userLogin,
                        child: const Text('Login',
                          style: TextStyle(
                            fontSize: 18,
                            color: Colors.white,
                          ),),

                      ),
                    ),
                  ],
                ),
              ),



            ],
          ),
        ),
      ),
    );
  }
}