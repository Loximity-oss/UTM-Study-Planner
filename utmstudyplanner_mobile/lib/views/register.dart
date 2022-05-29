import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flutter/services.dart';
import 'package:utmstudyplanner_mobile/views/login/login.dart';
import 'package:utmstudyplanner_mobile/views/verifyEmail.dart';
import '../../server/conn.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:utmstudyplanner_mobile/views/register.dart';
import 'package:http/http.dart' as http;

class registerPage extends StatefulWidget {
  const registerPage({Key? key}) : super(key: key);

  @override
  State<registerPage> createState() => _registerPageState();
}

class _registerPageState extends State<registerPage> {
  final TextEditingController IDInput = TextEditingController();
  final TextEditingController nameInput = TextEditingController();
  final TextEditingController courseInput = TextEditingController();
  final TextEditingController emailInput = TextEditingController();
  final TextEditingController passwordInput = TextEditingController();
  final TextEditingController confirm_password = TextEditingController();
  final _formRegisterKey = GlobalKey<FormState>();
  bool visible = false;

  Future userRegister() async {
    // Getting value from Controller

    String inputID = IDInput.text;
    String inputEmail = emailInput.text;
    String inputName = nameInput.text;
    String inputCourse = courseInput.text;
    String inputPassword = passwordInput.text;

    //TODO implement conn checking
    var db = Mysql();
    String query = 'INSERT INTO `users`(`id`, `email`, `name`, `coursecode`, `password`) VALUES ("' +
        inputID + '","' + inputEmail + '","' + inputName + '","' + inputCourse +
        '","' + inputPassword + '")';
    print(query);
    try{
      var result = await db.execQuery(query);
      print(result.affectedRows);
      print(result.numOfRows);
      if (result.affectedRows.toInt() == 1) {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text('Data has been successfully inserted into the database.'),
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
      } else {}
    }catch(e){
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 255, 249, 235),
      appBar: AppBar(
        title: const Text('Registration', style: TextStyle(color: Colors.black)),
        backgroundColor: Colors.transparent,
        iconTheme: (const IconThemeData(color: Colors.black)),
        elevation: 0,

      ),
      body: Center(
        child: SingleChildScrollView(
          reverse: true,
          padding: const EdgeInsets.only(top: 32, bottom: 32),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Container(
                width: 120,
                height: 120,
                decoration: const BoxDecoration(color: Colors.black, shape: BoxShape.circle),
              ),
              const SizedBox(height: 5),
              Container(
                padding: const EdgeInsets.only(left: 50, right: 50),
                child: Column(
                  children: [
                    const SizedBox(height: 5),
                    const Text('Registration', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                    const Text('Fill in the required information', style: TextStyle(fontSize: 15)),
                    const SizedBox(height: 20),
                    Form(
                      key: _formRegisterKey,
                      child: Column(
                        children:  <Widget>[
                          TextFormField(
                            controller: emailInput,
                            style: const TextStyle(fontSize: 14),
                            textInputAction: TextInputAction.next,
                            autovalidateMode: AutovalidateMode.onUserInteraction,
                            validator: (value) => EmailValidator.validate(value!) ? null : "Please enter a valid email.",
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

                          //Matric ID/Staff ID
                          const SizedBox(height: 10),
                          TextFormField(
                            controller: IDInput,
                            style: const TextStyle(fontSize: 14),
                            textInputAction: TextInputAction.next,
                            autovalidateMode: AutovalidateMode.onUserInteraction,
                            inputFormatters: [
                              FilteringTextInputFormatter.allow(RegExp(r'[0-9,A-Z]')),
                              LengthLimitingTextInputFormatter(9)],
                            validator: (IDCheck) {
                              if (IDCheck == null || IDCheck.isEmpty) {
                                return 'Please enter your enter ID.';
                              }
                              return null;
                            },
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
                                hintText: "Matric ID/Staff ID",
                                fillColor: Colors.white),
                          ),


                          //Nickname
                          const SizedBox(height: 10),
                          TextFormField(
                            controller: nameInput,
                            style: const TextStyle(fontSize: 14),
                            textInputAction: TextInputAction.next,
                            autovalidateMode: AutovalidateMode.onUserInteraction,
                            validator: (nicknameCheck) {
                              if (nicknameCheck == null || nicknameCheck.isEmpty) {
                                return 'Please enter a nickname.';
                              }
                              return null;
                            },
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
                                hintText: "Nickname",
                                fillColor: Colors.white),
                          ),


                          //Course Code
                          const SizedBox(height: 10),
                          TextFormField(
                            controller: courseInput,
                            style: const TextStyle(fontSize: 14),
                            textInputAction: TextInputAction.next,
                            autovalidateMode: AutovalidateMode.onUserInteraction,
                            inputFormatters: [
                              FilteringTextInputFormatter.allow(RegExp(r'[1-4,A-Z,/]')),
                              LengthLimitingTextInputFormatter(7)],
                            validator: (courseCheck) {
                              if (courseCheck == null || courseCheck.isEmpty) {
                                return 'Please enter your course code.';
                              }
                              return null;
                            },
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
                                hintText: "Course Code e.g. 1/SECRH",
                                fillColor: Colors.white),
                          ),


                          //Password
                          const SizedBox(height: 10),
                          TextFormField(
                            controller: passwordInput,
                            obscureText: true,
                            textInputAction: TextInputAction.next,
                            autovalidateMode: AutovalidateMode.onUserInteraction,
                            inputFormatters: [
                              FilteringTextInputFormatter.allow(RegExp(r'[0-9,A-Z,a-z,!@#$*]'))],
                            validator: (passwordCheck) {
                              if (passwordCheck == null || passwordCheck.isEmpty) {
                                return 'Please enter a password.';
                              }
                              if (passwordCheck.trim().length < 8){
                                return 'Password must be at least 8 characters.';
                              }
                              if (!passwordCheck.contains(RegExp(r"[0-9]"))) return 'Insert at least one number: "0-9"';
                              if (!passwordCheck.contains(RegExp(r'[!@#$%^&*]'))) return 'Insert at least one special character: "!@#*&"';
                              return null;
                            },
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

                          //Confirm Password
                          const SizedBox(height: 10),
                          TextFormField(
                            controller: confirm_password,
                            obscureText: true,
                            textInputAction: TextInputAction.next,
                            autovalidateMode: AutovalidateMode.onUserInteraction,
                            validator: (passwordCheck) {
                              if (passwordCheck != passwordInput.text){
                                return 'Password does not match';
                              }
                              return null;
                            },
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
                                hintText: "Confirm Password",
                                fillColor: Colors.white),
                          ),


                          TextButton(
                            child:
                            const Text("Have an account? Click me!", style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                            onPressed: () {
                              Navigator.push(context,
                                MaterialPageRoute(builder: (context) => const loginPage()),
                              );
                            },
                          ),

                          TextButton(
                            child:
                            const Text("Test for Verify", style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                            onPressed: () {
                              Navigator.push(context,
                                MaterialPageRoute(builder: (context) => verifyEmail()),
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
                              onPressed: () => _formRegisterKey.currentState!.validate() ? userRegister() : null,
                              child: const Text('Register',
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
