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
  DateTime currentTime = DateTime.now();
  DateTime _firstDayOfTheweek = DateTime.now();


  @override
  void initstate(){
    g
    super.initState();
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
        allowViewNavigation: false,
        view: CalendarView.week,
        minDate: _firstDayOfTheweek,
      ),
    );
  }


}