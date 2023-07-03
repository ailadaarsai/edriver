import 'package:flutter/material.dart';

enum MultiDaySegement {
  first,
  middle,
  last,
}

class NeatCleanCalendarEvent {
  String summary;
  String description;
  String location;
  String jobID;
  String job_no;
  String mobile;
  String startTime;
  Color? color;
  bool isAllDay;
  bool isMultiDay;
  MultiDaySegement? multiDaySegement;
  bool isDone;
  Map<String, dynamic>? metadata;

  NeatCleanCalendarEvent(this.summary,
      {this.description = '',
      this.location = '',
      required this.jobID,
      required this.job_no,
      required this.mobile,
      this.startTime = "",
      this.color = Colors.blue,
      this.isAllDay = false,
      this.isMultiDay = false,
      this.isDone = false,
      multiDaySegement,
      this.metadata});
}
