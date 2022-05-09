import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

void main() {
  return runApp(CalendarApp());
}

/// The hover page which hosts the calendar
class CalendarApp extends StatefulWidget {
  /// Creates the home page to display the calendar widget.
  const CalendarApp({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _CalendarPageState createState() => _CalendarPageState();
}

class _CalendarPageState extends State<CalendarApp> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          backgroundColor: const Color.fromRGBO(93, 6, 29, 1.0),
      ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {

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
                    style: TextStyle(fontSize: 18),
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

  List<Meeting> _getDataSource() {
    final List<Meeting> meetings = <Meeting>[];
    meetings.add(Meeting(
        'Conference', DateTime(2022, 5, 8, 9, 0, 0), DateTime(2022, 5, 8, 11, 0, 0), const Color(0xFF0F8644), false));
    meetings.add(Meeting(
        'Test 1 Computer Networks', DateTime(2022, 5, 18, 20, 0, 0), DateTime(2022, 5, 18, 22, 0, 0), const Color(0xff00a4b4), false));
    meetings.add(Meeting(
        'Exam 1 Computer Networks Lab', DateTime(2022, 5, 19, 20, 0, 0), DateTime(2022, 5, 19, 22, 0, 0), const Color(0xFFB2A4D4), false));
    return meetings;
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

  Meeting _getMeetingData(int index) {
    final dynamic meeting = appointments![index];
    late final Meeting meetingData;
    if (meeting is Meeting) {
      meetingData = meeting;
    }

    return meetingData;
  }
}

/// Custom business object class which contains properties to hold the detailed
/// information about the event data which will be rendered in calendar.
class Meeting {
  /// Creates a meeting class with required details.
  Meeting(this.eventName, this.from, this.to, this.background, this.isAllDay);

  /// Event name which is equivalent to subject property of [Appointment].
  String eventName;

  /// From which is equivalent to start time property of [Appointment].
  DateTime from;

  /// To which is equivalent to end time property of [Appointment].
  DateTime to;

  /// Background which is equivalent to color property of [Appointment].
  Color background;

  /// IsAllDay which is equivalent to isAllDay property of [Appointment].
  bool isAllDay;
}