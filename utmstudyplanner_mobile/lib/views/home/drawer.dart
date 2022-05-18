import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hive/hive.dart';
import 'package:utmstudyplanner_mobile/views/home/homescreen.dart';
import 'package:utmstudyplanner_mobile/views/home/profilev2.dart';
import '../login/login.dart';
import '../notifications/TestNotifyScreen.dart';
import 'calendar/calendarv2.dart';

class DefAppBar extends StatelessWidget {
  DefAppBar({Key? key}) : super(key: key);
  final box = Hive.box('');

  @override
  Widget build(BuildContext context){
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          const DrawerHeader(
            decoration: BoxDecoration(
              color: Color.fromARGB(255, 93, 6, 29),
            ),
            child: Text('UTM Study Planner', style: TextStyle(color: Colors.white)),
          ),
          ListTile(
            leading: const FaIcon(FontAwesomeIcons.house, color: Colors.black),
            title: const Text('Home'),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => const homepage()
                  ));
            },
          ),
          ListTile(
            leading: const FaIcon(FontAwesomeIcons.user, color: Colors.black),
            title: const Text('Profile'),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => const profilePageV2()
                  ));
            },
          ),
          ListTile(
            leading: const FaIcon(FontAwesomeIcons.calendar, color: Colors.black),
            title: const Text('Calendar'),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => const CalendarApp()
                  ));
            },
          ),
          ListTile(
            leading: const FaIcon(FontAwesomeIcons.bell, color: Colors.black),
            title: const Text('Notifications Settings'),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => const TestNotifyScreen()
                  ));
            },
          ),
          ListTile(
            leading: const FaIcon(FontAwesomeIcons.gear, color: Colors.black),
            title: const Text('Settings'),
            onTap: () {
              // Update the state of the app.
              // ...
            },
          ),
          Container(
            child: Align(
                alignment: FractionalOffset.bottomCenter,
                child: Column(
                  children: [
                    Divider(),
                    ListTile(
                        leading: const FaIcon(FontAwesomeIcons.arrowUpRightFromSquare, color: Colors.black),
                        title: const Text('Logout'),
                        onTap: () => showDialog(context: context, builder: (BuildContext context) => AlertDialog(
                          title: const Text('Logout'),
                          content: const Text('Would you like to log out?'),
                          actions: <Widget>[
                            TextButton(
                              onPressed: () {
                                box.put('email', '');
                                box.put('password', '');
                                box.put('nickname', '');
                                box.put('matricID','');
                                box.put('coursecode','');
                                Navigator.push(context,
                                  MaterialPageRoute(builder: (context) => const loginPage()),
                                );
                              },
                              child: const Text('Yes'),
                            ),
                            TextButton(
                              onPressed: () => Navigator.pop(context, 'No'),
                              child: const Text('No'),
                            ),
                          ],
                        ))
                    ),
                  ],
                )
            ),
          ),
        ],
      ),
    );
  }
}