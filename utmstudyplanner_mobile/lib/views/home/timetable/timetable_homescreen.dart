import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';
import 'package:utmstudyplanner_mobile/views/home/drawer.dart';
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

  @override
  void initState(){
    _testing();
    super.initState();
  }

  _testing(){
    var weekDay = today.weekday;

    firstDayOfTheWeek = today.subtract(Duration(days: weekDay));
    lastDayOfTheWeek = today.subtract(Duration(days: weekDay - 5));
  }
  
  _getEmployees() async {

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
          endHour: 18,
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
