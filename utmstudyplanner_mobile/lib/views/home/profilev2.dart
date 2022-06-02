import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:image_picker/image_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:utmstudyplanner_mobile/server/conn.dart';

class profilePageV2 extends StatefulWidget {
  const profilePageV2({Key? key}) : super(key: key);

  @override
  State<profilePageV2> createState() => _profilePageState();
}

class _profilePageState extends State<profilePageV2> {
  final box = Hive.box('');
  final TextEditingController nameInput = TextEditingController();
  final TextEditingController passwordInput = TextEditingController();
  final _formNicknameKey = GlobalKey<FormState>();
  final _formPasswordKey = GlobalKey<FormState>();
  final picker = ImagePicker();

  String? _image;
  File? _image2;

  bool visible = false;

  void loadProfilePic() async {
    var db = Mysql();
    try{
      String query = 'SELECT profilePicture FROM `users` WHERE `email` = "'+ box.get('email') +'" AND password = "' + box.get('password') + '"';

      var result = await db.execQuery(query);
      for (final row in result.rows) {
        final s = row.colAt(0);
        setState(() {
          _image = s;
        });

      }

    } catch (e){
      print(e.toString());
    }
  }

  Future changeProfile() async{

  }

  Future changePassword() async{
    var db = Mysql();
    String query = 'UPDATE users as T1' +
    ' INNER JOIN (SELECT `password`, `password_2`, `password_3` FROM users WHERE id = "'+ box.get("matricID") +'" ''AND `password_2` NOT LIKE "%'+ passwordInput.text +'%" AND `password_3` NOT LIKE "%'+ passwordInput.text +'%") as T2' +
    ' SET T1.password = "'+ passwordInput.text +'",'+
    ' T1.password_2 = T2.password,' +
    ' T1.password_3 = T2.password_2' +
    ' WHERE T1.id = "'+ box.get("matricID") +'"';

    try{
      var result = await db.execQuery(query);
      if (result.affectedRows.toInt() == 1) {
        Navigator.of(context).pop();
        box.put('password', passwordInput.text);
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
      } else {
        passwordInput.clear();
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text('You cannot use a previous password'),
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
        box.put('nickname', nameInput.text);
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
  void initState()  {
    super.initState();
    loadProfilePic();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile', style: TextStyle(color: Colors.white)),
        backgroundColor: const Color.fromARGB(255, 93, 6, 29),
        iconTheme: (const IconThemeData(color: Colors.white)),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Column(
        children: <Widget>[
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Color.fromARGB(255, 93, 6, 29), Colors.pinkAccent]
              )
            ),
            child: Container(
              width: double.infinity,
              height: 350,
              child: Center(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    CircleAvatar(
                      radius: 50.0,
                      child: ClipOval(
                        child: SizedBox(
                          child: (_image!=null) ? Image.memory(base64Decode(_image!),
                            fit: BoxFit.fill,
                          ):Image.asset(
                            "assets/Profile/default.png",
                            fit: BoxFit.fill,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 10.0,
                    ),
                    Text(box.get('nickname'), style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white)),
                    Text(box.get('matricID'), style: const TextStyle(fontSize: 15, color: Colors.white)),
                    const SizedBox(
                      height: 20,
                    ),
                    Card(
                      margin: const EdgeInsets.symmetric(horizontal: 20.0,vertical: 5.0),
                      clipBehavior: Clip.antiAlias,
                      color: Colors.white,
                      elevation: 5.0,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0,vertical: 22.0),
                        child: Row(
                          children: <Widget>[
                            Expanded(
                              child: Column(
                                children: const <Widget>[
                                  Text(
                                    "Credit Earned",
                                    style: TextStyle(
                                      color: Colors.redAccent,
                                      fontSize: 20.0,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  SizedBox(
                                    height: 5.0,
                                  ),
                                  Text(
                                    "18",
                                    style: TextStyle(
                                      fontSize: 20.0,
                                      color: Colors.pinkAccent,
                                    ),
                                  )
                                ],
                              ),
                            ),
                            Expanded(
                              child: Column(
                                children: const <Widget>[
                                  Text(
                                    "Subject Registered",
                                    style: TextStyle(
                                      color: Colors.redAccent,
                                      fontSize: 20.0,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  SizedBox(
                                    height: 5.0,
                                  ),
                                  Text(
                                    "8",
                                    style: TextStyle(
                                      fontSize: 20.0,
                                      color: Colors.pinkAccent,
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(
            height: 20.0,
          ),

          Container(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 10.0,horizontal: 16.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const <Widget>[
                  Text(
                    "Bio:",
                    style: TextStyle(
                        color: Colors.redAccent,
                        fontStyle: FontStyle.normal,
                        fontSize: 28.0
                    ),
                  ),
                  SizedBox(
                    height: 10.0,
                  ),
                  Text('My name is Faris and I am  a freelance mobile app developer.\n'
                      'if you need any mobile app for your company then contact me for more informations',
                    style: TextStyle(
                      fontSize: 22.0,
                      fontStyle: FontStyle.italic,
                      fontWeight: FontWeight.w300,
                      color: Colors.black,
                      letterSpacing: 2.0,
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(
            height: 20.0,
          ),

          Container(
              width: 300.0,
              child: RaisedButton(
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: const Text('Change Nickname'),
                        content: Form(
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
                                decoration: const InputDecoration(
                                    hintText: 'New Username',
                                ),
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
                                  decoration: const InputDecoration(
                                      hintText: 'Confirm New Username',
                                  ),
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
                        actions: <Widget>[
                          TextButton(
                            child: const Text("OK"),
                            onPressed: () => _formNicknameKey.currentState!.validate() ? changeNickname() : null,
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
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(80.0)
                ),
                elevation: 0.0,
                padding: const EdgeInsets.all(0.0),
                child: Ink(
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      begin: Alignment.centerRight,
                      end: Alignment.centerLeft,
                      colors: [Colors.redAccent, Colors.pinkAccent],
                    ),
                    borderRadius: BorderRadius.circular(30.0),
                  ),
                  child: Container(
                    constraints: const BoxConstraints(maxWidth: 300.0, minHeight: 50.0),
                    alignment: Alignment.center,
                    child: const Text("Change Nickname", style: TextStyle(color: Colors.white, fontSize: 26.0, fontWeight: FontWeight.w300)),
                  ),
                ),
              )
          ),
          const SizedBox(
            height: 20.0,
          ),
          Container(
              width: 300.0,
              child: RaisedButton(
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: const Text('Change Password'),
                        content: Form(
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
                                inputFormatters: [
                                  FilteringTextInputFormatter.allow(RegExp(r'[0-9,A-Z,a-z,!@#$*]'))],
                                validator: (passwordCheck) {
                                  if (passwordCheck == null || passwordCheck.isEmpty) {
                                    return 'Please enter a password.';
                                  }
                                  if (passwordCheck.trim().length < 8){
                                    return 'Password must be at least 8 characters.';
                                  }
                                  if (passwordCheck == box.get('password')){
                                    return 'Password cannot be similar.';
                                  }
                                  if (!passwordCheck.contains(RegExp(r"[0-9]"))) return 'Insert at least one number: "0-9"';
                                  if (!passwordCheck.contains(RegExp(r'[!@#$%^&*]'))) return 'Insert at least one special character: "!@#*&"';
                                  return null;
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
                        actions: <Widget>[
                          TextButton(
                            child: const Text("OK"),
                            onPressed: () => _formPasswordKey.currentState!.validate() ? changePassword() : null,
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
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(80.0)
                ),
                elevation: 0.0,
                padding: const EdgeInsets.all(0.0),
                child: Ink(
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      begin: Alignment.centerRight,
                      end: Alignment.centerLeft,
                      colors: [Colors.redAccent, Colors.pinkAccent],
                    ),
                    borderRadius: BorderRadius.circular(30.0),
                  ),
                  child: Container(
                    constraints: const BoxConstraints(maxWidth: 300.0, minHeight: 50.0),
                    alignment: Alignment.center,
                    child: const Text("Change Password", style: TextStyle(color: Colors.white, fontSize: 26.0, fontWeight: FontWeight.w300)),
                  ),
                ),
              )
          ),
          const SizedBox(
            height: 20.0,
          ),
          Container(
              width: 300.0,
              child: RaisedButton(
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: const Text('Change Profile'),
                        content: Form(
                          key: _formPasswordKey,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            mainAxisSize: MainAxisSize.min,
                            children: <Widget>[
                              GestureDetector(
                                onTap: () async {
                                  final pickedFile = await picker.pickImage(source: ImageSource.gallery);
                                  setState(() {
                                    if (pickedFile != null) {
                                      _image2 = File(pickedFile.path);
                                      log(_image2.toString());
                                    } else {
                                      print('No image selected.');
                                    }
                                  });
                                },
                                child: CircleAvatar(
                                  radius: 60.0,
                                  child: ClipOval(
                                    child: SizedBox(
                                      child: (_image2!=null)? Image.file(
                                        _image2!,
                                        fit: BoxFit.fill,
                                      ):Image.asset(
                                        "assets/Profile/default.png",
                                        fit: BoxFit.fill,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        actions: <Widget>[
                          TextButton(
                            child: const Text("OK"),
                            onPressed: () => _formPasswordKey.currentState!.validate() ? changePassword() : null,
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
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(80.0)
                ),
                elevation: 0.0,
                padding: const EdgeInsets.all(0.0),
                child: Ink(
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      begin: Alignment.centerRight,
                      end: Alignment.centerLeft,
                      colors: [Colors.redAccent, Colors.pinkAccent],
                    ),
                    borderRadius: BorderRadius.circular(30.0),
                  ),
                  child: Container(
                    constraints: const BoxConstraints(maxWidth: 300.0, minHeight: 50.0),
                    alignment: Alignment.center,
                    child: const Text("Change Profile Image", style: TextStyle(color: Colors.white, fontSize: 26.0, fontWeight: FontWeight.w300)),
                  ),
                ),
              )
          ),
          const SizedBox(
            height: 20.0,
          ),
        ],
      ),
      ),
    );
  }
}