import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hive/hive.dart';
import 'package:utmstudyplanner_mobile/views/subjectList/addSubjectList_AA_UI.dart';
import 'package:utmstudyplanner_mobile/views/subjectList/editSubjectList_AA_UI.dart';

import '../../server/conn.dart';
import '../home/homescreen.dart';
import 'SubjectList.dart';

class SubjectListHomepageStudent extends StatefulWidget {
  //
  SubjectListHomepageStudent() : super();

  @override
  SubjectListHomepageStudentState createState() =>
      SubjectListHomepageStudentState();
}

class SubjectListHomepageStudentState
    extends State<SubjectListHomepageStudent> {
  final box = Hive.box('');
  late List<SubjectList> SubjectLists;
  late GlobalKey<ScaffoldState> _scaffoldKey;
  late TextEditingController _searchBox;
  late SubjectList _selectedEmployee;
  late bool _isUpdating;
  late String _titleProgress;
  var db = Mysql();

  //form keys
  final _formSearchKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    SubjectLists = [];
    _isUpdating = false;
    _scaffoldKey = GlobalKey(); // key to get the context to show a SnackBar
    _searchBox = TextEditingController();
    _searchBox.addListener(() {
      _searchForm();
    });
    _getEmployees();
  }

  // Method to update title in the AppBar Title
  _showProgress(String message) {
    setState(() {
      _titleProgress = message;
    });
  }

  _addSubject(SubjectList SubjectList) async {
    //compare
    try {
      if ((SubjectList.currentStudents + 1) > SubjectList.maxStudents) {
        throw 'Max. Student Registered';
      } else {
        String query =
            "INSERT INTO `subjecttaken` (`subjectTakenID`, `matricID`, `subjectID`, `subjectCourseCode`) VALUES "
                    "(NULL, "
                    "'" +
                box.get('matricID') +
                "', '" +
                SubjectList.id.toString() +
                "', '" +
                SubjectList.subjectCourseCode +
                "');";

        String query2 = "\nUPDATE `subjectlist` SET `currentStudents` = '" +
            (SubjectList.currentStudents + 1).toString() +
            "' WHERE `subjectlist`.`subjectID` = "
                "'" +
            SubjectList.id.toString() +
            "';";
        print(query);
        print(query2);

        var result = await db.execQuery(query);
        var result2 = await db.execQuery(query2);

        if (result.affectedRows.toInt() == 1 &&
            result2.affectedRows.toInt() == 1) {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: const Text('Subject Added'),
                actions: <Widget>[
                  FlatButton(
                    child: const Text("OK"),
                    onPressed: () {
                      Navigator.of(context).pop();
                      Navigator.of(context).pop();
                      _getEmployees();
                    },
                  ),
                ],
              );
            },
          );
        } else {
          throw 'Error';
        }
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
                  Navigator.pop(context);
                },
              ),
            ],
          );
        },
      );
    }
  }

  _getEmployees() async {
    _showProgress('Loading Tables...');
    String query =
        "SELECT * FROM subjectlist LEFT OUTER JOIN subjecttaken ON subjectlist.subjectCourseCode = subjecttaken.subjectCourseCode AND subjecttaken.matricID = '" +
            box.get('matricID') +
            "' WHERE subjecttaken.matricID IS NULL LIMIT 30";
    print(query);
    try {
      List<SubjectList> a = [];
      var result = await db.execQuery(query);
      for (final row in result.rows) {
        SubjectList b = SubjectList(
          row.colAt(0)!,
          row.colAt(1)!,
          row.colAt(2)!,
          row.colAt(3)!,
          row.colAt(4)!,
          int.parse(row.colAt(5)!),
          int.parse(row.colAt(6)!),
          row.colAt(7)!,
          int.parse(row.colAt(8)!),
          int.parse(row.colAt(9)!),
          row.colAt(10)!,
          row.colAt(11)!,
          int.parse(row.colAt(12)!),
          int.parse(row.colAt(13)!),
          row.colAt(15)!,
          int.parse(row.colAt(14)!),
        );
        a.add(b);
      }
      setState(() {
        SubjectLists = a;
        _showProgress('Subject List');
      });
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
                  Navigator.pop(context);
                  Navigator.pop(context);
                },
              ),
            ],
          );
        },
      );
    }
  }

  _searchForm() async {
    print(_searchBox.text);
    if (_searchBox.text == '') {
      _getEmployees();
    } else {
      String query =
          "SELECT * FROM subjectlist LEFT OUTER JOIN subjecttaken ON subjectlist.subjectCourseCode = subjecttaken.subjectCourseCode AND subjecttaken.matricID = '" +
              box.get('matricID') +
              "' WHERE subjecttaken.matricID IS NULL AND subjectlist.subjectCourseCode LIKE '" +
              _searchBox.text +
              "%'";
      print(query);
      try {
        List<SubjectList> a = [];
        var result = await db.execQuery(query);
        for (final row in result.rows) {
          SubjectList b = SubjectList(
            row.colAt(0)!,
            row.colAt(1)!,
            row.colAt(2)!,
            row.colAt(3)!,
            row.colAt(4)!,
            int.parse(row.colAt(5)!),
            int.parse(row.colAt(6)!),
            row.colAt(7)!,
            int.parse(row.colAt(8)!),
            int.parse(row.colAt(9)!),
            row.colAt(10)!,
            row.colAt(11)!,
            int.parse(row.colAt(12)!),
            int.parse(row.colAt(13)!),
            row.colAt(15)!,
            int.parse(row.colAt(14)!),
          );
          a.add(b);
        }
        setState(() {
          SubjectLists = a;
          _showProgress('Subject List');
        });
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
                    Navigator.pop(context);
                  },
                ),
              ],
            );
          },
        );
      }
    }
  }

  _showValues(SubjectList SubjectList) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Subject : ' +
              SubjectList.subjectCourseCode +
              '\nSection : ' +
              SubjectList.subjectSectionNumber.toString()),
          content: Text('\nSubject ID : ' +
              SubjectList.id.toString() +
              '\n\nSubject Course Code : ' +
              SubjectList.subjectCourseCode +
              '\n\nSubject Course Type : ' +
              SubjectList.subjectCourseType +
              '\n\nSubject Day 1 : ' +
              SubjectList.subjectDay +
              '\n\nSubject Start Time 1 : ' +
              SubjectList.subjectStartTime.toString() +
              '\n\nSubject End Time 1 : ' +
              SubjectList.subjectEndTime.toString() +
              '\n\nSubject Day 2 : ' +
              SubjectList.subjectDay_1 +
              '\n\nSubject Start Time 2 : ' +
              SubjectList.subjectStartTime_1.toString() +
              '\n\nSubject End Time 2 : ' +
              SubjectList.subjectEndTime_1.toString() +
              '\n\nSubject Lecturer : ' +
              SubjectList.subjectLecturer +
              '\n\nSubject Section No. : ' +
              SubjectList.subjectSectionNumber.toString() +
              '\n\nSubject Credit Hours. : ' +
              SubjectList.subjectCreditHours.toString() +
              '\n\nSubject Max Students. : ' +
              SubjectList.maxStudents.toString() +
              '\n\nSubject Current Students. : ' +
              SubjectList.currentStudents.toString()),
          actions: <Widget>[
            FlatButton(
              child: const Text("Add"),
              onPressed: () {
                _addSubject(SubjectList);
              },
            ),
            FlatButton(
              child: const Text("Close"),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ],
        );
      },
    );
  }

  SingleChildScrollView _dataBody() {
    return SingleChildScrollView(
      scrollDirection: Axis.vertical,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: DataTable(
          columnSpacing: 40.0,
          columns: const [
            DataColumn(
              label: Text('Subject Code'),
            ),
            DataColumn(
              label: Text('Section'),
            ),
            DataColumn(
              label: Text('Registered'),
            ),
            DataColumn(
              label: Text('Max. Cap'),
            )
          ],
          rows: SubjectLists.map(
            (SubjectList) => DataRow(cells: [
              DataCell(
                Text(SubjectList.subjectCourseCode),
                onTap: () {
                  _showValues(SubjectList);
                  // Set the Selected SubjectList to Update
                  _selectedEmployee = SubjectList;
                  // Set flag updating to true to indicate in Update Mode
                  setState(() {
                    _isUpdating = true;
                  });
                },
              ),
              DataCell(
                Text(
                  SubjectList.subjectSectionNumber.toString(),
                ),
                onTap: () {
                  _showValues(SubjectList);
                  // Set the Selected SubjectList to Update
                  _selectedEmployee = SubjectList;
                  setState(() {
                    _isUpdating = true;
                  });
                },
              ),
              DataCell(
                Text(
                  SubjectList.currentStudents.toString(),
                ),
                onTap: () {
                  _showValues(SubjectList);
                  // Set the Selected SubjectList to Update
                  _selectedEmployee = SubjectList;
                  setState(() {
                    _isUpdating = true;
                  });
                },
              ),
              DataCell(
                Text(
                  SubjectList.maxStudents.toString(),
                ),
                onTap: () {
                  _showValues(SubjectList);
                  // Set the Selected SubjectList to Update
                  _selectedEmployee = SubjectList;
                  setState(() {
                    _isUpdating = true;
                  });
                },
              ),
            ]),
          ).toList(),
        ),
      ),
    );
  }

  Future<bool> _onWillPop() async {
    Navigator.of(context).pop(false);
    Navigator.of(context).pop(false);
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => const homepage()));
    return false;
  }

  // UI
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
          backgroundColor: const Color.fromARGB(255, 93, 6, 29),
          iconTheme: (const IconThemeData(color: Colors.white)),
          title: Text(_titleProgress),
          actions: <Widget>[
            IconButton(
              icon: const Icon(Icons.refresh),
              onPressed: () {
                _getEmployees();
              },
            )
          ],
        ),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Form(
              key: _formSearchKey,
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: TextFormField(
                  enableSuggestions: false,
                  autocorrect: false,
                  controller: _searchBox,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30.0),
                      borderSide: const BorderSide(
                        width: 0,
                        style: BorderStyle.none,
                      ),
                    ),
                    filled: true,
                    hintStyle: TextStyle(color: Colors.grey[800]),
                    hintText: "Search by Subject Code...",
                    fillColor: Colors.white,
                  ),
                ),
              ),
            ),

            // Add an update button and a Cancel Button
            // show these buttons only when updating an SubjectList

            Expanded(
              child: _dataBody(),
            ),
          ],
        ),
      ),
    );
  }
}
