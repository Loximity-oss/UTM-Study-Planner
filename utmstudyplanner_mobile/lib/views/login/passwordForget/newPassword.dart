import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:utmstudyplanner_mobile/views/register.dart';
import '../../../server/conn.dart';

class newPassword extends StatefulWidget {
  final String email;

  newPassword({Key? key, required this.email}) : super(key: key);

  @override
  State<newPassword> createState() => _newPassword();
}

class _newPassword extends State<newPassword> {
  @override
  final box = Hive.box('');
  final TextEditingController emailInput = TextEditingController();
  final TextEditingController passwordInput = TextEditingController();
  final TextEditingController confirmPasswordInput = TextEditingController();
  final _formChangePasswordKey = GlobalKey<FormState>();
  bool visible = false;

  Future changePassword() async {
    var db = Mysql();
    String query = 'UPDATE users as T1' +
        ' INNER JOIN (SELECT `password`, `password_2`, `password_3` FROM users WHERE `email` = "' +
        widget.email +
        '" ' 'AND `password_2` NOT LIKE "%' +
        passwordInput.text +
        '%" AND `password_3` NOT LIKE "%' +
        passwordInput.text +
        '%") as T2' +
        ' SET T1.password = "' +
        passwordInput.text +
        '",' +
        ' T1.password_2 = T2.password,' +
        ' T1.password_3 = T2.password_2' +
        ' WHERE T1.email = "' +
        widget.email +
        '"';
    print(query);

    try {
      var result = await db.execQuery(query);
      if (result.affectedRows.toInt() == 1) {
        Navigator.of(context).pop();
        box.put('password', passwordInput.text);
        passwordInput.clear();
        confirmPasswordInput.clear();
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text('Your information has been updated.'),
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
        passwordInput.clear();
        confirmPasswordInput.clear();
        throw Exception('You cannot use a similar password.');
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
  }

  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        backgroundColor: const Color.fromARGB(255, 255, 249, 235),
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: const Text('Reset Password',
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
                //Username and Password Containers
                Container(
                  padding: const EdgeInsets.only(left: 50, right: 50),
                  child: Column(
                    children: [
                      Container(
                        width: 500,
                        height: 300,
                        child: Image.asset('assets/verify_email/man_email.png'),
                      ),
                      const SizedBox(height: 5),
                      const Text('Reset Password',
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold)),
                      SizedBox(height: 10),
                      const SizedBox(height: 20),
                      Form(
                        key: _formChangePasswordKey,
                        child: Column(
                          children: <Widget>[
                            TextFormField(
                              enableSuggestions: false,
                              autocorrect: false,
                              obscureText: true,
                              controller: passwordInput,
                              textInputAction: TextInputAction.next,
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
                                  filled: true,
                                  hintStyle: TextStyle(color: Colors.grey[800]),
                                  hintText: "New Password",
                                  fillColor: Colors.white),
                              autovalidateMode:
                                  AutovalidateMode.onUserInteraction,
                              inputFormatters: [
                                FilteringTextInputFormatter.allow(
                                    RegExp(r'[0-9,A-Z,a-z,!@#$*]'))
                              ],
                              validator: (passwordCheck) {
                                if (passwordCheck == null ||
                                    passwordCheck.isEmpty) {
                                  return 'Please enter a password.';
                                }
                                if (passwordCheck.trim().length < 8) {
                                  return 'Password must be at least 8 characters.';
                                }
                                if (passwordCheck == box.get('password')) {
                                  return 'Password cannot be similar.';
                                }
                                if (!passwordCheck.contains(RegExp(r"[0-9]"))) {
                                  return 'Insert at least one number: "0-9"';
                                }
                                if (!passwordCheck
                                    .contains(RegExp(r'[!@#$%^&*]'))) {
                                  return 'Insert at least one special character: "!@#*&"';
                                }
                                return null;
                              },
                            ),
                            const SizedBox(height: 5),
                            TextFormField(
                                controller: confirmPasswordInput,
                                enableSuggestions: false,
                                autocorrect: false,
                                obscureText: true,
                                textInputAction: TextInputAction.next,
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
                                    filled: true,
                                    hintStyle:
                                        TextStyle(color: Colors.grey[800]),
                                    hintText: "Confirm New Password",
                                    fillColor: Colors.white),
                                autovalidateMode:
                                    AutovalidateMode.onUserInteraction,
                                validator: (passwordCheck) {
                                  if (passwordCheck == null ||
                                      passwordCheck.isEmpty) {
                                    return 'Please enter a password.';
                                  } else if (passwordCheck !=
                                      passwordInput.text) {
                                    return 'Passwords do not match.';
                                  } else {
                                    return null;
                                  }
                                }),
                            const SizedBox(height: 20),
                            Visibility(
                                visible: visible,
                                child: Container(
                                    margin: const EdgeInsets.only(bottom: 30),
                                    child: const CircularProgressIndicator(
                                        color:
                                            Color.fromARGB(255, 93, 6, 29)))),
                          ],
                        ),
                      ),
                      const SizedBox(height: 10),
                      Container(
                        width: MediaQuery.of(context).size.width / 2.0,
                        height: 40,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(35.0),
                          color: const Color.fromARGB(255, 93, 6, 29),
                        ),
                        child: MaterialButton(
                          onPressed: () =>
                              _formChangePasswordKey.currentState!.validate()
                                  ? changePassword()
                                  : null,
                          child: const Text(
                            'Reset Password',
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
