import 'package:edriver/api/share_pref.dart';

import 'package:edriver/screen/job_new.dart';
import 'package:edriver/screen/job_remain.dart';
import 'package:edriver/screen/job_today.dart';
import 'package:edriver/screen/login_egat.dart';
import 'package:edriver/theme/app_style.dart';

import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({
    Key? key,
  }) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: Share_pref().read_data("driverID"),
        builder: (context, snapshot) {
          if (snapshot.data.toString() != "null") {
            // AppStyle().toast_text(snapshot.data.toString());
            return homeTab();
          } else {
            return Login_egat_screen();
          }
          return AppStyle().open_loading();
        });

    // or some other widget
  }

  Scaffold homeTab() {
    return Scaffold(
      body: DefaultTabController(
        //initialIndex: 1,
        length: 3, // กำหนดจำนวน tab
        child: Scaffold(
          appBar: AppBar(
            bottom: const TabBar(
              // physics: NeverScrollableScrollPhysics(),
              tabs: [
                Tab(icon: Icon(Icons.feed), text: 'งานใหม่'),
                Tab(icon: Icon(Icons.alarm), text: 'งานวันนี้'),
                Tab(icon: Icon(Icons.thumb_down), text: 'รอปิดงาน'),
              ],
            ),
            title: Text('หน้าแรก'),
            actions: <Widget>[
              AppStyle().form_notify(context),
            ],
          ),
          body: TabBarView(
            children: <Widget>[
              jobNewScreen(),
              jobTodayScreen(),
              jobRemainScreen(),
            ],
          ),
        ),
      ),
      bottomNavigationBar: AppStyle().butoom_bar(context, 2),
    );
  }
}
