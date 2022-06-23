import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';
import 'dart:math';

import '../../../server/conn.dart';
import '../homescreen.dart';
import 'Meeting.dart';

class Timetable extends StatefulWidget {
  const Timetable({Key? key}) : super(key: key);

  @override
  _TimetablePageState createState() => _TimetablePageState();
}

class _TimetablePageState extends State<Timetable> {
  final CalendarController _calendarController = CalendarController();
  final DateTime today = DateTime.now();
  late DateTime firstDayOfTheWeek;
  late DateTime placeholder;
  late List<DateTime> dayStartTime;
  late List<DateTime> dayEndTime;
  MeetingDataSource? events;
  late Color _selectedColor;
  final box = Hive.box('');
  var db = Mysql();

  List<Color> rand = [
    const Color(0xFF880E4F),
    const Color(0xFFB71C1C),
    const Color(0xFFB71C1C),
    const Color(0xFFE65100),
    const Color(0xFFFF6F00),
    const Color(0xFF827717),
    const Color(0xFF1B5E20),
    const Color(0xFF006064),
    const Color(0xFF01579B),
    const Color(0xFF0D47A1),
    const Color(0xFF1A237E),
    const Color(0xFF4A148C),
    const Color(0xFF311B92),
    const Color(0xFF263328),
    const Color(0xFF212121),
  ];


  @override
  void initState() {
    dayStartTime = [];
    dayEndTime = [];
    print(today.weekday);
    if (today.weekday != 7) {
      firstDayOfTheWeek = today.subtract(Duration(days: today.weekday));
    } else {
      firstDayOfTheWeek = today;
    }
    // 1 = monday, 2 = tue, ...
    getData();
    super.initState();
  }

  Color randColor() {
    Random random = Random();
    int randomNumber = random.nextInt(rand.length);
    Color sent = rand[randomNumber];
    rand.removeAt(randomNumber);
    return sent;
  }

  void getDay(String Day, int startTime, int endTime) {
    placeholder = firstDayOfTheWeek;
    switch (Day) {
      case 'MON':
        placeholder = placeholder.add(Duration(days: 1));
        break;
      case 'TUE':
        placeholder = placeholder.add(Duration(days: 2));
        break;
      case 'WED':
        placeholder = placeholder.add(Duration(days: 3));
        break;
      case 'THU':
        placeholder = placeholder.add(Duration(days: 4));
        break;
    }
    print(Day + " " + placeholder.toString());
    dayStartTime.add(DateTime(
        placeholder.year, placeholder.month, placeholder.day, startTime));
    dayEndTime.add(DateTime(
        placeholder.year, placeholder.month, placeholder.day, endTime));
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
                          appointmentDetails.from.toString(),
                          style: const TextStyle(
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: <Widget>[
                        Text(
                          appointmentDetails.to.toString(),
                          style: const TextStyle(
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
                      deleteData(
                          appointmentDetails.id,
                          appointmentDetails.currentStudents,
                          appointmentDetails.courseCode);
                    },
                    child: Text('Delete')),
                TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: Text('Close')),
              ],
            );
          });
    }
  }

  Future<void> deleteData(
      String id, int currentStudents, String courseCode) async {
    String query =
        'DELETE FROM `subjecttaken` WHERE `subjecttaken`.`subjectTakenID` = "' +
            id +
            '"';

    String query2 = 'UPDATE `subjectlist` SET `currentStudents` = "' +
        (currentStudents - 1).toString() +
        '" WHERE `subjectlist`.`subjectID` = "' +
        courseCode +
        '"';

    print(query2);
    try {
      var result = await db.execQuery(query);
      var result2 = await db.execQuery(query2);
      if (result.affectedRows.toInt() == 1 &&
          result2.affectedRows.toInt() == 1) {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text('Subject Deleted'),
              actions: <Widget>[
                FlatButton(
                  child: const Text("OK"),
                  onPressed: () {
                    Navigator.of(context).pop();
                    getData();
                  },
                ),
              ],
            );
          },
        );
      } else {
        throw 'Error';
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
                  setState(() {});
                },
              ),
            ],
          );
        },
      );
    }
  }

  Future<void> getData() async {
    //list to send to dataSource
    List<Meeting> meetings = <Meeting>[];

    String query =
        'SELECT * FROM `subjectlist` JOIN `subjecttaken` ON `subjectlist`.`subjectID` = `subjecttaken`.`subjectID` AND `subjecttaken`.`matricID` =  "' +
            box.get("matricID") +
            '"';

    try {
      var result = await db.execQuery(query);

      for (final row in result.rows) {
        //set fixed color for one subject
        _selectedColor = randColor();
        //modify dates
        getDay(
            row.colByName('subjectDay')!,
            int.parse(row.colByName('subjectStartTime')!),
            int.parse(row.colByName('subjectEndTime')!));

        meetings.add(Meeting(
          row.colByName("subjectCourseCode")! +
              "-" +
              row.colByName('subjectSectionNumber')!,
          dayStartTime[0],
          dayEndTime[0],
          _selectedColor,
          false,
          row.colByName("subjectTakenID")!,
          int.parse(row.colByName("currentStudents")!),
          row.colByName("subjectCourseCode")! +
              row.colByName('subjectSectionNumber')!,
        ));

        if (row.colByName('subjectDay_1')! != 'N/A') {
          getDay(
              row.colByName('subjectDay_1')!,
              int.parse(row.colByName('subjectStartTime_1')!),
              int.parse(row.colByName('subjectEndTime_1')!));

          meetings.add(Meeting(
            row.colByName("subjectCourseCode")! +
                "-" +
                row.colByName('subjectSectionNumber')!,
            dayStartTime[1],
            dayEndTime[1],
            _selectedColor,
            false,
            row.colByName("subjectTakenID")!,
            int.parse(row.colByName("currentStudents")!),
            row.colByName("subjectCourseCode")! +
                row.colByName('subjectSectionNumber')!,
          ));
        }

        dayStartTime.clear();
        dayEndTime.clear();
      }
      setState(() {
        events = MeetingDataSource(meetings);
      });
    } catch (e) {
      print(e.toString());
    }
  }

  Future<bool> _onWillPop() async {
    Navigator.of(context).pop(false);
    Navigator.of(context).pop(false);
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => const homepage()));
    return false;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Timetable'),
          backgroundColor: const Color.fromRGBO(93, 6, 29, 1.0),
        ),
        body: SfCalendar(
          onTap: tapped,

          view: CalendarView.workWeek,
          dataSource: events,
          controller: _calendarController,
          specialRegions: _getTimeRegions(),
          maxDate: DateTime(firstDayOfTheWeek.year, firstDayOfTheWeek.month,
              firstDayOfTheWeek.day + 4, 23, 59, 0),
          minDate: DateTime(firstDayOfTheWeek.year, firstDayOfTheWeek.month,
              firstDayOfTheWeek.day, 0, 0, 0),
          timeSlotViewSettings: const TimeSlotViewSettings(

            startHour: 6,
            endHour: 19,
            nonWorkingDays: <int>[DateTime.friday, DateTime.saturday],
            timeIntervalHeight: -1,
            timeIntervalWidth: -1,
          ),
        ),
      ),
    );
  }

  List<TimeRegion> _getTimeRegions() {
    final List<TimeRegion> regions = <TimeRegion>[];
    regions.add(TimeRegion(
      startTime: DateTime(firstDayOfTheWeek.year, firstDayOfTheWeek.month,
          firstDayOfTheWeek.day, 13, 0, 0),
      endTime: DateTime(firstDayOfTheWeek.year, firstDayOfTheWeek.month,
          firstDayOfTheWeek.day, 14, 0, 0),
      enablePointerInteraction: false,
      recurrenceRule: 'FREQ=DAILY;INTERVAL=1',
      textStyle: TextStyle(color: Colors.black45, fontSize: 15),
      color: Colors.grey.withOpacity(0.2),
    ));

    return regions;
  }
}

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
  String id(int index) {
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
