import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';
import '../../../server/conn.dart';
import '../calendar/Meeting.dart';

class Timetable extends StatefulWidget{
  const Timetable({Key? key}) : super(key: key);

  @override
  _TimetablePageState createState() => _TimetablePageState();
}

class _TimetablePageState extends State<Timetable>{
  final CalendarController _calendarController = CalendarController();
  final DateTime today = DateTime.now();
  late DateTime firstDayOfTheWeek;
  late DateTime lastDayOfTheWeek;
  MeetingDataSource? events;
  final box = Hive.box('');


  @override
  void initState(){
    _testing();
    super.initState();
  }

  _testing(){
    var weekDay = today.weekday;

    firstDayOfTheWeek = today.subtract(Duration(days: weekDay));
    lastDayOfTheWeek = today.subtract(Duration(days: weekDay - 5));
    print(firstDayOfTheWeek);
    print(lastDayOfTheWeek);

  }

  Future<void> getData() async {


    //list to send to dataSource
    List<Meeting> meetings = <Meeting>[];
    var db = Mysql();
    String query = 'SELECT * FROM `subjectlist` JOIN `subjecttaken` ON `subjectlist`.`subjectID` = `subjecttaken`.`subjectID` AND `subjecttaken`.`matricID` =  "' +
        box.get("matricID") +
        '"';
    try {
      var result = await db.execQuery(query);


      for (final row in result.rows) {
        print(firstDayOfTheWeek);
        meetings.add(Meeting(
            row.colAt(2)!,
            DateTime.parse(row.colByName("fromEvent")!),
            DateTime.parse(row.colByName("toEvent")!),
            Color(int.parse(row.colByName("background")!)),
            false,
            int.parse(row.colByName("eventID")!)));
      }
      setState(() {
        events = MeetingDataSource(meetings);
      });
    } catch (e) {
      print(e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Timetable'),
        backgroundColor: const Color.fromRGBO(93, 6, 29, 1.0),
      ),
      body: SfCalendar(
        view: CalendarView.workWeek,
        controller: _calendarController,
        timeSlotViewSettings: const TimeSlotViewSettings(
          startHour: 6,
          endHour: 19,
          nonWorkingDays: <int>[DateTime.friday, DateTime.saturday],
          timeIntervalHeight: -1,
          timeIntervalWidth: -1,
        ),
      ),
    );
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
