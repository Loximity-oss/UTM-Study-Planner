import 'package:flutter/material.dart';
import 'package:email_validator/email_validator.dart';
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
  final _formRegisterKey = GlobalKey<FormState>();
  bool visible = false;

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
              width: 150,
              height: 150,
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
                        TextFormField(
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
                              hintText: "Matric ID/Staff ID",
                              fillColor: Colors.white),
                        ),
                        const SizedBox(height: 10),
                        TextFormField(
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
                              hintText: "Nickname",
                              fillColor: Colors.white),
                        ),
                        const SizedBox(height: 10),
                        TextFormField(
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
                              hintText: "Course Code e.g. 1/SECRH",
                              fillColor: Colors.white),
                        ),
                        const SizedBox(height: 10),
                        TextFormField(
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
                          const Text("Have an account?", style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold)),
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
                            onPressed: () => _formRegisterKey.currentState!.validate() ? null : null,
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