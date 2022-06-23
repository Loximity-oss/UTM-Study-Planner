import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:utmstudyplanner_mobile/views/subjectList/addSubjectList_AA_UI.dart';
import 'package:utmstudyplanner_mobile/views/subjectList/editSubjectList_AA_UI.dart';

import '../../server/conn.dart';
import 'SubjectList.dart';

class SubjectListHomepageAA extends StatefulWidget {
  //
  SubjectListHomepageAA() : super();

  final String title = 'Flutter Data Table';

  @override
  SubjectListHomepageAAState createState() => SubjectListHomepageAAState();
}

class SubjectListHomepageAAState extends State<SubjectListHomepageAA> {
  late List<SubjectList> SubjectLists;
  late GlobalKey<ScaffoldState> _scaffoldKey;
  late TextEditingController _searchBox;
  late SubjectList _selectedEmployee;
  late bool _isUpdating;
  late String _titleProgress;
  var db = Mysql();
  late String semester;

  //form keys
  final _formSearchKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    SubjectLists = [];
    semester = "";
    _semesterConfiguration();
    _isUpdating = false;
    _titleProgress = widget.title;
    _scaffoldKey = GlobalKey(); // key to get the context to show a SnackBar
    _searchBox = TextEditingController();
    _searchBox.addListener(() {
      _searchForm();
    });
    _getEmployees();
  }

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

  // Method to update title in the AppBar Title
  _showProgress(String message) {
    setState(() {
      _titleProgress = message;
    });
  }

  _getEmployees() async {
    _showProgress('Loading Tables...');
    semester = '20220231';
    String query =
        'SELECT * FROM `subjectlist` WHERE `semester` = "' + semester + '"';
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

  _deleteEmployee(SubjectList SubjectList) async {
    _showProgress('Deleting SubjectList...');
    String query =
        'DELETE FROM `subjectlist` WHERE `subjectlist`.`subjectID` = ' +
            SubjectList.id.toString();
    try {
      var result = await db.execQuery(query);
      if (result.affectedRows.toInt() == 1) {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text('Successfully deleted.'),
              actions: <Widget>[
                FlatButton(
                  child: const Text("OK"),
                  onPressed: () {
                    Navigator.pop(context);
                    Navigator.pop(context);
                    _getEmployees();
                  },
                ),
              ],
            );
          },
        );
      } else {
        throw 'Course does not exist.';
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

  // Method to clear TextField values
  _clearValues() {
    _searchBox.text = '';
  }

  _searchForm() async {
    print(_searchBox.text);
    if (_searchBox.text == '') {
      _getEmployees();
    } else {
      String query =
          'SELECT * FROM `subjectlist` WHERE `subjectCourseCode` LIKE "' +
              _searchBox.text +
              '%"';
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
          print(row.colAt(14));
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
              '\n\nSubject Name : ' +
              SubjectList.subjectName +
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
              SubjectList.maxStudents.toString()),
          actions: <Widget>[
            FlatButton(
              child: const Text("Edit"),
              onPressed: () {
                Navigator.pop(context);
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => editSubjectList_AA_UI(
                            editSubjectList: SubjectList)));
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
              label: Text('ID'),
            ),
            DataColumn(
              label: Text('Subject Code'),
            ),
            DataColumn(
              label: Text('Section'),
            ),
            DataColumn(
              label: Text('Actions'),
            )
          ],
          rows: SubjectLists.map(
            (SubjectList) => DataRow(cells: [
              DataCell(
                Text(SubjectList.id.toString()),
                // Add tap in the row and populate the
                // textfields with the corresponding values to update
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
              DataCell(IconButton(
                icon: const Icon(Icons.delete),
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: const Text('Confirm Deletion?'),
                        actions: <Widget>[
                          FlatButton(
                            child: const Text("Yes"),
                            onPressed: () {
                              _deleteEmployee(SubjectList);
                            },
                          ),
                          FlatButton(
                            child: const Text("No"),
                            onPressed: () {
                              Navigator.pop(context);
                            },
                          ),
                        ],
                      );
                    },
                  );
                },
              ))
            ]),
          ).toList(),
        ),
      ),
    );
  }

  // UI
  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                      width: 1,
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
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => addSubjectList_AA_UI()),
          );
          ;
        },
        backgroundColor: Colors.blueGrey,
        child: const Icon(Icons.add),
      ),
    );
  }
}
