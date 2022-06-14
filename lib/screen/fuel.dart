import 'package:flutter/material.dart';

import '../api/api.dart';
import '../theme/app_style.dart';

class FuelScreen extends StatefulWidget {
  const FuelScreen({Key? key}) : super(key: key);

  @override
  State<FuelScreen> createState() => _FuelScreenState();
}

class _FuelScreenState extends State<FuelScreen> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: API().read_data("driver_name"),
      builder: (context, snapshot) {
        return Scaffold(
          appBar: AppBar(
            title: const Text("บันทึกข้อมูลการเติมน้ำมัน"),
            actions: <Widget>[
              AppStyle().form_notify(context),
            ],
          ),
          body: Center(
            child: Column(
              children: [
                AppStyle().space_box(50),
                Text(
                  'บันทึกข้อมูลการเติมน้ำมัน ',
                  style: TextStyle(fontSize: 24),
                ),
                Text(
                  'อยู่ระหว่างดำเนินการ ',
                  style: TextStyle(fontSize: 18, color: Colors.red),
                ),
              ],
            ),
          ),
          bottomNavigationBar: AppStyle().butoom_bar(context, 3),
        );
        return const CircularProgressIndicator(); // or some other widget
      },
    );
  }
}
