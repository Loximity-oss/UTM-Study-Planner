import 'dart:async';
import 'dart:convert';

import 'dart:developer';

import 'dart:typed_data';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hive/hive.dart';
import 'package:intl/intl.dart';
import 'package:utmstudyplanner_mobile/views/home/drawer.dart';

import '../../server/conn.dart';

class homepage extends StatefulWidget {
  const homepage({Key? key}) : super(key: key);

  @override
  State<homepage> createState() => _homepageState();
}

class _homepageState extends State<homepage> {
  late List<SummarySubjectList> _summarySubjectList;
  String toDo = 'None', inProgress = 'None', completed = 'None';
  String subjectList = 'Enrolled Subjects';
  late String semester;
  final box = Hive.box('');
  var db = Mysql();
  String? _image;

  _semesterConfiguration() {
    final DateTime now = DateTime.now();
    final DateFormat formatter1 = DateFormat("MM");
    String currentMonth = formatter1.format(now);

    //find q2 and q1
    if (int.parse(currentMonth) > DateTime.september) {
      //currentYear 2023, new 202320241
      final DateTime currentYear = DateTime(now.year + 1);
      final DateTime lastYear = DateTime(now.year);
      final DateFormat formatter = DateFormat('yyyy');
      semester =
          formatter.format(lastYear) + formatter.format(currentYear) + '1';
    } else if (int.parse(currentMonth) < DateTime.september) {
      //currentYear 2023, new 202220232
      final DateTime currentYear = DateTime(now.year);
      final DateTime lastYear = DateTime(now.year - 1);
      final DateFormat formatter = DateFormat('yyyy');
      semester =
          formatter.format(lastYear) + formatter.format(currentYear) + '2';
    }
  }

  void loadProfilePic() async {
    try {
      String query = 'SELECT profilePicture FROM `users` WHERE `email` = "' +
          box.get('email') +
          '" AND password = "' +
          box.get('password') +
          '"';

      var result = await db.execQuery(query);
      for (final row in result.rows) {
        final s = row.colAt(0);
        setState(() {
          _image = s;
        });
      }
    } catch (e) {
      print(e.toString());
    }
  }

  void loadData() async {
    try {
      List<SummarySubjectList> temp = [];
      String query;
      if (box.get('coursecode') == 'LECTURER') {
        query =
            'SELECT `subjectSectionNumber`, `subjectCourseCode` FROM `subjectlist` ORDER BY `subjectlist`.`subjectSectionNumber` ASC LIMIT 8';
        subjectList = 'Subject List for ' + semester;
      } else {
        query =
            'SELECT `subjectSectionNumber`, `subjectlist`.`subjectCourseCode` FROM `subjectlist` JOIN `subjecttaken` ON `subjectlist`.`subjectID` = `subjecttaken`.`subjectID` AND `subjecttaken`.`matricID` = "' +
                box.get('matricID') +
                '"';
      }

      var result = await db.execQuery(query);
      for (final row in result.rows) {
        SummarySubjectList temp_a =
            SummarySubjectList(int.parse(row.colAt(0)!), row.colAt(1)!);
        temp.add(temp_a);
      }
      setState(() {
        _summarySubjectList = temp;
      });
    } catch (e) {
      print(e.toString());
    }
  }

  void loadCalendarActivity() async {
    try {
      String query = 'SELECT * FROM `event` WHERE `matricID` = "' +
          box.get("matricID") +
          '"';

      var result = await db.execQuery(query);
      for (final row in result.rows) {
        int toDo, inProgress, completed;
      }
      setState(() {});
    } catch (e) {
      print(e.toString());
    }
  }

  @override
  void initState() {
    semester = "";
    _semesterConfiguration();
    loadData();
    loadProfilePic();
    _summarySubjectList = [];
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 255, 249, 235),
      drawer: DefAppBar(),
      body: NestedScrollView(
        //where appBar resides
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
                    preferredSize: Size.fromHeight(kToolbarHeight + 150)),
              ),
              floating: false,
              pinned: false,
            ),
          ];
        },
        body: CustomScrollView(
          // main content
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
                              child: (_image != null)
                                  ? Image.memory(
                                      base64Decode(_image!),
                                      fit: BoxFit.fill,
                                    )
                                  : Image.asset(
                                      "assets/Profile/default.png",
                                      fit: BoxFit.fill,
                                    ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 10),
                        Container(
                            child: Text(
                          box.get('nickname'),
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.bold),
                        )),
                        //TODO: link with backend
                        Container(
                            child: Text(
                          box.get('matricID'),
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 11,
                          ),
                        )),
                        Container(
                            child: Text(
                          box.get('coursecode'),
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 11,
                          ),
                        )),
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
                              color: Color.fromARGB(255, 16, 38, 65),
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
                      children: <Widget>[
                        ListTile(
                          leading: const FaIcon(FontAwesomeIcons.solidClock,
                              size: 25,
                              color: Color.fromARGB(255, 228, 99, 113)),
                          title: const Text(
                            'To Do',
                            style: TextStyle(
                                color: Color.fromARGB(255, 65, 72, 101),
                                fontWeight: FontWeight.bold),
                          ),
                          subtitle: Text(
                            toDo,
                            style: const TextStyle(
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
                      children: <Widget>[
                        ListTile(
                          leading: const FaIcon(
                              FontAwesomeIcons.circleExclamation,
                              size: 25,
                              color: Color.fromARGB(255, 248, 191, 122)),
                          title: const Text(
                            'In Progress',
                            style: TextStyle(
                                color: Color.fromARGB(255, 65, 72, 101),
                                fontWeight: FontWeight.bold),
                          ),
                          subtitle: Text(
                            inProgress,
                            style: const TextStyle(
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
                      children: <Widget>[
                        ListTile(
                          leading: const FaIcon(FontAwesomeIcons.circleCheck,
                              size: 25,
                              color: Color.fromARGB(255, 104, 134, 220)),
                          title: const Text(
                            'Completed',
                            style: TextStyle(
                                color: Color.fromARGB(255, 65, 72, 101),
                                fontWeight: FontWeight.bold),
                          ),
                          subtitle: Text(
                            completed,
                            style: const TextStyle(
                              color: Color.fromARGB(255, 166, 169, 166),
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
                          subjectList,
                          style: const TextStyle(
                              color: Color.fromARGB(255, 16, 38, 65),
                              fontSize: 24.0,
                              fontWeight: FontWeight.bold),
                          textAlign: TextAlign.start,
                        ),
                      ],
                    ),
                  ),
                  Container(
                    //table container
                    padding: const EdgeInsets.fromLTRB(15.0, 15.0, 15.0, 15.0),
                    child: Card(
                      color: Color.fromARGB(255, 249, 250, 254),
                      shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(20)),
                      ),
                      child: DataTable(
                        columns: const [
                          DataColumn(
                            label: Text('Section'),
                          ),
                          DataColumn(
                            label: Text('Subject Code'),
                          ),
                        ],
                        rows: _summarySubjectList
                            .map(
                              (SummarySubjectList) => DataRow(cells: [
                                DataCell(
                                  Text(SummarySubjectList.subjectSectionNumber
                                      .toString()),
                                ),
                                DataCell(
                                  Text(SummarySubjectList.subjectCourseCode
                                      .toString()),
                                ),
                              ]),
                            )
                            .toList(),
                      ),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.fromLTRB(20.0, 30.0, 20.0, 10.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        Text("UTM Study Planner App V1.0.0",
                            style:
                                TextStyle(color: Colors.grey, fontSize: 12.0)),
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

class SummarySubjectList {
  String subjectCourseCode;
  int subjectSectionNumber;

  SummarySubjectList(this.subjectSectionNumber, this.subjectCourseCode);
}
