import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hive/hive.dart';
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

  @override
  void initState() {
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
            //Navigator.of(context).push(MaterialPageRoute(builder: (context) => const CalendarEvent()));
          },
          backgroundColor: Colors.blueGrey,
          child: const Icon(Icons.add),
        ),
        body: SfCalendar(
          view: CalendarView.schedule,
          showDatePickerButton: true,
          todayHighlightColor: Colors.blue,
          dataSource: MeetingDataSource(_getDataSource()),
          scheduleViewMonthHeaderBuilder: (BuildContext buildContext,
              ScheduleViewMonthHeaderDetails details) {
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

  Future<List<Meeting>> _getDataSource() async {
    List<Meeting> meetings = <Meeting>[];
    var db = Mysql();
    String query = 'SELECT * FROM `event` WHERE `matricID` = "'+ box.get("matricID") +'";';
    try{
      var result = await db.execQuery(query);
    }catch(e) {

    }



    meetings.add(Meeting(
        'Conference', DateTime(2022, 5, 8, 9, 0, 0), DateTime(2022, 5, 8, 11, 0, 0), const Color(0xFF0F8644), false, 1));
    return meetings;  /// Creates a meeting class with required details.
  }
}

/// An object to set the appointment collection data source to calendar, which
/// used to map the custom appointment data to the calendar appointment, and
/// allows to add, remove or reset the appointment collection.
class MeetingDataSource extends CalendarDataSource {

  /// Creates a meeting data source, which used to set the appointment
  /// collection to the calendar
  MeetingDataSource(Future<List<Meeting>> source) {
    appointments = source as List?;
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

