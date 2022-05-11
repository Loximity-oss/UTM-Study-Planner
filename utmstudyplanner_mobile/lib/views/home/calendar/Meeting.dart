import 'dart:ui';
import 'package:hive/hive.dart';

part 'Meeting.g.dart';

@HiveType(typeId: 0)
class Meeting{

  /// Creates a meeting class with required details.
  Meeting(this.eventName, this.from, this.to, this.background, this.isAllDay, this.id);

  /// Event ID
  @HiveField(0)
  int id;

  /// Event name which is equivalent to subject property of [Appointment].
  @HiveField(1)
  String eventName;

  /// From which is equivalent to start time property of [Appointment].
  @HiveField(2)
  DateTime from;

  /// To which is equivalent to end time property of [Appointment].
  @HiveField(3)
  DateTime to;

  /// Background which is equivalent to color property of [Appointment].
  @HiveField(4)
  Color background;

  /// IsAllDay which is equivalent to isAllDay property of [Appointment].
  @HiveField(5)
  bool isAllDay;
}