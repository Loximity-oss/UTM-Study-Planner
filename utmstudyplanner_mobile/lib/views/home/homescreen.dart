import 'dart:async';
import 'dart:convert';

import 'dart:developer';

import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hive/hive.dart';
import 'package:utmstudyplanner_mobile/views/home/drawer.dart';

import '../../server/conn.dart';

class homepage extends StatefulWidget{
  const homepage({Key? key}) : super(key: key);

  @override
  State<homepage> createState() => _homepageState();
}

class _homepageState extends State<homepage>{

  final box = Hive.box('');
  String? _image;

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

  @override
  void initState()  {
    super.initState();
    loadProfilePic();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 255, 249, 235),
      drawer: DefAppBar(),
      body: NestedScrollView( //where appBar resides
        headerSliverBuilder: (context, innerBoxIsScrolled) {
          return <Widget>[
            SliverAppBar(
              backgroundColor: const Color.fromARGB(255, 93, 6, 29),
              elevation: 0,
              title: Center(
                child: PreferredSize(
                    child: ClipPath(
                      child: Container(
                        width: MediaQuery.of(context).size.width,
                        height: 60,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                        ),
                      ),
                    ),
                    preferredSize: Size.fromHeight(kToolbarHeight + 150)
                ),
              ),
              floating: false,
              pinned: false,
            ),
          ];
        },
        body: CustomScrollView( // main content
          slivers: <Widget>[
            SliverList(
              delegate: SliverChildListDelegate(
                [
                  Container(
                    padding: const EdgeInsets.fromLTRB(5.0, 15.0, 5.0, 20.0),
                    height: 200,
                    decoration: const BoxDecoration(
                      color: Color.fromARGB(255, 93, 6, 29),
                      borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(30.0),
                      ),
                    ),
                    child: Column(
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
                        const SizedBox(height: 10),
                        Container(child: Text(box.get('nickname'),textAlign: TextAlign.center, style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold), )), //TODO: link with backend
                        Container(child: Text(box.get('matricID'),textAlign: TextAlign.center, style: TextStyle(color: Colors.white, fontSize: 11,),)),
                        Container(child: Text(box.get('coursecode'),textAlign: TextAlign.center, style: TextStyle(color: Colors.white, fontSize: 11,),)),

                      ],
                    ),
                  ),
                ],
              ),
            ),

            //Todo List Section
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
                    padding: const EdgeInsets.fromLTRB(15.0, 0, 15.0, 0),
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
                              color: Color.fromARGB(255, 166, 169, 166),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  Container(
                    padding: const EdgeInsets.fromLTRB(15.0, 0, 15.0, 0),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: const <Widget>[
                        ListTile(
                          leading: FaIcon(FontAwesomeIcons.circleExclamation,
                              size: 25, color: Color.fromARGB(255, 248, 191, 122)),
                          title: Text(
                            'In Progress',
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

                  Container(
                    padding: const EdgeInsets.fromLTRB(15.0, 0, 15.0, 0),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: const <Widget>[
                        ListTile(
                          leading: FaIcon(FontAwesomeIcons.circleCheck,
                              size: 25, color: Color.fromARGB(255, 104, 134, 220)),
                          title: Text(
                            'Completed',
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
                      children: const <Widget>[
                        Text(
                          "Enrolled Subjects",
                          style: TextStyle(
                              color: Color.fromARGB(255, 16, 38 ,65),
                              fontSize: 24.0,
                              fontWeight: FontWeight.bold),
                          textAlign: TextAlign.start,
                        ),
                      ],
                    ),
                  ),

                  Container( //table container
                    padding: const EdgeInsets.fromLTRB(15.0, 15.0, 15.0, 15.0),
                    child: Card(
                      color: Color.fromARGB(255, 249, 250, 254),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(20)),
                      ),
                      child: DataTable(
                        columns: [
                          DataColumn(
                            label: Text('ID'),
                          ),
                          DataColumn(
                            label: Text('Subject Code'),
                          ),
                        ],
                        rows: [
                          DataRow(cells:[
                            DataCell(Text('1')),
                            DataCell(Text('SECR2491')),
                          ]),
                          DataRow(cells:[
                            DataCell(Text('2')),
                            DataCell(Text('SECR3941')),
                          ]),
                        ],
                      ),
                    ),
                  ),

                  Container(
                    padding: const EdgeInsets.fromLTRB(20.0, 30.0, 20.0, 10.0),
                    child: Row (
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                            "UTM Study Planner App V1.0.0",
                            style: TextStyle(color: Colors.grey, fontSize: 12.0)
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}