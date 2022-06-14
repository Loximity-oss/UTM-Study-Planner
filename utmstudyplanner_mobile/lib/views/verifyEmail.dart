import 'dart:async';
import 'package:email_auth/email_auth.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:utmstudyplanner_mobile/server/auth.config.dart';

import '../server/conn.dart';

class verifyEmail extends StatefulWidget {
  final String email;
  final String password;

  const verifyEmail({Key? key, required this.email, required this.password})
      : super(key: key);

  @override
  State<verifyEmail> createState() => _verifyEmail();
}

class _verifyEmail extends State<verifyEmail> {
  @override
  final box = Hive.box('');
  final TextEditingController userOTP = TextEditingController();
  final TextEditingController emailInput = TextEditingController();
  final _formOTPKey = GlobalKey<FormState>();
  final _formRetypeEmailKey = GlobalKey<FormState>();
  late String email;

  bool visible = true;

  //timer OTP settings
  late Timer _timer;
  int _start = 30;
  String otpText = 'Send OTP';
  EmailAuth emailAuth = EmailAuth(sessionName: "UTM Study Planner");


  @override
  void initState() {
    emailAuth.config(remoteServerConfiguration);
    email = widget.email;
    super.initState();
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  void sendOTP() async {
    setState(() {
      visible = false;
    });
    final scaffold = ScaffoldMessenger.of(context);
    var res = await emailAuth.sendOtp(recipientMail: email, otpLength: 5);
    if (res) {
      startTimer();
      scaffold.showSnackBar(
        SnackBar(
          content: const Text('OTP Sent.'),
          action: SnackBarAction(
              label: 'OK', onPressed: scaffold.hideCurrentSnackBar),
        ),
      );
    } else {
      setState(() {
        visible = true;
      });
      scaffold.showSnackBar(
        SnackBar(
          content: const Text(
              'Error: OTP not sent. Check your internet connection.'),
          action: SnackBarAction(
              label: 'OK', onPressed: scaffold.hideCurrentSnackBar),
        ),
      );
    }
  }

  Future<void> verifyOTP() async {
    final scaffold = ScaffoldMessenger.of(context);
    var res =
        emailAuth.validateOtp(recipientMail: email, userOtp: userOTP.text);
    if (res) {
      var db = Mysql();
      String query =
          'UPDATE `users` SET `verificationStatus` = "1" WHERE `email` = "' +
              email +
              '" AND `password` = "' +
              widget.password +
              '"';
      try {
        var result = await db.execQuery(query);
        if (result.affectedRows.toInt() == 1) {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: const Text(
                    'Your account has been verified. You may login now.'),
                actions: <Widget>[
                  FlatButton(
                    child: const Text("OK"),
                    onPressed: () {
                      Navigator.of(context).pop();
                      Navigator.of(context).pop();
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              );
            },
          );
        } else {
          throw Exception('Invalid Method Handling');
        }
      } catch (e) {
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
    } else {
      scaffold.showSnackBar(
        SnackBar(
          content: const Text('Invalid OTP.'),
          action: SnackBarAction(
              label: 'OK', onPressed: scaffold.hideCurrentSnackBar),
        ),
      );
    }
  }

  Future retypeEmail() async {
    var db = Mysql();
    String query = 'UPDATE `users` SET `email` = "' +
        emailInput.text +
        '"  WHERE `email` = "' +
        email +
        '" AND `password` = "' +
        widget.password +
        '"';
    try {
      var result = await db.execQuery(query);
      if (result.affectedRows.toInt() == 1) {
        email = emailInput.text;
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text('Email updated successfully.'),
              actions: <Widget>[
                FlatButton(
                  child: const Text("OK"),
                  onPressed: () {
                    Navigator.of(context).pop();
                    Navigator.of(context).pop();
                  },
                ),
              ],
            );
          },
        );
      } else {
        throw Exception('Duplicate Email');
      }
    } catch (e) {
      return AlertDialog(
        title: Text(e.toString()),
        actions: <Widget>[
          FlatButton(
            child: const Text("OK"),
            onPressed: () {
              Navigator.of(context).pop();
              Navigator.of(context).pop();
            },
          ),
        ],
      );
    }
  }

  void startTimer() {
    const oneSec = Duration(seconds: 1);
    _timer = Timer.periodic(
      oneSec,
      (Timer timer) {
        if (_start == 0) {
          setState(() {
            _start = 30;
            visible = true;
            timer.cancel();
            otpText = 'Send OTP';
          });
        } else {
          setState(() {
            visible = false;
            otpText = _start.toString() + ' s';
            _start--;
          });
        }
      },
    );
  }

  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        backgroundColor: const Color.fromARGB(255, 255, 249, 235),
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: const Text('Email Verification',
              style: TextStyle(color: Colors.black)),
          backgroundColor: Colors.transparent,
          iconTheme: (const IconThemeData(color: Colors.black)),
          elevation: 0,
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.only(top: 120, bottom: 100),
          child: Center(
            child: Column(
              children: <Widget>[
                Container(
                  width: 500,
                  height: 300,
                  child: Image.asset('assets/verify_email/hand_verify.png'),
                ),
                //Username and Password Containers
                Container(
                  padding: const EdgeInsets.only(left: 50, right: 50),
                  child: Column(
                    children: [
                      const SizedBox(height: 5),
                      const Text('Verify Email',
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold)),
                      const SizedBox(height: 20),
                      Form(
                        key: _formOTPKey,
                        child: Column(
                          children: <Widget>[
                            TextFormField(
                              controller: userOTP,
                              style: const TextStyle(fontSize: 14),
                              decoration: InputDecoration(
                                  contentPadding: const EdgeInsets.only(
                                      left: 20, right: 20),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(30.0),
                                    borderSide: const BorderSide(
                                      width: 0,
                                      style: BorderStyle.none,
                                    ),
                                  ),
                                  suffixIcon: TextButton(
                                    child: Text(otpText),
                                    onPressed: visible ? () => sendOTP() : null,
                                  ),
                                  filled: true,
                                  hintStyle: TextStyle(color: Colors.grey[800]),
                                  hintText: "OTP",
                                  fillColor: Colors.white),
                            ),
                            const SizedBox(height: 20),
                          ],
                        ),
                      ),
                      TextButton(
                        child: const Text("Wrong Email Address?",
                            style: TextStyle(
                                fontSize: 11, fontWeight: FontWeight.bold)),
                        onPressed: () {
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: const Text('Change Email'),
                                content: Form(
                                  key: _formRetypeEmailKey,
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.stretch,
                                    mainAxisSize: MainAxisSize.min,
                                    children: <Widget>[
                                      TextFormField(
                                        enableSuggestions: false,
                                        autocorrect: false,
                                        controller: emailInput,
                                        textInputAction: TextInputAction.next,
                                        decoration: const InputDecoration(
                                            hintText: 'New Email'),
                                        autovalidateMode:
                                            AutovalidateMode.onUserInteraction,
                                        validator: (value) =>
                                            EmailValidator.validate(value!)
                                                ? null
                                                : "Please enter a valid email.",
                                      ),
                                      TextFormField(
                                          enableSuggestions: false,
                                          autocorrect: false,
                                          decoration: const InputDecoration(
                                              hintText: 'Confirm New Email'),
                                          autovalidateMode: AutovalidateMode
                                              .onUserInteraction,
                                          validator: (emailCheck) {
                                            if (emailCheck == null ||
                                                emailCheck.isEmpty) {
                                              return 'Please enter an email address.';
                                            } else if (emailCheck !=
                                                emailInput.text) {
                                              return 'Email Addresses do not match.';
                                            } else {
                                              return null;
                                            }
                                          }),
                                    ],
                                  ),
                                ),
                                actions: <Widget>[
                                  TextButton(
                                    child: const Text("OK"),
                                    onPressed: () => _formRetypeEmailKey
                                            .currentState!
                                            .validate()
                                        ? retypeEmail()
                                        : null,
                                  ),
                                  TextButton(
                                    child: const Text("Cancel"),
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    },
                                  ),
                                ],
                              );
                            },
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
                          onPressed: () => verifyOTP(),
                          child: const Text(
                            'Verify OTP',
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
              ],
            ),
          ),
        ),
      ),
    );
  }
}
