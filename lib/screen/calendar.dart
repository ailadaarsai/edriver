import 'package:edriver/api/api.dart';
import 'package:edriver/api/job_api.dart';
import 'package:edriver/api/flutter_neat_and_clean_calendar.dart';
import 'package:edriver/theme/app_style.dart';
import 'package:flutter/material.dart';
//import 'package:flutter_clean_calendar/flutter_clean_calendar.dart';

class calendarScreen extends StatefulWidget {
  calendarScreen({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  _calendarScreenState createState() => _calendarScreenState();
}

class _calendarScreenState extends State<calendarScreen> {
  final Map<DateTime, List<NeatCleanCalendarEvent>> _events = {};

  void initState() {
    super.initState();
  }

  get_job(data) {
    (data).forEach((element) {
      // print(element["region_type"]);
      DateTime _start_date = API().flutterDate(element["reserveDate"]);
      DateTime _end_date = API().flutterDate(element["end_date"]);
      Color region_color =
          (element["region_type"] == "b") ? Colors.blue : Colors.orangeAccent;
      if (_events.containsKey(_start_date)) {
        _events[_start_date]!.add(NeatCleanCalendarEvent(element["work_abbr"],
            job_no: element["job_no"],
            mobile: element["commander_mobile"],
            jobID: element["reserve_detail_jobID"],
            startTime: element["appointment_time"] + " น.",
            //  endTime: _end_date,
            description: element["job_date"],
            color: region_color));
      } else {
        _events[_start_date] = [
          NeatCleanCalendarEvent(element["work_abbr"],
              job_no: element["job_no"],
              mobile: element["commander_mobile"],
              jobID: element["reserve_detail_jobID"],
              startTime: element["appointment_time"] + " น.",
              // endTime: _end_date,
              description: element["job_date"],
              color: region_color)
        ];
      }
    });
  }

  build_calendar(context, data) {
    get_job(data);
    return Scaffold(
      appBar: AppBar(
        title: Text('ตารางงาน'),
      ),
      body: SafeArea(
        child: Calendar(
          startOnMonday: true,
          weekDays: ['จ.', 'อ.', 'พ.', 'พฤ.', 'ศ.', 'ส.', 'อา.'],
          events: _events,
          isExpandable: true,
          eventDoneColor: Colors.green,
          selectedColor: Colors.pink,
          todayColor: Colors.blue,
          eventColor: Colors.grey,
          locale: 'th_TH',
          todayButtonText: 'วันนี้',
          isExpanded: true,
          expandableDateFormat: 'EEEE, dd. MMMM yyyy',
          dayOfWeekStyle: TextStyle(
              color: Colors.black, fontWeight: FontWeight.w800, fontSize: 11),
        ),
      ),
      bottomNavigationBar: AppStyle().butoom_bar(context, 1),
    );
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: Job_api().driverCalendar(),
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.done:
              //print("-----------");
              return build_calendar(context, snapshot.data);

            default:
              // debugPrint("Snapshot " + snapshot.toString());
              return AppStyle()
                  .open_loading(); // also check your listWidget(snapshot) as it may return null.
          }
        });
  }

  void _handleNewDate(date) {
    //print('Date selected: $date');
  }
}
