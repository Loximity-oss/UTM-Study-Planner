import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'package:utmstudyplanner_mobile/views/home/drawer.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';
import '../../../server/conn.dart';
import 'SubjectList.dart';

class SubjectListHomepageAA extends StatefulWidget {
  const SubjectListHomepageAA({Key? key}) : super(key: key);

  @override
  _SubjectListHomepageAAPageState createState() =>
      _SubjectListHomepageAAPageState();
}

class _SubjectListHomepageAAPageState extends State<SubjectListHomepageAA> {
  final subjectName = TextEditingController();
  final subjectCourseCode = TextEditingController();
  final subjectCourseType = TextEditingController();
  final subjectDay = TextEditingController();
  final subjectStartTime = TextEditingController();
  final subjectEndTime = TextEditingController();
  final subjectDay_1 = TextEditingController();
  final subjectStartTime_1 = TextEditingController();
  final subjectEndTime_1 = TextEditingController();
  final subjectLecturer = TextEditingController();
  final subjectSectionNumber = TextEditingController();
  final subjectCreditHours = TextEditingController();

  final _formAddSubjectKey = GlobalKey<FormState>();
  late SubjectListDataSource subjectListDataSource;
  final List<SubjectList> _subjectList = <SubjectList>[];
  late List<GridColumn> _columns;

  @override
  void initState() {
    _columns = getColumns();
    super.initState();
  }

  Future<void> delete() async {
    var db = Mysql();
    String query =
        'DELETE FROM `subjectlist` WHERE `subjectlist`.`subjectID` = ' +
            row.getCells()[0].value.toString() +
            '';
    try {
      var result = await db.execQuery(query);
      if (result.affectedRows.toInt() == 1) {
        Navigator.pop(context);
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text(
                  'Deleted Successfully.'),
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
      } else {
        throw 'Internal Error';
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
                  Navigator.pop(context);
                },
              ),
            ],
          );
        },
      );
    }
  }

  Future<void> edit() async {

  }

  Future<void> add() async {

  }


  Future<dynamic> generateSubjectList() async {
    _subjectList.clear();
    var db = Mysql();
    String query = 'SELECT * FROM `subjectlist`';
    try {
      var result = await db.execQuery(query);
      for (final row in result.rows) {
        _subjectList.add(SubjectList(
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
        ));
      }
      subjectListDataSource = SubjectListDataSource(_subjectList);
      return Future.value(_subjectList);
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

  List<GridColumn> getColumns() {
    return <GridColumn>[
      GridColumn(
          columnName: 'id',
          width: 70,
          label: Container(
              padding: EdgeInsets.all(16.0),
              alignment: Alignment.center,
              child: const Text(
                'ID',
              ))),
      GridColumn(
          columnName: 'Course Code',
          width: 80,
          label: Container(
              padding: EdgeInsets.all(8.0),
              alignment: Alignment.center,
              child: const Text('Course Code'))),
      GridColumn(
          columnName: 'Section',
          width: 120,
          label: Container(
              padding: EdgeInsets.all(8.0),
              alignment: Alignment.center,
              child: const Text(
                'Section',
                overflow: TextOverflow.ellipsis,
              ))),
      GridColumn(
          columnName: 'Actions',
          label: Container(
              padding: EdgeInsets.all(8.0),
              alignment: Alignment.center,
              child: const Text('Actions'))),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        drawer: DefAppBar(),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  title: const Text('Add Subject'),
                  content: Container(
                    child: Form(
                      key: _formAddSubjectKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          TextFormField(
                            controller: subjectName,
                            textInputAction: TextInputAction.next,
                            enableSuggestions: false,
                            autocorrect: false,
                            autovalidateMode:
                                AutovalidateMode.onUserInteraction,
                            validator: (subjectName) {
                              if (subjectName == null || subjectName.isEmpty) {
                                return 'Please enter a subject name';
                              } else if (subjectName.length > 40) {
                                return 'Exceeded Course Name Limit.';
                              } else {
                                return null;
                              }
                            },
                            decoration: InputDecoration(
                                hintStyle: TextStyle(color: Colors.grey[800]),
                                hintText: "Subject Name"),
                          ),
                          TextFormField(
                            controller: subjectCourseCode,
                            textInputAction: TextInputAction.next,
                            enableSuggestions: false,
                            autocorrect: false,
                            autovalidateMode:
                                AutovalidateMode.onUserInteraction,
                            validator: (subjectDay) {
                              if (subjectDay == null || subjectDay.isEmpty) {
                                return 'Please enter Course Code';
                              } else if (subjectDay.length > 3) {
                                return 'Exceeded Course Code Limit.';
                              } else {
                                return null;
                              }
                            },
                            decoration: InputDecoration(
                                hintStyle: TextStyle(color: Colors.grey[800]),
                                hintText: "Course Code"),
                          ),


                        ],
                      ),
                    ),
                  ),
                  actions: <Widget>[
                    FlatButton(child: const Text("OK"), onPressed: () {}),
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
          backgroundColor: Colors.blueGrey,
          child: const Icon(Icons.add),
        ),
        appBar: AppBar(
          title: const Text('Subject List'),
          backgroundColor: const Color.fromRGBO(93, 6, 29, 1.0),
        ),
        body: FutureBuilder<dynamic>(
            future: generateSubjectList(),
            builder: (context, data) {
              return data.hasData
                  ? SfDataGrid(
                      source: subjectListDataSource,
                      columnWidthMode: ColumnWidthMode.fill,
                      columns: _columns)
                  : const Center(
                      child: CircularProgressIndicator(
                      strokeWidth: 2,
                      value: 0.8,
                    ));
            }));
  }
}

class SubjectListDataSource extends DataGridSource {
  /// Creates the SubjectList data source class with required details.
  SubjectListDataSource(this.SubjectLists) {
    buildDataGridRow();
  }

  void buildDataGridRow() {
    _SubjectListDataGridRows =
        SubjectLists.map<DataGridRow>((e) => DataGridRow(cells: [
              DataGridCell<int>(columnName: 'id', value: e.id),
              DataGridCell<String>(
                  columnName: 'subjectCourseCode', value: e.subjectCourseCode),
              DataGridCell<int>(
                  columnName: 'subjectSectionNumber',
                  value: e.subjectSectionNumber),
              const DataGridCell<Widget>(columnName: 'button', value: null),
            ])).toList();
  }

  List<SubjectList> SubjectLists = [];

  List<DataGridRow> _SubjectListDataGridRows = [];

  @override
  List<DataGridRow> get rows => _SubjectListDataGridRows;
  
  @override
  DataGridRowAdapter? buildRow(DataGridRow row) {
    return DataGridRowAdapter(
        cells: row.getCells().map<Widget>((dataGridCell) {
      return Container(
          alignment: Alignment.center,
          child: dataGridCell.columnName == 'button'
              ? LayoutBuilder(
                  builder: (BuildContext context, BoxConstraints constraints) {
                  return IconButton(
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: const Text('Confirm deletion of subject?'),
                              content: const Text('a'),
                              actions: <Widget>[
                                FlatButton(
                                  child: const Text("OK"),
                                  onPressed: () {

                                  },
                                ),
                              ],
                            );
                          },
                        );
                      },
                      icon: const FaIcon(FontAwesomeIcons.trash));
                })
              : Text(dataGridCell.value.toString()));
    }).toList());
  }

  void updateDataGrid() {
    notifyListeners();
  }
}
