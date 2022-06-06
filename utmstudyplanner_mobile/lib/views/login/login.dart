import 'dart:async';
import 'dart:convert';
import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:utmstudyplanner_mobile/views/register.dart';

import '../../server/conn.dart';
import '../home/homescreen.dart';
import '../onboarding.dart';
import 'package:http/http.dart' as http;

import '../verifyEmail.dart';

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

  Future userLogin() async {
    setState(() {
      visible = true;
    });
    // Getting value from Controller
    String email = emailInput.text;
    String password = passwordInput.text;

    // clearly there is a better way to do this
    // but this is for SP2 presentation.
    // will change using future later.

    try {
      var db = Mysql();
      String query =
          'SELECT `id`,`email`, `name`, `coursecode`, `password`, `verificationStatus` FROM `users` WHERE `email` = "' +
              email +
              '" AND `password` = "' +
              password +
              '"';
      var result = await db.execQuery(query);
      if (result.numOfRows == 1) {
        for (final row in result.rows) {
          if (row.colAt(5) == '0') {
            setState(() {
              visible = false;
            });

            showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  title: const Text(
                      'Your email is not verified. Proceeding into OTP Email Verification.'),
                  actions: <Widget>[
                    FlatButton(
                      child: const Text("OK"),
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => verifyEmail(
                                    email: email, password: password)));
                      },
                    ),
                  ],
                );
              },
            );
          } else {
            box.put('email', email);
            box.put('password', password);
            box.put('nickname', row.colAt(2));
            box.put('matricID', row.colAt(0));
            box.put('coursecode', row.colAt(3));
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => const homepage()));
          }
        }
      } else {
        throw Exception('Invalid Email or Password');
      }
    } catch (e) {
      setState(() {
        visible = false;
      });
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(e.toString()),
            actions: <Widget>[
              FlatButton(
                child: const Text("OK"),
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
    return Scaffold(
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
                    const Text('Welcome!',
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold)),
                    const Text('UTM Study Planner System',
                        style: TextStyle(fontSize: 15)),
                    const SizedBox(height: 20),
                    Form(
                      key: _formLoginKey,
                      child: Column(
                        children: <Widget>[
                          TextFormField(
                            controller: emailInput,
                            style: const TextStyle(fontSize: 14),
                            textInputAction: TextInputAction.next,
                            autovalidateMode:
                                AutovalidateMode.onUserInteraction,
                            validator: (value) =>
                                EmailValidator.validate(value!)
                                    ? null
                                    : "Please enter a valid email",
                            enableSuggestions: false,
                            autocorrect: false,
                            decoration: InputDecoration(
                                contentPadding:
                                    const EdgeInsets.only(left: 20, right: 20),
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
                          TextFormField(
                            controller: passwordInput,
                            textInputAction: TextInputAction.done,
                            autovalidateMode:
                                AutovalidateMode.onUserInteraction,
                            validator: (value) => value == null || value.isEmpty
                                ? 'Please enter your password.'
                                : null,
                            style: const TextStyle(fontSize: 14),
                            obscureText: true,
                            enableSuggestions: false,
                            autocorrect: false,
                            decoration: InputDecoration(
                                contentPadding:
                                    const EdgeInsets.only(left: 20, right: 20),
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
                            child: const Text(
                                "Don't have an account? Click me!",
                                style: TextStyle(
                                    fontSize: 11, fontWeight: FontWeight.bold)),
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => const registerPage()),
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
                              onPressed: () =>
                                  _formLoginKey.currentState!.validate()
                                      ? userLogin()
                                      : null,
                              child: const Text(
                                'Login',
                                style: TextStyle(
                                  fontSize: 18,
                                  color: Colors.white,
                                ),
                              ),
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
                            child: const CircularProgressIndicator(
                                color: Color.fromARGB(255, 93, 6, 29)))),
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
