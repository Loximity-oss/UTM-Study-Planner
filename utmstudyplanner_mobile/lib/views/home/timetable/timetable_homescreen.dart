import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';
import 'package:utmstudyplanner_mobile/views/home/drawer.dart';
import '../../../server/conn.dart';

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: DefAppBar(),
      appBar: AppBar(
        title: const Text('Timetable'),
        backgroundColor: const Color.fromRGBO(93, 6, 29, 1.0),
      ),
      body: SfCalendar(
        view: CalendarView.workWeek,
        controller: _calendarController,
        timeSlotViewSettings: const TimeSlotViewSettings(
          startHour: 7,
          endHour: 20,
          nonWorkingDays: <int>[DateTime.friday, DateTime.saturday],
          timeIntervalHeight: -1,
          timeIntervalWidth: -1,
        ),
      ),
    );
  }
}