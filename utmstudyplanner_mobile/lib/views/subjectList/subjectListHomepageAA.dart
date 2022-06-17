import 'package:flutter/material.dart';

import '../../server/conn.dart';
import 'SubjectList.dart';
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

  @override
  void initState() {
    super.initState();
    SubjectLists = [];
    _isUpdating = false;
    _titleProgress = widget.title;
    _scaffoldKey = GlobalKey(); // key to get the context to show a SnackBar
    _searchBox = TextEditingController();
    _getEmployees();
  }

  // Method to update title in the AppBar Title
  _showProgress(String message) {
    setState(() {
      _titleProgress = message;
    });
  }

  _showSnackBar(context, message) {
    _scaffoldKey.currentState?.showSnackBar(
      SnackBar(
        content: Text(message),
      ),
    );
  }



  // Now lets add an SubjectList
  _addEmployee() {

    _showProgress('Adding SubjectList...');

  }

  _getEmployees() async {
    _showProgress('Loading Tables...');
    var db = Mysql();
    String query = 'SELECT * FROM `subjectlist`';
    try {
      List<SubjectList> a = [];
      var result = await db.execQuery(query);
      for (final row in result.rows) {
        SubjectList b = SubjectList(
          int.parse(row.colAt(0)!),
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
          int.parse(row.colAt(11)!),
          int.parse(row.colAt(12)!),
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

  _updateEmployee(SubjectList SubjectList) {
    setState(() {
      _isUpdating = true;
    });
    _showProgress('Updating SubjectList...');

  }

  _deleteEmployee(SubjectList SubjectList) {
    _showProgress('Deleting SubjectList...');

  }

  // Method to clear TextField values
  _clearValues() {
    _searchBox.text = '';
  }

  _showValues(SubjectList SubjectList) {

  }


  SingleChildScrollView _dataBody() {
    return SingleChildScrollView(
      scrollDirection: Axis.vertical,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: DataTable(
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
          rows: SubjectLists
              .map(
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
                Text(
                  SubjectList.subjectCourseCode
                ),
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
                  _deleteEmployee(SubjectList);
                },
              ))
            ]),
          )
              .toList(),
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
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: TextField(
              controller: _searchBox,
              decoration: const InputDecoration.collapsed(
                hintText: 'Search by Course Name...',
              ),
            ),
          ),

          // Add an update button and a Cancel Button
          // show these buttons only when updating an SubjectList
          _isUpdating
              ? Row(
            children: <Widget>[
              OutlineButton(
                child: Text('UPDATE'),
                onPressed: () {
                  _updateEmployee(_selectedEmployee);
                },
              ),
              OutlineButton(
                child: Text('CANCEL'),
                onPressed: () {
                  setState(() {
                    _isUpdating = false;
                  });
                  _clearValues();
                },
              ),
            ],
          )
              : Container(),
          Expanded(
            child: _dataBody(),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _addEmployee();
        },
        child: Icon(Icons.add),
      ),
    );
  }
}