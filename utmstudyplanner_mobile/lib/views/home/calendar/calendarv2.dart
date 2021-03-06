import 'package:date_time_picker/date_time_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:intl/intl.dart';


import 'package:syncfusion_flutter_calendar/calendar.dart';
import 'package:utmstudyplanner_mobile/views/home/calendar/Meeting.dart';
import 'package:utmstudyplanner_mobile/views/notifications/LocalNotifyManager.dart';

import '../../../server/conn.dart';

/// The hover page which hosts the calendar
class CalendarApp extends StatefulWidget {
  /// Creates the home page to display the calendar widget.
  const CalendarApp({Key? key}) : super(key: key);

  @override
  _CalendarPageState createState() => _CalendarPageState();
}

class _CalendarPageState extends State<CalendarApp> {
  final box = Hive.box('');
  final titleInput = TextEditingController();
  late TextEditingController dateBeforeInput;
  late TextEditingController dateAfterInput;

  final reminderNumber = TextEditingController();

  List<String> listItems = ["days", "weeks", "hours"];
  String dropdownValue = "days";

  final _formAddEventKey = GlobalKey<FormState>();
  final _formEditEventKey = GlobalKey<FormState>();

  MeetingDataSource? events;
  Future<void> editData(int id) async {
    var db = Mysql();
    String query = 'UPDATE `event` SET `eventName` = "' +
        titleInput.text +
        '", '
            '`fromEvent` = "' +
        dateBeforeInput.text +
        '", '
            '`toEvent` = "' +
        dateAfterInput.text +
        '", '
            '`background` = "0xFF0F8644", '
            '`reminder_number` = "' +
        reminderNumber.text +
        '", '
            '`reminder_date` = "' +
        dropdownValue +
        '" '
            'WHERE `event`.`eventID` = "' +
        id.toString() +
        '"';
    try {
      var result = await db.execQuery(query);
      if (result.affectedRows.toInt() == 1) {
        clearData();

        Navigator.of(context).pop();
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text('Event Edited'),
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

    getData();
  }

  Future<void> addData() async {
    var db = Mysql();
    String query =
        'INSERT INTO `event` (`eventID`, `eventName`, `fromEvent`, `toEvent`, `background`, `isAllDay`, `reminder_number`, `reminder_date`, `matricID`) VALUES (NULL, '
                '"' +
            titleInput.text +
            '", '
                '"' +
            dateBeforeInput.text +
            '", '
                '"' +
            dateAfterInput.text +
            '", '
                '"0xFF0F8644", 0, '
                '"' +
            reminderNumber.text +
            '", '
                '"' +
            dropdownValue +
            '", '
                '"' +
            box.get('matricID') +
            '")';

    print(query);
    try {
      var result = await db.execQuery(query);
      if (result.affectedRows.toInt() == 1) {
        clearData();

        Navigator.of(context).pop();
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text('Event Added'),
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

    getData();
  }

  Future<void> deleteData(int id) async {
    var db = Mysql();
    String query =
        'DELETE FROM event WHERE `event`.`eventID` = "' + id.toString() + '"';
    try {
      var result = await db.execQuery(query);
      if (result.affectedRows.toInt() == 1) {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text('Event Deleted'),
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
    getData();
  }

  Future<void> getData() async {
    dateAfterInput = TextEditingController(text: DateTime.now().toString());
    dateBeforeInput = TextEditingController(text: DateTime.now().toString());

    //list to send to dataSource
    List<Meeting> meetings = <Meeting>[];
    var db = Mysql();
    String query = 'SELECT * FROM `event` WHERE `matricID` = "' +
        box.get("matricID") +
        '"';
    try {
      var result = await db.execQuery(query);

      localNotifyManager.scheduleNotification(result);

      for (final row in result.rows) {
        meetings.add(Meeting(
            row.colByName("eventName")!,
            DateTime.parse(row.colByName("fromEvent")!),
            DateTime.parse(row.colByName("toEvent")!),
            Color(int.parse(row.colByName("background")!)),
            false,
            int.parse(row.colByName("eventID")!),
            int.parse(row.colByName("reminder_number")!),
            row.colByName("reminder_date")!));
      }
      setState(() {
        events = MeetingDataSource(meetings);
      });
    } catch (e) {
      print(e.toString());
    }
  }

  void clearData() {
    titleInput.clear();
    dateBeforeInput.clear();
    dateAfterInput.clear();
    reminderNumber.clear();
    dropdownValue = "days";
  }

  void editDataModal(Meeting appointmentDetails) async {
    titleInput.text = appointmentDetails.eventName;
    dateBeforeInput.text =
        DateFormat('yyyy-MM-dd HH:mm:ss').format(appointmentDetails.from);
    dateAfterInput.text =
        DateFormat('yyyy-MM-dd HH:mm:ss').format(appointmentDetails.to);

    reminderNumber.text = appointmentDetails.reminderNumber.toString();
    dropdownValue = appointmentDetails.dateType;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Edit Event'),
          content: Container(
            child: Form(
              key: _formEditEventKey,
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
                      }
                    },
                    decoration: InputDecoration(
                        hintStyle: TextStyle(color: Colors.grey[800]),
                        hintText: "Event Title"),
                  ),
                  DateTimePicker(
                    controller: dateBeforeInput,
                    type: DateTimePickerType.dateTime,
                    dateMask: 'yyyy-MM-dd HH:mm:ss',
                    firstDate: DateTime.now(),
                    lastDate: DateTime(9999),
                    icon: const Icon(Icons.event),
                    dateLabelText: 'Starting Date and Time',
                  ),
                  DateTimePicker(
                    controller: dateAfterInput,
                    type: DateTimePickerType.dateTime,
                    dateMask: 'yyyy-MM-dd HH:mm:ss',
                    firstDate: DateTime.now(),
                    lastDate: DateTime(9999),
                    icon: const Icon(Icons.event),
                    dateLabelText: 'End Date and Time',
                    validator: (dateTime) {
                      DateTime valStart = DateTime.parse(dateBeforeInput.text);
                      DateTime valEnd = DateTime.parse(dateAfterInput.text);
                      if (valEnd.isBefore(valStart)) {
                        return 'Invalid Date and Time';
                      }
                      return null;
                    },
                  ),
                  Row(
                    children: <Widget>[
                      Expanded(
                        flex: 4,
                        child: TextFormField(
                            controller: reminderNumber,
                            keyboardType: TextInputType.number,
                            enableSuggestions: false,
                            autocorrect: false,
                            autovalidateMode:
                                AutovalidateMode.onUserInteraction,
                            decoration: InputDecoration(
                              icon: Icon(Icons.notification_add),
                              labelText: "Reminder Time",
                            ),
                            validator: (reminderNumber) {
                              if (reminderNumber != '') {
                                int intReminderNumber =
                                    int.parse(reminderNumber.toString());
                                if (dropdownValue == 'days') {
                                  if (intReminderNumber < 1 ||
                                      intReminderNumber > 28) {
                                    return 'Between 1 and 28 days';
                                  } else {
                                    return null;
                                  }
                                } else if (dropdownValue == 'weeks') {
                                  if (intReminderNumber < 1 ||
                                      intReminderNumber > 4) {
                                    return 'Between 1 to 4 weeks';
                                  } else {
                                    return null;
                                  }
                                } else if (dropdownValue == 'hours') {
                                  if (intReminderNumber < 1 ||
                                      intReminderNumber > 24) {
                                    return 'Between 1 to 23 hours';
                                  } else {
                                    return null;
                                  }
                                }
                              } else {
                                return 'Please enter the field';
                              }
                            }),
                      ),
                      Expanded(
                        flex: 2,
                        child: DropdownButtonFormField(
                            icon: const Icon(Icons.keyboard_arrow_down),
                            value: dropdownValue,
                            onChanged: ((value) {
                              setState(() {
                                dropdownValue = value.toString();
                              });
                            }),
                            items: listItems.map((item) {
                              return DropdownMenuItem(
                                  value: item, child: Text(item));
                            }).toList()),
                      )
                    ],
                  )
                ],
              ),
            ),
          ),
          actions: <Widget>[
            FlatButton(
              child: const Text("OK"),
              onPressed: () => _formEditEventKey.currentState!.validate()
                  ? editData(appointmentDetails.id)
                  : null,
            ),
            FlatButton(
              child: const Text("Cancel"),
              onPressed: () {
                Navigator.of(context).pop();
                clearData();
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
              title: Text("Title: " + appointmentDetails.eventName),
              content: SizedBox(
                height: 80,
                child: Column(
                  children: <Widget>[
                    Row(
                      children: <Widget>[
                        Text(
                          "Event from: " + appointmentDetails.from.toString(),
                          style: TextStyle(
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: <Widget>[
                        Text(
                          "Event to: " + appointmentDetails.to.toString(),
                          style: TextStyle(
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: <Widget>[
                        Text(
                          "Reminder Time: " +
                              appointmentDetails.reminderNumber.toString() +
                              " " +
                              appointmentDetails.dateType,
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

  onNotificationReceive(receiveNotification notification) {
    print('Notification Receive: ${notification.id}');
  }

  onNotificationClick(String? payload) {
    print('Payload: $payload');
    Navigator.push(context, MaterialPageRoute(builder: (context) {
      return CalendarApp();
    }));
  }

  @override
  void initState() {
    getData();
    super.initState();
    localNotifyManager.setOnNotificationReceive(onNotificationReceive);
    localNotifyManager.setOnNotificationClick(onNotificationClick);
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
                    width: 300,
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
                            autovalidateMode:
                                AutovalidateMode.onUserInteraction,
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
                          DateTimePicker(
                            controller: dateBeforeInput,
                            type: DateTimePickerType.dateTime,
                            dateMask: 'yyyy-MM-dd HH:mm:ss',
                            firstDate: DateTime.now(),
                            lastDate: DateTime(9999),
                            icon: const Icon(Icons.event),
                            dateLabelText: 'Starting Date and Time',
                          ),
                          DateTimePicker(
                            controller: dateAfterInput,
                            type: DateTimePickerType.dateTime,
                            dateMask: 'yyyy-MM-dd HH:mm:ss',
                            firstDate: DateTime.now(),
                            lastDate: DateTime(9999),
                            icon: const Icon(Icons.event),
                            dateLabelText: 'End Date and Time',
                            onChanged: (dateTime) => print(dateTime),
                            validator: (dateTime) {
                              DateTime valStart =
                                  DateTime.parse(dateBeforeInput.text);
                              DateTime valEnd =
                                  DateTime.parse(dateAfterInput.text);
                              if (valEnd.isBefore(valStart)) {
                                return 'Invalid Date and Time';
                              }
                              return null;
                            },
                          ),
                          Row(
                            children: <Widget>[
                              Expanded(
                                flex: 4,
                                child: TextFormField(
                                    controller: reminderNumber,
                                    keyboardType: TextInputType.number,
                                    enableSuggestions: false,
                                    autocorrect: false,
                                    autovalidateMode:
                                        AutovalidateMode.onUserInteraction,
                                    decoration: InputDecoration(
                                      icon: Icon(Icons.notification_add),
                                      labelText: "Reminder Time",
                                    ),
                                    validator: (reminderNumber) {
                                      if (reminderNumber != '') {
                                        int intReminderNumber = int.parse(
                                            reminderNumber.toString());
                                        if (dropdownValue == 'days') {
                                          if (intReminderNumber < 1 ||
                                              intReminderNumber > 28) {
                                            return 'Between 1 and 28 days';
                                          } else {
                                            return null;
                                          }
                                        } else if (dropdownValue == 'weeks') {
                                          if (intReminderNumber < 1 ||
                                              intReminderNumber > 4) {
                                            return 'Between 1 to 4 weeks';
                                          } else {
                                            return null;
                                          }
                                        } else if (dropdownValue == 'hours') {
                                          if (intReminderNumber < 1 ||
                                              intReminderNumber > 24) {
                                            return 'Between 1 to 23 hours';
                                          } else {
                                            return null;
                                          }
                                        }
                                      } else {
                                        return 'Please enter the field';
                                      }
                                    }),
                              ),
                              Expanded(
                                flex: 2,
                                child: DropdownButtonFormField(
                                    icon: const Icon(Icons.keyboard_arrow_down),
                                    value: dropdownValue,
                                    onChanged: ((value) {
                                      setState(() {
                                        dropdownValue = value.toString();
                                      });
                                    }),
                                    items: listItems.map((item) {
                                      return DropdownMenuItem(
                                          value: item, child: Text(item));
                                    }).toList()),
                              )
                            ],
                          )
                        ],
                      ),
                    ),
                  ),
                  actions: <Widget>[
                    FlatButton(
                      child: const Text("OK"),
                      onPressed: () => _formAddEventKey.currentState!.validate()
                          ? addData()
                          : null,
                    ),
                    FlatButton(
                      child: const Text("Cancel"),
                      onPressed: () {
                        clearData();
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
              ScheduleViewMonthHeaderDetails details) {
            final String monthName = _getMonthName(details.date.month);
            return Stack(
              children: [
                Image(
                    image:
                        ExactAssetImage('assets/images/' + monthName + '.png'),
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

          allowedViews: const <CalendarView>[
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
