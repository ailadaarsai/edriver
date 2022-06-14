import 'package:flutter/material.dart';

import '../api/api.dart';
import '../theme/app_style.dart';

class CalendarScreeen extends StatefulWidget {
  const CalendarScreeen({Key? key}) : super(key: key);

  @override
  State<CalendarScreeen> createState() => _CalendarScreeenState();
}

class _CalendarScreeenState extends State<CalendarScreeen> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: API().read_data("driver_name"),
      builder: (context, snapshot) {
        return Scaffold(
          appBar: AppBar(
            title: const Text("ปฏิทินการปฏิบัติงาน"),
            actions: <Widget>[
              AppStyle().form_notify(context),
            ],
          ),
          body: Center(
            child: Column(
              children: [
                AppStyle().space_box(50),
                Text(
                  'ปฏิทินการปฏิบัติงาน ',
                  style: TextStyle(fontSize: 24),
                ),
                Text(
                  'อยู่ระหว่างดำเนินการ ',
                  style: TextStyle(fontSize: 18, color: Colors.red),
                ),
              ],
            ),
          ),
          bottomNavigationBar: AppStyle().butoom_bar(context, 1),
        );

        return const CircularProgressIndicator(); // or some other widget
      },
    );
  }
}
