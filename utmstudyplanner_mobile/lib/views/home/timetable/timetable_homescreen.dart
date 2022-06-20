import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';
import 'package:utmstudyplanner_mobile/views/home/drawer.dart';
import '../../../server/conn.dart';

class Timetable extends StatefulWidget{
  const Timetable({Key? key}) : super(key: key);

  @override
  _TimetablePageState createState() => _TimetablePageState();
}

class _TimetablePageState extends State<Timetable>{

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: DefAppBar(),
      appBar: AppBar(
        title: const Text('Timetable'),
        backgroundColor: const Color.fromRGBO(93, 6, 29, 1.0),
      ),
      body: SfCalendar(
        view: CalendarView.week,
        timeSlotViewSettings: const TimeSlotViewSettings(
          startHour: 6,
          endHour: 18,
        ),
      ),
    );
  }


}