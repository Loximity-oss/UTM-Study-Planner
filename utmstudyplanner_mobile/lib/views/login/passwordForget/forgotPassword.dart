import 'dart:async';

import 'package:email_auth/email_auth.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:utmstudyplanner_mobile/views/login/passwordForget/newPassword.dart';

import '../../../server/auth.config.dart';
import '../../../server/conn.dart';

class forgotPassword extends StatefulWidget {
  forgotPassword({Key? key}) : super(key: key);

  @override
  State<forgotPassword> createState() => _forgotPassword();
}

class _forgotPassword extends State<forgotPassword> {
  @override
  final box = Hive.box('');
  final TextEditingController emailVerify = TextEditingController();
  final TextEditingController userOTP = TextEditingController();
  final _formForgetPasswordKey = GlobalKey<FormState>();
  bool visible = true;

  //timer OTP settings
  late Timer _timer;
  int _start = 30;
  String otpText = 'Send OTP';

  EmailAuth emailAuth = EmailAuth(sessionName: "UTM Study Planner");

  @override
  void initState() {
    emailAuth.config(remoteServerConfiguration);
    super.initState();
  }

  void sendOTP() async {
    setState(() {
      visible = false;
    });
    final scaffold = ScaffoldMessenger.of(context);
    var db = Mysql();
    String query =
        'SELECT `email`, `password` FROM `users` WHERE `email` = "' +
            emailVerify.text +
            '"';
    print(query);
    try{
      var result = await db.execQuery(query);
      if (result.numOfRows == 1) {
        for (final row in result.rows) {
          box.put('tempPassword', row.colAt(1));
        }
        startTimer();
        var res =
        await emailAuth.sendOtp(recipientMail: emailVerify.text, otpLength: 5);
        if (res) {
          scaffold.showSnackBar(
            SnackBar(
              content: const Text('OTP Sent.'),
              action: SnackBarAction(
                  label: 'OK', onPressed: scaffold.hideCurrentSnackBar),
            ),
          );
        } else {
          scaffold.showSnackBar(
            SnackBar(
              content: const Text('OTP not Sent.'),
              action: SnackBarAction(
                  label: 'OK', onPressed: scaffold.hideCurrentSnackBar),
            ),
          );
        }
      } else {
        throw Exception('Invalid Email');
      }
    } catch (e){
      setState(() {
        visible = true;
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

  void verifyOTP() {
    final scaffold = ScaffoldMessenger.of(context);
    var res = emailAuth.validateOtp(
        recipientMail: emailVerify.text, userOtp: userOTP.text);
    if (res) {
      Navigator.push(context,
          MaterialPageRoute(builder: (context) => newPassword(email: emailVerify.text)));
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

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
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
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 255, 249, 235),
      appBar: AppBar(
        title: const Text('Forget Password',
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
              const SizedBox(height: 5),
              //Username and Password Containers
              Container(
                padding: const EdgeInsets.only(left: 50, right: 50),
                child: Column(
                  children: [
                    const SizedBox(height: 5),
                    const Text('Forgot Password',
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 20),
                    Form(
                      key: _formForgetPasswordKey,
                      child: Column(
                        children: <Widget>[
                          TextFormField(
                            controller: emailVerify,
                            autovalidateMode: AutovalidateMode.onUserInteraction,
                            enableSuggestions: false,
                            autocorrect: false,
                            validator: (value) => EmailValidator.validate(value!) ? null : "Please enter a valid email.",
                            style: const TextStyle(fontSize: 14),
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

                          const SizedBox(height: 5),

                          TextFormField(
                            controller: userOTP,
                            style: const TextStyle(fontSize: 14),
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
    );
  }
}
