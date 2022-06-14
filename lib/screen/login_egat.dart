import 'package:edriver/screen/home.dart';
import 'package:edriver/screen/login_company.dart';
import 'package:edriver/screen/login_rent.dart';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';

import 'package:shared_preferences/shared_preferences.dart';
import '../theme/app_style.dart';
import '../api/api.dart';

class Login_egat_screen extends StatefulWidget {
  const Login_egat_screen({Key? key}) : super(key: key);

  @override
  _Login_egat_screenState createState() => _Login_egat_screenState();
}

class _Login_egat_screenState extends State<Login_egat_screen> {
  final _formKey = GlobalKey<FormState>();
  final FirebaseMessaging firebaseMessaging = FirebaseMessaging.instance;
  late String _token;
  @override
  initState() {
    super.initState();
    setState(() {
      getToken();
      //AppStyle().toast_text("set state  String ===>" + _token.toString());
    });
  }

  Future<String> getToken() async {
    _token = (await FirebaseMessaging.instance.getToken())!;
    return _token.toString();
  }

  // controller
  final empIDController = TextEditingController();

  @override
  build(BuildContext context) {
    return FutureBuilder(
      future: API().read_data("driverID"),
      builder: (context, snapshot) {
        if (snapshot.data.toString() != "null") {
          return HomeScreen();
        } else {
          return form_login_egat(context);
        }
        //   return CircularProgressIndicator(); // or some other widget
      },
    );
  }

  Widget form_login_egat(context) {
    // AppStyle().toast_text("form_login" + _token.toString());
    return Scaffold(
        backgroundColor: Colors.green[100],
        body: Container(
          child: Padding(
              padding: const EdgeInsets.all(25.0),
              child: Form(
                  key: _formKey,
                  child: SingleChildScrollView(
                      child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      AppStyle().space_box(80),
                      AppStyle().logo(),
                      AppStyle().space_box(10),
                      Center(child: AppStyle().text("เข้าสู่ระบบ", 30)),
                      AppStyle().space_box(10),
                      SizedBox(
                          child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisSize: MainAxisSize.max,
                              children: [
                            Center(
                              child: btn_egat(context),
                            ),
                            Center(
                              child: btn_comapany(context),
                            )
                          ])),
                      AppStyle().space_box(15),
                      AppStyle().text("รหัสพนักงาน", 20),
                      TextFormField(
                        controller: empIDController,
                        keyboardType: TextInputType.number,
                        maxLength: 6,
                        decoration: InputDecoration(
                          suffixIcon: IconButton(
                            onPressed: empIDController.clear,
                            icon: const Icon(Icons.clear),
                          ),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'กรุณากรอก รหัสพนักงาน';
                          } else if (value.length < 6) {
                            return 'กรุณากรอก รหัสพนักงานให้ครบ 6 หลัก';
                          }
                        },
                      ),
                      AppStyle().space_box(15),
                      SizedBox(
                        height: 50,
                        width: double.infinity,
                        child: ElevatedButton(
                          child: const Text("เข้าสู่ระบบ",
                              style: TextStyle(fontSize: 20)),
                          onPressed: () async {
                            try {
                              if (_formKey.currentState!.validate()) {
                                //  AppStyle().toast_text(_token);
                                final driverID = await API().saveUserProfileMem(
                                    'drv_e',
                                    empIDController.text,
                                    _token.toString());
                                //AppStyle().toast_text(driverID);
                                if (driverID.toString() != "null") {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            HomeScreen(driverID: driverID),
                                      ));
                                }
                                //login_company_screen();
                              }
                            } catch (e) {
                              // AppStyle().toast_text('ไม่สามารถเเชื่อต่อระบบได้ กรุณาลองอีกครั้ง');
                            }
                          },
                        ),
                      ),
                    ],
                  )))),
        ));
  }

  Future<bool> get_driverID() async {
    final prefs = await SharedPreferences.getInstance();
    String? value = prefs.getString("driverID").toString();
    //AppStyle().toast_text(value);
    if (value != "null") {
      return true;
    } else {
      return false;
    }
  }

  Widget btn_egat(context) {
    return ElevatedButton(
      onPressed: () {
        //next_function();
      },
      child: const Text(
        "พขร.กฟผ.",
        style: TextStyle(fontSize: 16.0, color: Colors.black),
      ),
      style: ElevatedButton.styleFrom(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(28.0),
        ),
        primary: Colors.amber,
        minimumSize: const Size(150, 50),
      ),
    );
  }

  Widget btn_comapany(context) {
    return Container(
      margin: const EdgeInsets.only(left: 20),
      child: OutlinedButton(
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => Login_company_screen(),
            ),
          );
          //  Navigator.pushNamed(context, "/Login_company_screen");
        },
        child: const Text(
          "พขร.บริษัท",
          style: TextStyle(fontSize: 16.0, color: Colors.black),
        ),
        style: OutlinedButton.styleFrom(
          side: const BorderSide(color: Colors.amber, width: 3),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(28.0),
          ),
          primary: Colors.amber,
          minimumSize: const Size(150, 50),
          backgroundColor: Colors.amber[50],
        ),
      ),
    );
  }
}
