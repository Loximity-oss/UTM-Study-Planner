import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hive/hive.dart';
import 'package:http/http.dart';
import 'package:intl/intl.dart';
import 'package:mysql_client/mysql_client.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';
import 'package:utmstudyplanner_mobile/views/home/calendar/Meeting.dart';

import '../../../server/conn.dart';


/// The hover page which hosts the calendar
class CalendarApp extends StatefulWidget {
  /// Creates the home page to display the calendar widget.
  const CalendarApp({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _CalendarPageState createState() => _CalendarPageState();
}

class _CalendarPageState extends State<CalendarApp> {
  final box = Hive.box('');
  final titleInput = TextEditingController();
  final dateBeforeInput = TextEditingController();
  final dateAfterInput = TextEditingController();
  final timeBeforeInput = TextEditingController();
  final timeAfterInput = TextEditingController();
  final _formAddEventKey = GlobalKey<FormState>();
  final _formEditEventKey = GlobalKey<FormState>();

  MeetingDataSource? events;
  Future<void> editData(int id) async{
    var db = Mysql();
    String query = 'UPDATE `event` SET `eventName` = "'+ titleInput.text +'", '
        '`fromEvent` = "'+ dateBeforeInput.text + ' ' + timeBeforeInput.text +'", '
    '`toEvent` = "'+ dateAfterInput.text + ' ' + timeAfterInput.text +'", '
    '`background` = "0xFF0F8644" '
    'WHERE `event`.`eventID` = "'+ id.toString() + '"';
    try{
      var result = await db.execQuery(query);
      if (result.affectedRows.toInt() == 1) {
        titleInput.clear();
        dateBeforeInput.clear();
        dateAfterInput.clear();
        timeBeforeInput.clear();
        timeAfterInput.clear();

        Navigator.of(context).pop();
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text('Event Edited'),
              actions: <Widget>[
                TextButton(
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
              TextButton(
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

    getData();
  }

  Future<void> addData() async{
    var db = Mysql();
    String query = 'INSERT INTO `event` (`eventID`, `eventName`, `fromEvent`, `toEvent`, `background`, `isAllDay`, `matricID`) VALUES (NULL, '
        '"'+ titleInput.text +'", '
        '"'+ dateBeforeInput.text + ' ' + timeBeforeInput.text +'", '
        '"'+ dateAfterInput.text + ' ' + timeAfterInput.text +'", '
        '"0xFF0F8644", 0, '
        '"'+ box.get('matricID')+'")';

    print(query);
    try{
      var result = await db.execQuery(query);
      if (result.affectedRows.toInt() == 1) {
        titleInput.clear();
        dateBeforeInput.clear();
        dateAfterInput.clear();
        timeBeforeInput.clear();
        timeAfterInput.clear();

        Navigator.of(context).pop();
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text('Event Added'),
              actions: <Widget>[
                TextButton(
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
              TextButton(
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

    getData();
  }

  Future<void> deleteData(int id) async{
    var db = Mysql();
    String query = 'DELETE FROM event WHERE `event`.`eventID` = "'+ id.toString() +'"';
    try{
      var result = await db.execQuery(query);
      if (result.affectedRows.toInt() == 1) {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text('Event Deleted'),
              actions: <Widget>[
                TextButton(
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
              TextButton(
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
    getData();
  }

  Future<void> getData() async{
    //list to send to dataSource
    List<Meeting> meetings = <Meeting>[];
    var db = Mysql();
    String query = 'SELECT * FROM `event` WHERE `matricID` = "'+ box.get("matricID") +'"';
    print(query);
    try{
      var result = await db.execQuery(query);

      for (final row in result.rows) {
        print(DateTime.parse(row.colByName("fromEvent")!));
        meetings.add(Meeting(
            row.colByName("eventName")!,
            DateTime.parse(row.colByName("fromEvent")!),
            DateTime.parse(row.colByName("toEvent")!),
            Color(int.parse(row.colByName("background")!)),
            false,
            int.parse(row.colByName("eventID")!)));
      }
      setState(() {
        events = MeetingDataSource(meetings);
      });

    }catch(e) {
      print(e.toString());
    }
  }

  void editDataModal(Meeting appointmentDetails) async{
    titleInput.text = appointmentDetails.eventName;
    dateBeforeInput.text = DateFormat('yyyy-MM-dd').format(appointmentDetails.from);
    dateAfterInput.text = DateFormat('yyyy-MM-dd').format(appointmentDetails.to);
    timeBeforeInput.text = DateFormat('hh:mm:ss').format(appointmentDetails.from);
    timeAfterInput.text = DateFormat('hh:mm:ss').format(appointmentDetails.to);

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Edit Event'),
          content: Form(
            key: _formEditEventKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                TextFormField(controller: titleInput,
                  textInputAction: TextInputAction.next,
                  enableSuggestions: false,
                  autocorrect: false,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  validator: (title) {
                    if (title == null || title.isEmpty) {
                      return 'Please enter a title.';
                    } else {
                      return null;
                    }
                  },
                  decoration: InputDecoration(
                      hintStyle: TextStyle(color: Colors.grey[800]),
                      hintText: "Event Title"),
                ),
                TextFormField(
                  controller: dateBeforeInput,
                  onTap: () async {
                    FocusScope.of(context).requestFocus(FocusNode());
                    final DateTime? selectedDate = await showDatePicker(context: context,
                        initialDate: DateTime.now(),
                        firstDate: DateTime(0),
                        lastDate: DateTime(9999));
                    dateBeforeInput.text = DateFormat('yyyy-MM-dd').format(selectedDate!);
                  },
                  decoration: InputDecoration(
                      contentPadding: const EdgeInsets.only(left: 20, right: 20),
                      hintText: DateFormat.yMMMEd().format(DateTime.now()),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30.0),
                        borderSide: const BorderSide(
                          width: 0,
                          style: BorderStyle.none,
                        ),
                      ),
                      filled: true,
                      fillColor: Colors.white
                  ),
                ),
                TextFormField(
                  controller: timeBeforeInput,
                  onTap: () async {
                    FocusScope.of(context).requestFocus(FocusNode());
                    final TimeOfDay? selectedTime = await showTimePicker(context: context,
                        initialTime: TimeOfDay.now()
                    );

                    DateTime formattedTime(TimeOfDay today){
                      final newTime = DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day, today.hour, today.minute);
                      return newTime;
                    }
                    timeBeforeInput.text = DateFormat('hh:mm:ss').format(formattedTime(selectedTime!));
                  },
                  decoration: InputDecoration(
                      contentPadding: const EdgeInsets.only(left: 20, right: 20),
                      hintText: DateFormat.Hm().format(DateTime.now()),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30.0),
                        borderSide: const BorderSide(
                          width: 0,
                          style: BorderStyle.none,
                        ),
                      ),
                      filled: true,
                      fillColor: Colors.white
                  ),
                ),

                TextFormField(
                  controller: dateAfterInput,
                  onTap: () async {
                    FocusScope.of(context).requestFocus(FocusNode());
                    final DateTime? selectedDate = await showDatePicker(context: context,
                        initialDate: DateTime.now(),
                        firstDate: DateTime(0),
                        lastDate: DateTime(9999));
                    dateAfterInput.text = DateFormat('yyyy-MM-dd').format(selectedDate!);
                  },

                  decoration: InputDecoration(
                      contentPadding: const EdgeInsets.only(left: 20, right: 20),
                      hintText: DateFormat.yMMMEd().format(DateTime.now()),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30.0),
                        borderSide: const BorderSide(
                          width: 0,
                          style: BorderStyle.none,
                        ),
                      ),
                      filled: true,
                      fillColor: Colors.white
                  ),
                ),

                TextFormField(
                  controller: timeAfterInput,
                  onTap: () async {
                    FocusScope.of(context).requestFocus(FocusNode());
                    final TimeOfDay? selectedTime = await showTimePicker(context: context,
                        initialTime: TimeOfDay.now()
                    );

                    DateTime formattedTime(TimeOfDay today){
                      final newTime = DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day, today.hour, today.minute);
                      return newTime;
                    }
                    timeAfterInput.text = DateFormat('hh:mm:ss').format(formattedTime(selectedTime!));
                  },
                  decoration: InputDecoration(
                      contentPadding: const EdgeInsets.only(left: 20, right: 20),
                      hintText: DateFormat.jm().format(DateTime.now().add(const Duration(hours: 2))),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30.0),
                        borderSide: const BorderSide(
                          width: 0,
                          style: BorderStyle.none,
                        ),
                      ),
                      filled: true,
                      fillColor: Colors.white
                  ),
                ),


              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text("OK"),
              onPressed: () => _formEditEventKey.currentState!.validate() ? editData(appointmentDetails.id) : null,
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

    //getData();
  }



  void tapped(CalendarTapDetails details) {
    if (details.targetElement == CalendarElement.appointment ||
        details.targetElement == CalendarElement.agenda) {
      final Meeting appointmentDetails = details.appointments![0];
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text(appointmentDetails.eventName),
              content: SizedBox(
                height: 80,
                child: Column(
                  children: <Widget>[
                    Row(
                      children: <Widget>[
                        Text(
                          appointmentDetails.to.toString(),
                          style: TextStyle(
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: <Widget>[
                        Text(
                          appointmentDetails.to.toString(),
                          style: TextStyle(
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ],
                    ),

                  ],
                ),
              ),
              actions: <Widget>[
                TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                      deleteData(appointmentDetails.id);
                    },
                    child: new Text('Delete')),
                TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                      editDataModal(appointmentDetails);
                    },
                    child: new Text('Edit')),
                TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: new Text('Close')),
              ],
            );
          });
    }
  }





  @override
  void initState() {
    getData();
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Calendar'),
        backgroundColor: const Color.fromRGBO(93, 6, 29, 1.0),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: const Text('Add Event'),
                content: Container(
                  child: Form(
                    key: _formAddEventKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        TextFormField(
                          controller: titleInput,
                          textInputAction: TextInputAction.next,
                          enableSuggestions: false,
                          autocorrect: false,
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          validator: (title) {
                            if (title == null || title.isEmpty) {
                              return 'Please enter a title.';
                            } else {
                              return null;
                            }},
                          decoration: InputDecoration(
                              hintStyle: TextStyle(color: Colors.grey[800]),
                              hintText: "Event Title"),
                        ),
                        TextFormField(
                          controller: dateBeforeInput,
                          onTap: () async {
                            FocusScope.of(context).requestFocus(FocusNode());
                            final DateTime? selectedDate = await showDatePicker(context: context,
                                initialDate: DateTime.now(),
                                firstDate: DateTime(0),
                                lastDate: DateTime(9999));
                            dateBeforeInput.text = DateFormat('yyyy-MM-dd').format(selectedDate!);
                          },
                          decoration: InputDecoration(
                              contentPadding: const EdgeInsets.only(left: 20, right: 20),
                              hintText: DateFormat.yMMMEd().format(DateTime.now()),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(30.0),
                                borderSide: const BorderSide(
                                  width: 0,
                                  style: BorderStyle.none,
                                ),
                              ),
                              filled: true,
                              fillColor: Colors.white
                          ),
                        ),
                        TextFormField(
                          controller: timeBeforeInput,
                          onTap: () async {
                            FocusScope.of(context).requestFocus(FocusNode());
                            final TimeOfDay? selectedTime = await showTimePicker(context: context,
                                initialTime: TimeOfDay.now()
                            );

                            DateTime formattedTime(TimeOfDay today){
                              final newTime = DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day, today.hour, today.minute);
                              return newTime;
                            }
                            timeBeforeInput.text = DateFormat('hh:mm:ss').format(formattedTime(selectedTime!));
                          },
                          decoration: InputDecoration(
                              contentPadding: const EdgeInsets.only(left: 20, right: 20),
                              hintText: DateFormat.Hm().format(DateTime.now()),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(30.0),
                                borderSide: const BorderSide(
                                  width: 0,
                                  style: BorderStyle.none,
                                ),
                              ),
                              filled: true,
                              fillColor: Colors.white
                          ),
                        ),

                        TextFormField(
                          controller: dateAfterInput,
                          onTap: () async {
                            FocusScope.of(context).requestFocus(FocusNode());
                            final DateTime? selectedDate = await showDatePicker(context: context,
                                initialDate: DateTime.now(),
                                firstDate: DateTime.now().add(const Duration(hours: -1)),
                                lastDate: DateTime(9999));
                            dateAfterInput.text = DateFormat('yyyy-MM-dd').format(selectedDate!);
                          },

                          decoration: InputDecoration(
                              contentPadding: const EdgeInsets.only(left: 20, right: 20),
                              hintText: DateFormat.yMMMEd().format(DateTime.now()),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(30.0),
                                borderSide: const BorderSide(
                                  width: 0,
                                  style: BorderStyle.none,
                                ),
                              ),
                              filled: true,
                              fillColor: Colors.white
                          ),
                        ),

                        TextFormField(
                          controller: timeAfterInput,
                          onTap: () async {
                            FocusScope.of(context).requestFocus(FocusNode());
                            final TimeOfDay? selectedTime = await showTimePicker(context: context,
                                initialTime: TimeOfDay.now()
                            );

                            DateTime formattedTime(TimeOfDay today){
                              final newTime = DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day, today.hour, today.minute);
                              return newTime;
                            }
                            timeAfterInput.text = DateFormat('hh:mm:ss').format(formattedTime(selectedTime!));
                          },
                          decoration: InputDecoration(
                              contentPadding: const EdgeInsets.only(left: 20, right: 20),
                              hintText: DateFormat.jm().format(DateTime.now().add(const Duration(hours: 2))),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(30.0),
                                borderSide: const BorderSide(
                                  width: 0,
                                  style: BorderStyle.none,
                                ),
                              ),
                              filled: true,
                              fillColor: Colors.white
                          ),
                        ),


                      ],
                    ),
                  ),

                ),
                actions: <Widget>[
                  TextButton(
                    child: const Text("OK"),
                    onPressed: () => _formAddEventKey.currentState!.validate() ? addData() : null,
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
        backgroundColor: Colors.blueGrey,
        child: const Icon(Icons.add),
      ),
      body: SfCalendar(
          view: CalendarView.schedule,
          showDatePickerButton: true,
          todayHighlightColor: Colors.blue,
          dataSource: events,
          onTap: tapped,
          scheduleViewMonthHeaderBuilder: (BuildContext buildContext,
          ScheduleViewMonthHeaderDetails details)
      {
      final String monthName = _getMonthName(details.date.month);
        return Stack(
          children: [
              Image(
              image: ExactAssetImage('assets/images/' + monthName + '.png'),
              fit: BoxFit.cover,
              width: details.bounds.width,
              height: details.bounds.height),
              Positioned(
              left: 55,
              right: 0,
              top: 20,
              bottom: 0,
              child: Text(
              monthName + ' ' + details.date.year.toString(),
              style: const TextStyle(fontSize: 18),
              ),
            )
          ],
        );
      },

      allowedViews: const <CalendarView>
      [
        CalendarView.day,
        CalendarView.week,
        CalendarView.workWeek,
        CalendarView.month,
        CalendarView.schedule
      ],
      // by default the month appointment display mode set as Indicator, we can
      // change the display mode as appointment using the appointment display
      // mode property
      monthViewSettings: const MonthViewSettings(
          showAgenda: true,
          appointmentDisplayMode: MonthAppointmentDisplayMode.indicator),
    ));
  }

  String _getMonthName(int month) {
    if (month == 01) {
      return 'January';
    } else if (month == 02) {
      return 'February';
    } else if (month == 03) {
      return 'March';
    } else if (month == 04) {
      return 'April';
    } else if (month == 05) {
      return 'May';
    } else if (month == 06) {
      return 'June';
    } else if (month == 07) {
      return 'July';
    } else if (month == 08) {
      return 'August';
    } else if (month == 09) {
      return 'September';
    } else if (month == 10) {
      return 'October';
    } else if (month == 11) {
      return 'November';
    } else {
      return 'December';
    }
  }
}


/// An object to set the appointment collection data source to calendar, which
/// used to map the custom appointment data to the calendar appointment, and
/// allows to add, remove or reset the appointment collection.
class MeetingDataSource extends CalendarDataSource {

  /// Creates a meeting data source, which used to set the appointment
  /// collection to the calendar
  MeetingDataSource(List<Meeting> source) {
    appointments = source;
  }

  @override
  DateTime getStartTime(int index) {
    return _getMeetingData(index).from;
  }

  @override
  DateTime getEndTime(int index) {
    return _getMeetingData(index).to;
  }

  @override
  String getSubject(int index) {
    return _getMeetingData(index).eventName;
  }

  @override
  Color getColor(int index) {
    return _getMeetingData(index).background;
  }

  @override
  bool isAllDay(int index) {
    return _getMeetingData(index).isAllDay;
  }

  @override
  int id(int index) {
    return _getMeetingData(index).id;
  }

  Meeting _getMeetingData(int index) {
    final dynamic meeting = appointments![index];
    late final Meeting meetingData;
    if (meeting is Meeting) {
      meetingData = meeting;
    }

    return meetingData;
  }
}

