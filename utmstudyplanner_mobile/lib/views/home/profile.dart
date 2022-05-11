import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:utmstudyplanner_mobile/server/conn.dart';


class profilePage extends StatefulWidget {
  const profilePage({Key? key}) : super(key: key);

  @override
  State<profilePage> createState() => _profilePageState();
}

class _profilePageState extends State<profilePage> {
  final box = Hive.box('');
  final TextEditingController nameInput = TextEditingController();
  final TextEditingController passwordInput = TextEditingController();
  final _formNicknameKey = GlobalKey<FormState>();
  final _formPasswordKey = GlobalKey<FormState>();

  bool visible = false;


  Future changePassword() async{
    var db = Mysql();
    String query = 'UPDATE `users` SET `password` = "'+ passwordInput.text +'" WHERE `users`.`id` = "'+ box.get("matricID") +'"';
    try{
      var result = await db.execQuery(query);
      if (result.affectedRows.toInt() == 1) {
        Navigator.of(context).pop();
        box.put('password',passwordInput.text);
        passwordInput.clear();
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
                    setState(() {});
                  },
                ),
              ],
            );
          },
        );
      }
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

  Future changeNickname() async{
      var db = Mysql();
      String query = 'UPDATE `users` SET `name` = "'+ nameInput.text +'" WHERE `users`.`id` = "'+ box.get("matricID") +'"';
      try{
        var result = await db.execQuery(query);
        if (result.affectedRows.toInt() == 1) {
          Navigator.of(context).pop();
          box.put('nickname',nameInput.text);
          nameInput.clear();
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
                      setState(() {});
                    },
                  ),
                ],
              );
            },
          );
        }
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
        title: const Text('Profile', style: TextStyle(color: Colors.white)),
        backgroundColor: const Color.fromARGB(255, 93, 6, 29),
        iconTheme: (const IconThemeData(color: Colors.white)),
        elevation: 0,

      ),
      body: SingleChildScrollView(
          reverse: true,
          padding: const EdgeInsets.only(top: 32, bottom: 32),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Container(
                width: 120,
                height: 120,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  image: DecorationImage(image: AssetImage('assets/Profile/default.png')),
                ),
              ),
              const SizedBox(height: 5),
              Container(
                padding: const EdgeInsets.only(left: 50, right: 50),
                child: Column(
                  children: [
                    const SizedBox(height: 5),
                    Text(box.get('nickname'), style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                    Text(box.get('matricID'), style: TextStyle(fontSize: 15)),
                    const SizedBox(height: 20),

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
              ListTile(
                leading: Icon(Icons.info_outline, color: Colors.grey),
                title: Text('Change Nickname'),
                onTap: () {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: const Text('Change Nickname'),
                        content: Container(
                          child: Form(
                            key: _formNicknameKey,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              mainAxisSize: MainAxisSize.min,
                              children: <Widget>[
                                TextFormField(
                                  enableSuggestions: false,
                                  autocorrect: false,
                                  controller: nameInput,
                                  textInputAction: TextInputAction.next,
                                  decoration: InputDecoration(hintText: 'New Username'),
                                  autovalidateMode: AutovalidateMode.onUserInteraction,
                                  validator: (nicknameCheck) {
                                    if (nicknameCheck == null || nicknameCheck.isEmpty) {
                                      return 'Please enter a nickname.';
                                    } else if (nicknameCheck == box.get('nickname')){
                                      return 'Nickname cannot be similar.';
                                    } else {
                                      return null;
                                    }
                                  },
                                ),
                                TextFormField(
                                    enableSuggestions: false,
                                    autocorrect: false,
                                    textInputAction: TextInputAction.next,
                                    decoration: InputDecoration(hintText: 'Confirm New Username'),
                                    autovalidateMode: AutovalidateMode.onUserInteraction,
                                    validator: (nicknameCheck) {
                                      if (nicknameCheck == null || nicknameCheck.isEmpty) {
                                        return 'Please enter a nickname.';
                                      } else if (nicknameCheck != nameInput.text){
                                        return 'Nicknames do not match.';
                                      } else {
                                        return null;
                                      }
                                    }
                                ),
                              ],
                            ),
                          ),

                        ),
                        actions: <Widget>[
                          FlatButton(
                            child: const Text("OK"),
                              onPressed: () => _formNicknameKey.currentState!.validate() ? changeNickname() : null,
                          ),
                          FlatButton(
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
              ListTile(
                leading: Icon(Icons.info_outline, color: Colors.grey),
                title: Text('Change Password'),
                onTap: () {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: const Text('Change Password'),
                        content: Container(
                          child: Form(
                            key: _formPasswordKey,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              mainAxisSize: MainAxisSize.min,
                              children: <Widget>[
                                TextFormField(
                                  enableSuggestions: false,
                                  autocorrect: false,
                                  obscureText: true,
                                  controller: passwordInput,
                                  textInputAction: TextInputAction.next,
                                  decoration: const InputDecoration(hintText: 'New Password'),
                                  autovalidateMode: AutovalidateMode.onUserInteraction,
                                  validator: (passwordCheck) {
                                    if (passwordCheck == null || passwordCheck.isEmpty) {
                                      return 'Please enter a password.';
                                    } else if (passwordCheck == box.get('nickname')){
                                      return 'Password cannot be similar.';
                                    } else if (passwordCheck.trim().length < 8){
                                      return 'Password must be at least 8 characters.';
                                    } else {
                                      return null;
                                    }
                                  },
                                ),
                                TextFormField(
                                    enableSuggestions: false,
                                    autocorrect: false,
                                    obscureText: true,
                                    textInputAction: TextInputAction.next,
                                    decoration: const InputDecoration(hintText: 'Confirm New Password'),
                                    autovalidateMode: AutovalidateMode.onUserInteraction,
                                    validator: (passwordCheck) {
                                      if (passwordCheck == null || passwordCheck.isEmpty) {
                                        return 'Please enter a password.';
                                      } else if (passwordCheck != passwordInput.text){
                                        return 'Passwords do not match.';
                                      } else {
                                        return null;
                                      }
                                    }
                                ),
                              ],
                            ),
                          ),

                        ),
                        actions: <Widget>[
                          FlatButton(
                            child: const Text("OK"),
                            onPressed: () => _formPasswordKey.currentState!.validate() ? changePassword() : null,
                          ),
                          FlatButton(
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
            ],
          ),
        ),
    );
  }
}