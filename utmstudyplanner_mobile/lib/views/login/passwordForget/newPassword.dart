import 'dart:async';
import 'dart:convert';
import 'package:email_auth/email_auth.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:utmstudyplanner_mobile/views/register.dart';
import '../../../server/conn.dart';
import 'package:http/http.dart' as http;




class newPassword extends StatefulWidget {

  newPassword({Key? key}) : super(key: key);



  @override
  State<newPassword> createState() => _newPassword();
}



class _newPassword extends State<newPassword> {



  @override
  final box = Hive.box('');
  final TextEditingController emailVerify = TextEditingController();
  final TextEditingController userOTP = TextEditingController();
  final _formLoginKey = GlobalKey<FormState>();
  bool visible = false;





  EmailAuth emailAuth =  new EmailAuth(sessionName: "UTM Study Planner");


  void sendOTP() async {
    var res = await emailAuth.sendOtp(
        recipientMail: emailVerify.text, otpLength: 5);
    if(res){
      print("OTP Sent.");
    }
    else{
      print("OTP not sent.");
    }
  }

  void verifyOTP() {
    var res = emailAuth.validateOtp(recipientMail: emailVerify.text, userOtp: userOTP.text);
    if (res){
      print("OTP verified");
    }
    else{
      print("Invalid OTP");
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
              //Username and Password Containers
              Container(
                padding: const EdgeInsets.only(left: 50, right: 50),
                child: Column(
                  children: [
                    const SizedBox(height: 5),
                    const Text('Reset Password', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                    SizedBox(height: 10),
                    const SizedBox(height: 20),
                    Form(
                      key: _formLoginKey,
                      child: Column(
                        children:  <Widget>[

                          TextFormField(controller: emailVerify,
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
                                hintText: "New Password",
                                fillColor: Colors.white),
                          ),

                          Column(
                            children: <Widget>[
                              SizedBox(height: 10),
                            ],
                          ),

                          TextFormField(controller: emailVerify,
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
                                hintText: "Re-type Password",
                                fillColor: Colors.white),
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



                    Column(
                      children: <Widget>[
                        SizedBox(height: 10),
                      ],
                    ),

                    Container(
                      width: MediaQuery.of(context).size.width / 2.0,
                      height: 40,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(35.0),
                        color: const Color.fromARGB(255, 93, 6, 29),
                      ),
                      child: MaterialButton(
                        onPressed: () => Navigator.push(context,
                            MaterialPageRoute(builder: (context) => registerPage())),
                        child: const Text('Reset Password',
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