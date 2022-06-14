import 'dart:convert';
import 'dart:typed_data';

import 'package:edriver/provider/user_profile.dart';
import 'package:edriver/screen/home.dart';
import 'package:edriver/screen/login_egat.dart';
import 'package:edriver/theme/app_style.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../api/api.dart';

class userDataScreeen extends StatefulWidget {
  const userDataScreeen({Key? key}) : super(key: key);

  @override
  State<userDataScreeen> createState() => _userDataScreeenState();
}

class _userDataScreeenState extends State<userDataScreeen> {
  //final prefs;
  var _wage_cost;
  var _ot_rate;
  var _hotel_rate;
  var _driver_pic;
  var _driver_name;
  var _driverID;
  var _driver_type;
  //late String _token;

  void initState() {
    super.initState();
    get_driverProfile();
    //print("set state $_wage_cost");
  }

  Future<String?> get_driverProfile() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _driver_name = prefs.getString("driver_name");
      _wage_cost = prefs.getString("wage_cost");
      _hotel_rate = prefs.getString("hotel_cost");
      _ot_rate = prefs.getString("ot_rate");
      _driver_pic = prefs.getString("driver_pic");
      _driver_type = prefs.getString("driverType");
    });
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: API().read_data("driverID"),
        builder: (context, snapshot) {
          if (snapshot.data.toString() != "null") {
            return user_profile();
          } else {
            return HomeScreen();
          }
          // return CircularProgressIndicator();
        });
  }

  Scaffold user_profile() {
    return Scaffold(
      appBar: AppBar(
        title: Text("ข้อมูล พขร."),
        actions: <Widget>[
          AppStyle().form_notify(context),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(30, 20, 20, 0),
          child: Container(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                // AppStyle().space_box(10),
                Center(child: driver_picture()),
                Text("ชื่อ  ", style: TextStyle(fontSize: 20)),
                Padding(
                  padding: const EdgeInsets.fromLTRB(40, 0, 0, 20),
                  child: Text("$_driver_name",
                      style: TextStyle(fontSize: 20, color: Colors.grey)),
                ),
                Text("อัตราค่าเบี้ยเลี้ยง", style: TextStyle(fontSize: 20)),
                Padding(
                  padding: const EdgeInsets.fromLTRB(40, 0, 0, 20),
                  child: Text("$_wage_cost บาท",
                      style: TextStyle(fontSize: 20, color: Colors.grey)),
                ),
                Text("อัตราค่าที่พัก", style: TextStyle(fontSize: 20)),
                Padding(
                  padding: const EdgeInsets.fromLTRB(40, 0, 0, 20),
                  child: Text("$_hotel_rate บาท",
                      style: TextStyle(fontSize: 20, color: Colors.grey)),
                ),
                Text("อัตรา OT ต่อชม.", style: TextStyle(fontSize: 20)),
                Padding(
                  padding: const EdgeInsets.fromLTRB(40, 0, 0, 20),
                  child: Text("$_ot_rate บาท",
                      style: TextStyle(fontSize: 20, color: Colors.grey)),
                ),
                AppStyle().space_box(20),
                Center(child: btn_logout(context)),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: AppStyle().butoom_bar(context, 0),
    );
  }

  Future<bool> get_driverID() async {
    final prefs = await SharedPreferences.getInstance();
    String? value = prefs.getString("driverID").toString();
    //AppStyle().toast_text(value);
    if (value != "null") {
      AppStyle().toast_text("-->true");
      return true;
    } else {
      return false;
    }
  }

  Widget driver_picture() {
    if (_driver_type == 'drv_e') {
      return Image.memory(base64.decode(_driver_pic.split(',').last),
          height: 150, width: 300);
    } else {
      return new Image.network("$_driver_pic", height: 150, width: 300);
    }
  }

  Widget btn_logout(context) {
    return Container(
      margin: const EdgeInsets.only(left: 20),
      child: ElevatedButton(
        onPressed: () {
          API().delete_data();
          Navigator.of(context).push(
            MaterialPageRoute(
              fullscreenDialog: false,
              builder: (context) => const Login_egat_screen(),
            ),
          );
        },
        child: const Text(
          "ออกจากระบบ",
          style: TextStyle(fontSize: 18.0, color: Colors.white),
        ),
        style: ElevatedButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(28.0),
          ),
          primary: Colors.redAccent,
          // minimumSize: size(150, 50),
        ),
      ),
    );
  }
}
