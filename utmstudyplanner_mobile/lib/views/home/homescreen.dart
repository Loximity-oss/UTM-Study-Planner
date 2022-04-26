import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:utmstudyplanner_mobile/views/home/calendar.dart';
import 'package:utmstudyplanner_mobile/views/login/login.dart';

class homepage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Drawer(
        // Add a ListView to the drawer. This ensures the user can scroll
        // through the options in the drawer if there isn't enough vertical
        // space to fit everything.
        child: ListView(
          // Important: Remove any padding from the ListView.
          padding: EdgeInsets.zero,
          children: [
            const DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.blue,
              ),
              child: Text('Drawer Header'),
            ),
            ListTile(
              title: const Text('Item 1'),
              onTap: () {
                // Update the state of the app.
                // ...
              },
            ),
            ListTile(
              title: const Text('Item 2'),
              onTap: () {
                // Update the state of the app.
                // ...
              },
            ),
          ],
        ),
      ),
      appBar: PreferredSize(
          preferredSize: const Size.fromHeight(0),
          child: AppBar(
            // Here we create one to set status bar color
            backgroundColor: const Color.fromARGB(255, 93, 6, 29), // Set any color of status bar you want; or it defaults to your theme's primary color
          )),
      backgroundColor: const Color.fromARGB(255, 255, 249, 235),
      body: CustomScrollView(
        slivers: <Widget>[
          SliverList(
            delegate: SliverChildListDelegate(
              [
                Container(
                  padding: const EdgeInsets.fromLTRB(5.0, 15.0, 5.0, 20.0),
                  decoration: const BoxDecoration(
                    color: Color.fromARGB(255, 93, 6, 29),
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(30.0),
                    ),
                  ),
                  child: const ListTile(
                    contentPadding: EdgeInsets.fromLTRB(25, 0, 0, 0),
                    leading: FaIcon(FontAwesomeIcons.bars,
                        size: 25, color: Colors.white),
                  ),

                ),
              ],
            ),
          ),
          SliverList(
            delegate: SliverChildListDelegate(
              [
                Container(
                  padding: const EdgeInsets.fromLTRB(20.0, 30.0, 20.0, 5.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: const <Widget>[
                      Text(
                        "My Tasks",
                        style: TextStyle(
                            color: Color.fromARGB(255, 16, 38 ,65),
                            fontSize: 24.0,
                            fontWeight: FontWeight.bold),
                        textAlign: TextAlign.start,
                      ),
                    ],
                  ),
                ),

                Container(
                  padding: const EdgeInsets.fromLTRB(15.0, 15.0, 15.0, 1.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: const <Widget>[
                      ListTile(
                        leading: FaIcon(FontAwesomeIcons.solidClock,
                            size: 25, color: Color.fromARGB(255, 228, 99, 113)),
                        title: Text(
                          'To Do',
                          style: TextStyle(
                              color: Color.fromARGB(255, 65, 72, 101),
                              fontWeight: FontWeight.bold),
                        ),
                        subtitle: Text('None',
                            style: TextStyle(
                              color: Color.fromARGB(255, 166,169,166),
                            ),
                        ),
                      ),
                    ],
                  ),
                ),

              ],
            ),
          ),

          SliverList(
            delegate: SliverChildListDelegate(
              [
                Container(
                  padding: const EdgeInsets.fromLTRB(20.0, 30.0, 20.0, 5.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text(
                        "About App",
                        style: TextStyle(
                            color: Color.fromARGB(255, 65, 72, 101),
                            fontSize: 24.0,
                            fontWeight: FontWeight.bold),
                        textAlign: TextAlign.start,
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.fromLTRB(15.0, 15.0, 15.0, 1.0),
                  child: Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(30.0),
                        topRight: Radius.circular(30.0),
                      ),
                    ),
                    child: InkWell(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => Calendar()),
                        );
                      },
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: const <Widget>[
                          ListTile(
                            leading: Icon(Icons.info,
                                size: 50, color: Color.fromARGB(255, 65, 72, 101)),
                            title: Text(
                              'About Application',
                              style: TextStyle(
                                  color: Color.fromARGB(255, 65, 72, 101),
                                  fontWeight: FontWeight.bold),
                            ),
                            subtitle: Text('Application Information',
                                style: TextStyle(
                                  color: Color.fromARGB(255, 65, 72, 101),
                                )),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.fromLTRB(20.0, 30.0, 20.0, 20.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const <Widget>[
                      Text(
                        "UTM Study Planner",
                        style: TextStyle(color: Colors.grey, fontSize: 12.0),
                        textAlign: TextAlign.start,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}