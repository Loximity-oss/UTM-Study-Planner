import 'dart:convert';
import 'package:email_validator/email_validator.dart';
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
  final box = Hive.box('');
  final TextEditingController emailInput = TextEditingController();
  final TextEditingController passwordInput = TextEditingController();
  final _formLoginKey = GlobalKey<FormState>();
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
    // If the Response Message is Matched.
    if(message == "True")
    {
      box.put('email', email);
      box.put('password', password);
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
            title: Text(message),
            actions: <Widget>[
              FlatButton(
                child: Text("OK"),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
    }
  }


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
                    Form(
                      key: _formLoginKey,
                      child: Column(
                        children:  <Widget>[
                          TextFormField(controller: emailInput,
                            style: const TextStyle(fontSize: 14),
                            textInputAction: TextInputAction.next,
                            autovalidateMode: AutovalidateMode.onUserInteraction,
                            validator: (value) => EmailValidator.validate(value!) ? null : "Please enter a valid email",
                            enableSuggestions: false,
                            autocorrect: false,
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
                          TextFormField(controller: passwordInput,
                            textInputAction: TextInputAction.done,
                            autovalidateMode: AutovalidateMode.onUserInteraction,
                            validator:  (value) => value == null || value.isEmpty ? 'Please enter your password.' : null,
                            style: const TextStyle(fontSize: 14),
                            obscureText: true,
                            enableSuggestions: false,
                            autocorrect: false,
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
                              Navigator.push(context,
                                MaterialPageRoute(builder: (context) => const registerPage()),
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
                              onPressed: () => _formLoginKey.currentState!.validate() ? userLogin() : null,
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

                    const SizedBox(height: 20),
                    Visibility(
                        visible: visible,
                        child: Container(
                            margin: const EdgeInsets.only(bottom: 30),
                            child: const CircularProgressIndicator(color: Color.fromARGB(255, 93, 6, 29))
                        )
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