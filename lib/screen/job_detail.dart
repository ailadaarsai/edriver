import 'package:edriver/screen/cost_tab.dart';
import 'package:edriver/screen/job_tab.dart';
import 'package:edriver/screen/summary_tab.dart';
import 'package:edriver/screen/time_tab.dart';
import 'package:flutter/material.dart';
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';
import '../api/api.dart';
import 'package:edriver/theme/app_style.dart';

class jobDetailScreen extends StatefulWidget {
  const jobDetailScreen({Key? key}) : super(key: key);

  @override
  State<jobDetailScreen> createState() => _jobDetailScreen();
}

class _jobDetailScreen extends State<jobDetailScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: DefaultTabController(
        // ใช้งาน DefaultTabController
        length: 4, // กำหนดจำนวน tab
        child: Scaffold(
          appBar: AppBar(
            bottom: const TabBar(
              indicatorColor: Colors.white,
              labelColor: Colors.white,
              // ส่วนของ tab
              tabs: [
                Tab(icon: Icon(Icons.feed), text: 'ข้อมูลใบงาน'),
                Tab(icon: Icon(Icons.alarm), text: 'บันทึกเวลา'),
                Tab(icon: Icon(Icons.money_off_rounded), text: 'ค่าใช้จ่าย'),
                Tab(icon: Icon(Icons.summarize), text: 'สรุปข้อมูล'),
              ],
            ),
            title: Text('ใบงานเลขที่ 650121-0001-J001'),
            actions: <Widget>[AppStyle().form_notify(context)],
          ),
          body: TabBarView(
            children: <Widget>[
              jobTabScreen(),
              timeTabScreen(),
              costTabSceereen(),
              summaryTabScreeen()
            ],
          ),
        ),
      ),
      bottomNavigationBar: AppStyle().butoom_bar(context, 2),
    );
  }

  _callNumber(String phone_num) async {
    // const number = '08592119XXXX'; //set the number here
    bool? res = await FlutterPhoneDirectCaller.callNumber(phone_num);
  }

  Widget row_station(String staion_name, String phone_num) {
    return Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
      Text(staion_name, style: TextStyle(fontSize: 20)),
      btn_tel(phone_num)
    ]);
  }

  Widget btn_tel(String phone_num) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        ElevatedButton(
          onPressed: () {
            _callNumber(phone_num);
          },
          child: const Text(
            "โทร.",
            style: TextStyle(fontSize: 16.0, color: Colors.white),
          ),
          style: ElevatedButton.styleFrom(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(28.0),
            ),
            primary: Colors.green,
            minimumSize: const Size(80, 30),
          ),
        ),
      ],
    );
  }
}
