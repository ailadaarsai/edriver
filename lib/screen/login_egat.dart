import 'package:edriver/api/driver_api.dart';
import 'package:edriver/api/share_pref.dart';
import 'package:edriver/screen/home.dart';
import 'package:edriver/screen/login_company.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';

import '../theme/app_style.dart';

class Login_egat_screen extends StatefulWidget {
  const Login_egat_screen({Key? key}) : super(key: key);

  @override
  _Login_egat_screenState createState() => _Login_egat_screenState();
}

class _Login_egat_screenState extends State<Login_egat_screen> {
  final _formKey = GlobalKey<FormState>();
  final FirebaseMessaging firebaseMessaging = FirebaseMessaging.instance;
  late String _token;

  initState() {
    super.initState();

    setState(() {
      getToken();
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
      future: Share_pref().read_data("driverID"),
      builder: (context, snapshot) {
        //AppStyle().toast_text(snapshoasyncata.toString());
          if (snapshot.data.toString() != "null") {
            return HomeScreen();
          } else {
            return form_login_egat(context);
          }
          return AppStyle().open_loading(); // or some other widget

      },
    );
  }

  Widget form_login_egat(context) {
    // AppStyle().toast_text("form_login" + _token.toString());
  
    return Scaffold(
        backgroundColor: Colors.green[100],
        body: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Form(
                  key: _formKey,
                  child: SingleChildScrollView(
                      child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    //  crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      AppStyle().space_box(40),
                      AppStyle().logo(),
                      AppStyle().space_box(10),
                      Center(
                          child:
                              AppStyle().text("เข้าสู่ระบบ", 30, Colors.black)),
                      AppStyle().space_box(10),
                      Center(
                        child: SizedBox(
                            child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
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
                      ),
                      AppStyle().space_box(15),
                      AppStyle().text("รหัสพนักงาน", 20, Colors.black),
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
                     
                      SizedBox(
                        height: 50,
                        width: double.infinity,
                        child: ElevatedButton(
                          child: const Text("เข้าสู่ระบบ",
                              style: TextStyle(fontSize: 20)),
                          onPressed: () async {
                            try {
                                if (_formKey.currentState!.validate()) {
                                  //AppStyle().toast_text(_token);
                                  final driverID = await driver_api()
                                      .saveUserProfileMem(
                                          'drv_e',
                                          empIDController.text,
                                          _token.toString());

                                  if (driverID.toString() != "null") {
                                    Navigator.of(context)
                                        .popUntil((route) => route.isFirst);
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => HomeScreen(),
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

  Widget btn_egat(context) {
    return Center(
      child: ElevatedButton(
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
          minimumSize: const Size(120, 50),
        ),
      ),
    );
  }

  Widget btn_comapany(context) {
    return Center(
      child: Container(
        margin: const EdgeInsets.only(left: 10),
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
            minimumSize: const Size(120, 50),
            backgroundColor: Colors.amber[50],
          ),
        ),
      ),
    );
  }
}
