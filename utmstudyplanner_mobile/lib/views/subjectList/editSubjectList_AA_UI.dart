
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:utmstudyplanner_mobile/views/subjectList/subjectListHomepageAA.dart';
import 'SubjectList.dart';
import '../../server/conn.dart';


class editSubjectList_AA_UI extends StatefulWidget {
  final SubjectList editSubjectList;
  const editSubjectList_AA_UI({Key? key, required this.editSubjectList, email}) : super(key: key);

  final String title = 'Flutter Data Table';

  @override
  editSubjectList_AA_UIState createState() => editSubjectList_AA_UIState();
}

class editSubjectList_AA_UIState extends State<editSubjectList_AA_UI> {
  final List<String> _days = [
    "MON",
    "TUE",
    "WED",
    "THU",
    "FRI",
    "SAT",
    "SUN",
  ];

  final List<String> _time = [
    "6",
    "7",
    "8",
    "9",
    "10",
    "11",
    "12",
    "13",
    "14",
    "15",
    "16",
    "17",
    "18",
  ];

  //form edit/delete names...
  final TextEditingController id = TextEditingController();
  final TextEditingController subjectName = TextEditingController();
  final TextEditingController subjectCourseCode = TextEditingController();
  final TextEditingController subjectCourseType = TextEditingController();
  final TextEditingController subjectDay = TextEditingController();
  final TextEditingController subjectStartTime = TextEditingController();
  final TextEditingController subjectEndTime = TextEditingController();
  final TextEditingController subjectDay_1 = TextEditingController();
  final TextEditingController subjectStartTime_1 = TextEditingController();
  final TextEditingController subjectEndTime_1 = TextEditingController();
  final TextEditingController subjectLecturer = TextEditingController();
  final TextEditingController subjectSectionNumber = TextEditingController();
  final TextEditingController subjectCreditHours = TextEditingController();
  final TextEditingController maxStudents = TextEditingController();
  final TextEditingController semester = TextEditingController();

  final _formeditKey = GlobalKey<FormState>();

  @override
  void initState() {
    id.text = widget.editSubjectList.id.toString();
    subjectName.text = widget.editSubjectList.subjectName;
    subjectCourseCode.text = widget.editSubjectList.subjectCourseCode;
    subjectCourseType.text = widget.editSubjectList.subjectCourseType;
    subjectDay.text = widget.editSubjectList.subjectDay;
    subjectStartTime.text = widget.editSubjectList.subjectStartTime.toString();
    subjectEndTime.text = widget.editSubjectList.subjectEndTime.toString();
    subjectDay_1.text = widget.editSubjectList.subjectDay_1.toString();
    subjectStartTime_1.text = widget.editSubjectList.subjectStartTime_1.toString();
    subjectEndTime_1.text = widget.editSubjectList.subjectEndTime_1.toString();
    subjectLecturer.text = widget.editSubjectList.subjectLecturer;
    subjectSectionNumber.text = widget.editSubjectList.subjectSectionNumber.toString();
    subjectCreditHours.text = widget.editSubjectList.subjectCreditHours.toString();
    maxStudents.text = widget.editSubjectList.maxStudents.toString();
    semester.text = widget.editSubjectList.semester.toString();
    super.initState();
  }

  validateTime(){
    try{
      if(int.parse(subjectStartTime.text) > int.parse(subjectEndTime.text)) {
        throw "End time cannot be more than Start time for Day 1";
      }
      if(int.parse(subjectStartTime_1.text) > int.parse(subjectEndTime_1.text)) {
        throw "End time cannot be more than Start time for Day 2";
      }
      editSubject();
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

  editSubject() async{
    String id_alt = subjectCourseCode.text + subjectSectionNumber.text;

    var db = Mysql();
    String query = "UPDATE `subjectlist` SET "
        "`subjectID` = '"+ id_alt +"', "
        "`subjectName` = '"+ subjectName.text +"', "
        "`subjectCourseCode` = '"+ subjectCourseCode.text +"', "
        "`subjectCourseType` = '"+ subjectCourseType.text +"', "
        "`subjectDay` = '"+ subjectDay.text +"', "
        "`subjectStartTime` = '"+ subjectStartTime.text +"', "
        "`subjectEndTime` = '"+ subjectEndTime.text +"', "
        "`subjectDay_1` = '"+ subjectDay_1.text +"', "
        "`subjectStartTime_1` = '"+ subjectStartTime_1.text +"',"
        "`subjectEndTime_1` = '"+ subjectEndTime_1.text +"', "
        "`subjectLecturer` = '"+ subjectLecturer.text +"', "
        "`subjectSectionNumber` = '"+ subjectSectionNumber.text +"', "
        "`subjectCreditHours` = '"+ subjectCreditHours.text +"' ,"
        "`maxStudents` = '"+ maxStudents.text +"' "
        "WHERE `subjectlist`.`subjectID` = '"+ id.text +"'";

    print(query);

    try {
      var result = await db.execQuery(query);
      if (result.affectedRows.toInt() == 1) {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text('Subject edited'),
              actions: <Widget>[
                FlatButton(
                  child: const Text("OK"),
                  onPressed: () {
                    Navigator.of(context).pop();
                    Navigator.of(context).pop();
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => SubjectListHomepageAA()));
                  },
                ),
              ],
            );
          },
        );
      } else {
        throw 'No changes have been done.';
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
        title: const Text('Edit Subject'),
        backgroundColor: const Color.fromRGBO(93, 6, 29, 1.0),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Center(
          child: Column(
            children: [
              Form(
                key: _formeditKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    TextFormField(
                      enableSuggestions: false,
                      autocorrect: false,
                      controller: subjectName,
                      textInputAction: TextInputAction.next,
                      decoration: InputDecoration(
                          labelText: "Subject Name",
                          contentPadding:
                          const EdgeInsets.only(left: 20, right: 20),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(30.0),
                            borderSide: const BorderSide(
                              width: 1,
                            ),
                          ),
                          filled: true,
                          hintStyle: TextStyle(color: Colors.grey[800]),
                          hintText: "Subject Name",
                          fillColor: Colors.white),
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      validator: (_subjectName) {
                        if(_subjectName == null || _subjectName.isEmpty){
                          return 'Subject Name cannot be empty.';
                        } else if (_subjectName.trim().length > 40){
                          return 'Max. 40 Characters.';
                        } else {
                          return null;
                        }
                      },
                    ),
                    const SizedBox(height: 15),
                    TextFormField(
                      enableSuggestions: false,
                      autocorrect: false,
                      controller: subjectCourseCode,
                      textInputAction: TextInputAction.next,
                      inputFormatters: [
                        FilteringTextInputFormatter.allow(RegExp(r'[0-9999,A-Z]')),
                        LengthLimitingTextInputFormatter(8)],
                      decoration: InputDecoration(
                          labelText: "Subject Course Code",
                          contentPadding:
                          const EdgeInsets.only(left: 20, right: 20),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(30.0),
                            borderSide: const BorderSide(
                              width: 1,
                            ),
                          ),
                          filled: true,
                          hintStyle: TextStyle(color: Colors.grey[800]),
                          hintText: "Subject Course Code",
                          fillColor: Colors.white),
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      validator: (_courseCode) {
                        if(_courseCode == null || _courseCode.isEmpty){
                          return 'Course Code cannot be empty.';
                        } else if (_courseCode.trim().length > 8){
                          return 'Max. 8 Characters.';
                        } else {
                          return null;
                        }
                      },
                    ),
                    const SizedBox(height: 15),
                    FormField<String>(
                      builder: (FormFieldState<String> state) {
                        return InputDecorator(
                          decoration: InputDecoration(
                              labelText: "Subject Type",
                              errorStyle:
                              const TextStyle(color: Colors.redAccent),
                              contentPadding:
                              const EdgeInsets.only(left: 20, right: 20),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(30.0),
                                borderSide: const BorderSide(
                                  width: 1,
                                ),
                              ),
                              filled: true,
                              hintStyle: TextStyle(color: Colors.grey[800]),
                              fillColor: Colors.white),
                          child: DropdownButtonHideUnderline(
                            child: DropdownButton<String>(
                              value: subjectCourseType.text,
                              isDense: true,
                              onChanged: (String? newValue) {
                                setState(() {
                                  subjectCourseType.text = newValue!;
                                });
                              },
                              items: [
                                "1",
                                "2"
                              ].map<DropdownMenuItem<String>>((String value) {
                                return DropdownMenuItem<String>(
                                  value: value,
                                  child: Text(value),
                                );
                              }).toList(),
                            ),
                          ),
                        );
                      },
                    ),
                    const SizedBox(height: 15),

                    FormField<String>(
                      builder: (FormFieldState<String> state) {
                        return InputDecorator(
                          decoration: InputDecoration(
                              labelText: "Subject Day 1",
                              errorStyle:
                              const TextStyle(color: Colors.redAccent),
                              contentPadding:
                              const EdgeInsets.only(left: 20, right: 20),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(30.0),
                                borderSide: const BorderSide(
                                  width: 1,
                                ),
                              ),
                              filled: true,
                              hintStyle: TextStyle(color: Colors.grey[800]),
                              fillColor: Colors.white),
                          child: DropdownButtonHideUnderline(
                            child: DropdownButton<String>(
                              value: subjectDay.text,
                              isDense: true,
                              onChanged: (String? newValue) {
                                setState(() {
                                  subjectDay.text = newValue!;
                                });
                              },
                              items: _days.map<DropdownMenuItem<String>>(
                                      (String value) {
                                    return DropdownMenuItem<String>(
                                      value: value,
                                      child: Text(value),
                                    );
                                  }).toList(),
                            ),
                          ),
                        );
                      },
                    ),
                    const SizedBox(height: 15),

                    Row(
                      children: [
                        Expanded(
                          child: FormField<String>(
                            builder: (FormFieldState<String> state) {
                              return InputDecorator(
                                decoration: InputDecoration(
                                    labelText: "Subject Start Time 1",
                                    errorStyle: const TextStyle(
                                        color: Colors.redAccent),
                                    contentPadding: const EdgeInsets.only(
                                        left: 20, right: 20),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(30.0),
                                      borderSide: const BorderSide(
                                        width: 1,
                                      ),
                                    ),
                                    filled: true,
                                    hintStyle:
                                    TextStyle(color: Colors.grey[800]),
                                    fillColor: Colors.white),
                                child: DropdownButtonHideUnderline(
                                  child: DropdownButton<String>(
                                    value: subjectStartTime.text,
                                    isDense: true,
                                    onChanged: (String? newValue) {
                                      setState(() {
                                        subjectStartTime.text = newValue!;
                                      });
                                    },
                                    items: _time.map<DropdownMenuItem<String>>(
                                            (String value) {
                                          return DropdownMenuItem<String>(
                                            value: value,
                                            child: Text(value),
                                          );
                                        }).toList(),
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                        const SizedBox(width: 15),
                        Expanded(
                          child: FormField<String>(
                            builder: (FormFieldState<String> state) {
                              return InputDecorator(
                                decoration: InputDecoration(
                                    labelText: "Subject End Time 1",
                                    errorStyle: const TextStyle(
                                        color: Colors.redAccent),
                                    contentPadding: const EdgeInsets.only(
                                        left: 20, right: 20),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(30.0),
                                      borderSide: const BorderSide(
                                        width: 1,
                                      ),
                                    ),
                                    filled: true,
                                    hintStyle:
                                    TextStyle(color: Colors.grey[800]),
                                    fillColor: Colors.white),
                                child: DropdownButtonHideUnderline(
                                  child: DropdownButton<String>(
                                    value: subjectEndTime.text,
                                    isDense: true,
                                    onChanged: (String? newValue) {
                                      setState(() {
                                        subjectEndTime.text = newValue!;
                                      });
                                    },
                                    items: _time.map<DropdownMenuItem<String>>(
                                            (String value) {
                                          return DropdownMenuItem<String>(
                                            value: value,
                                            child: Text(value),
                                          );
                                        }).toList(),
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 15),

                    //second class
                    FormField<String>(
                      builder: (FormFieldState<String> state) {
                        return InputDecorator(
                          decoration: InputDecoration(
                              labelText: "Subject Day 2",
                              errorStyle:
                              const TextStyle(color: Colors.redAccent),
                              contentPadding:
                              const EdgeInsets.only(left: 20, right: 20),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(30.0),
                                borderSide: const BorderSide(
                                  width: 1,
                                ),
                              ),
                              filled: true,
                              hintStyle: TextStyle(color: Colors.grey[800]),
                              fillColor: Colors.white),
                          child: DropdownButtonHideUnderline(
                            child: DropdownButton<String>(
                              value: subjectDay_1.text,
                              isDense: true,
                              onChanged: (String? newValue) {
                                setState(() {
                                  subjectDay_1.text = newValue!;
                                });
                              },
                              items: _days.map<DropdownMenuItem<String>>(
                                      (String value) {
                                    return DropdownMenuItem<String>(
                                      value: value,
                                      child: Text(value),
                                    );
                                  }).toList(),
                            ),
                          ),
                        );
                      },
                    ),
                    const SizedBox(height: 15),

                    Row(
                      children: [
                        Expanded(
                          child: FormField<String>(
                            builder: (FormFieldState<String> state) {
                              return InputDecorator(
                                decoration: InputDecoration(
                                    labelText: "Subject Start Time 2",
                                    errorStyle: const TextStyle(
                                        color: Colors.redAccent),
                                    contentPadding: const EdgeInsets.only(
                                        left: 20, right: 20),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(30.0),
                                      borderSide: const BorderSide(
                                        width: 1,
                                      ),
                                    ),
                                    filled: true,
                                    hintStyle:
                                    TextStyle(color: Colors.grey[800]),
                                    fillColor: Colors.white),
                                child: DropdownButtonHideUnderline(
                                  child: DropdownButton<String>(
                                    value: subjectStartTime_1.text,
                                    isDense: true,
                                    onChanged: (String? newValue) {
                                      setState(() {
                                        subjectStartTime_1.text = newValue!;
                                      });
                                    },
                                    items: _time.map<DropdownMenuItem<String>>(
                                            (String value) {
                                          return DropdownMenuItem<String>(
                                            value: value,
                                            child: Text(value),
                                          );
                                        }).toList(),
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                        const SizedBox(width: 15),
                        Expanded(
                          child: FormField<String>(
                            builder: (FormFieldState<String> state) {
                              return InputDecorator(
                                decoration: InputDecoration(
                                    labelText: "Subject End Time 2",
                                    errorStyle: const TextStyle(
                                        color: Colors.redAccent),
                                    contentPadding: const EdgeInsets.only(
                                        left: 20, right: 20),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(30.0),
                                      borderSide: const BorderSide(
                                        width: 1,
                                      ),
                                    ),
                                    filled: true,
                                    hintStyle:
                                    TextStyle(color: Colors.grey[800]),
                                    fillColor: Colors.white),
                                child: DropdownButtonHideUnderline(
                                  child: DropdownButton<String>(
                                    value: subjectEndTime_1.text,
                                    isDense: true,
                                    onChanged: (String? newValue) {
                                      setState(() {
                                        subjectEndTime_1.text = newValue!;
                                      });
                                    },
                                    items: _time.map<DropdownMenuItem<String>>(
                                            (String value) {
                                          return DropdownMenuItem<String>(
                                            value: value,
                                            child: Text(value),
                                          );
                                        }).toList(),
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 15),

                    TextFormField(
                      enableSuggestions: false,
                      autocorrect: false,
                      controller: subjectLecturer,
                      textInputAction: TextInputAction.next,
                      decoration: InputDecoration(
                          labelText: "Lecturer Name",
                          contentPadding:
                          const EdgeInsets.only(left: 20, right: 20),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(30.0),
                            borderSide: const BorderSide(
                              width: 1,
                            ),
                          ),
                          filled: true,
                          hintStyle: TextStyle(color: Colors.grey[800]),
                          hintText: "Lecturer Name",
                          fillColor: Colors.white),
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      validator: (_lecturerName) {
                        if(_lecturerName == null || _lecturerName.isEmpty){
                          return 'Lecturer Name cannot be empty.';
                        } else if (_lecturerName.trim().length > 100){
                          return 'Max. 100 Characters.';
                        } else {
                          return null;
                        }
                      },

                    ),
                    const SizedBox(height: 15),

                    TextFormField(
                      enableSuggestions: false,
                      autocorrect: false,
                      keyboardType: TextInputType.number,
                      controller: subjectSectionNumber,
                      textInputAction: TextInputAction.next,
                      decoration: InputDecoration(
                          labelText: "Section Number",
                          contentPadding:
                          const EdgeInsets.only(left: 20, right: 20),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(30.0),
                            borderSide: const BorderSide(
                              width: 1,
                            ),
                          ),
                          filled: true,
                          hintStyle: TextStyle(color: Colors.grey[800]),
                          hintText: "Section Number",
                          fillColor: Colors.white),
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      validator: (_secName) {
                        if(_secName == null || _secName.isEmpty){
                          return 'Section number cannot be empty.';
                        } else if (_secName.trim().length > 2){
                          return 'Max. 2 Characters.';
                        } else {
                          return null;
                        }
                      },
                    ),
                    const SizedBox(height: 15),

                    TextFormField(
                      enableSuggestions: false,
                      autocorrect: false,
                      controller: subjectCreditHours,
                      keyboardType: TextInputType.number,
                      textInputAction: TextInputAction.next,
                      decoration: InputDecoration(
                          labelText: "Credit Hours",
                          contentPadding:
                          const EdgeInsets.only(left: 20, right: 20),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(30.0),
                            borderSide: const BorderSide(
                              width: 1,
                            ),
                          ),
                          filled: true,
                          hintStyle: TextStyle(color: Colors.grey[800]),
                          hintText: "Credit Hours",
                          fillColor: Colors.white),
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      validator: (_creditHours) {
                        if(_creditHours == null || _creditHours.isEmpty){
                          return 'Credit Hour cannot be empty.';
                        } else if (_creditHours.trim().length > 2){
                          return 'Max. 2 Characters.';
                        } else {
                          return null;
                        }
                      },
                    ),
                    const SizedBox(height: 15),
                    TextFormField(
                      enableSuggestions: false,
                      autocorrect: false,
                      controller: maxStudents,
                      keyboardType: TextInputType.number,
                      textInputAction: TextInputAction.next,
                      decoration: InputDecoration(
                          labelText: "Max Students",
                          contentPadding:
                          const EdgeInsets.only(left: 20, right: 20),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(30.0),
                            borderSide: const BorderSide(
                              width: 1,
                            ),
                          ),
                          filled: true,
                          hintStyle: TextStyle(color: Colors.grey[800]),
                          hintText: "Max Students",
                          fillColor: Colors.white),
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      validator: (_creditHours) {
                        if(_creditHours == null || _creditHours.isEmpty){
                          return 'Max Students cannot be empty.';
                        } else if (_creditHours.trim().length > 2){
                          return 'Max Students 2 chars.';
                        } else {
                          return null;
                        }
                      },
                    ),
                    const SizedBox(height: 15),
                    TextFormField(
                      enableSuggestions: false,
                      autocorrect: false,
                      controller: semester,
                      textInputAction: TextInputAction.next,
                      decoration: InputDecoration(
                          labelText: "Semester",
                          contentPadding:
                          const EdgeInsets.only(left: 20, right: 20),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(30.0),
                            borderSide: const BorderSide(
                              width: 1,
                            ),
                          ),
                          filled: true,
                          hintStyle: TextStyle(color: Colors.grey[800]),
                          hintText: "Semester",
                          fillColor: Colors.white),
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      validator: (_semester) {
                        if(_semester == null || _semester.isEmpty){
                          return 'Semester cannot be empty.';
                        } else if (_semester.trim().length > 9){
                          return 'Max. 9 Characters.';
                        } else {
                          return null;
                        }
                      },

                    ),


                    const SizedBox(height: 30),

                    Container(
                      width: MediaQuery.of(context).size.width / 2.0,
                      height: 40,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(30.0),
                        color: const Color.fromARGB(255, 93, 6, 29),
                      ),
                      child: MaterialButton(
                        onPressed: () =>
                        _formeditKey.currentState!.validate()
                            ? validateTime()
                            : null,
                        child: const Text(
                          'Edit Subject',
                          style: TextStyle(
                            fontSize: 18,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
