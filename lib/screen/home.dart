import 'dart:developer';

import 'package:edriver/screen/job_new.dart';
import 'package:edriver/screen/job_remain.dart';
import 'package:edriver/screen/job_today.dart';
import 'package:edriver/screen/login_egat.dart';
import 'package:edriver/theme/app_style.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_messaging_platform_interface/firebase_messaging_platform_interface.dart';

import '../api/api.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({
    Key? key,
    driverID,
  }) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  var driver_name;

  static const IconData local_gas_station =
      IconData(0xe394, fontFamily: 'MaterialIcons');

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: API().read_data("driverID"),
        builder: (context, snapshot) {
          //AppStyle().toast_text(snapshot.data.toString());
          if (snapshot.data.toString() != "null") {
            return homeTab();
          } else {
            return Login_egat_screen();
          }
          //  return CircularProgressIndicator();
        });

    // or some other widget
  }

  Scaffold homeTab() {
    return Scaffold(
      body: DefaultTabController(
        // ใช้งาน DefaultTabController
        length: 3, // กำหนดจำนวน tab
        child: Scaffold(
          appBar: AppBar(
            bottom: const TabBar(
              // ส่วนของ tab
              tabs: [
                Tab(icon: Icon(Icons.feed), text: 'งานใหม่'),
                Tab(icon: Icon(Icons.alarm), text: 'งานวันนี้'),
                Tab(icon: Icon(Icons.thumb_down), text: 'งานคงค้าง'),
              ],
            ),
            title: Text('หน้าแรก'),
            actions: <Widget>[AppStyle().form_notify(context)],
          ),
          body: TabBarView(
            children: <Widget>[
              // Text(driverID),
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

  Future<bool> get_driverID() async {
    final prefs = await SharedPreferences.getInstance();
    String? value = prefs.getString("driverID").toString();
    if (value != "null") {
      return true;
    } else {
      return false;
    }
  }
}
