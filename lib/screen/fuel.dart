import 'package:edriver/api/share_pref.dart';
import 'package:flutter/material.dart';
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
      future: Share_pref().read_data("driver_name"),
      builder: (context, snapshot) {
        return Scaffold(
          appBar: AppBar(
            title: const Text("บันทึกข้อมูลการเติมน้ำมัน"),
            actions: <Widget>[
              AppStyle().form_notify(context),
            ],
          ),
          body: SingleChildScrollView(
            child: Center(
              child: Column(
                children: [
                  AppStyle().space_box(50),
                  AppStyle()
                      .text("บันทึกข้อมูลการเติมน้ำมัน", 24, Colors.green),
                  AppStyle().phase_2(),
                ],
              ),
            ),
          ),
          bottomNavigationBar: AppStyle().butoom_bar(context, 3),
        );
        return AppStyle().open_loading(); // or some other widget
      },
    );
  }
}
