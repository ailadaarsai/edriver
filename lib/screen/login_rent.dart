import 'package:edriver/screen/home.dart';
import 'package:edriver/screen/login_egat.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/widgets.dart';

import '../api/api.dart';
import '../theme/app_style.dart';

class Login_rent_screen extends StatefulWidget {
  const Login_rent_screen({Key? key}) : super(key: key);

  @override
  State<Login_rent_screen> createState() => _Login_rent_screen();
}

class _Login_rent_screen extends State<Login_rent_screen> {
  final formKey = GlobalKey<FormState>();

  final idcard_controller = TextEditingController();
  var _token;
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

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: API().read_data("driverID"),
        builder: (context, snapshot) {
          if (snapshot.data.toString() != "null") {
            return HomeScreen();
          } else {
            return form_login_rent(context);
          }
          // return CircularProgressIndicator();R
        });
  }
   Scaffold form_login_rent(context) {
    return Scaffold(
        backgroundColor: Colors.green[100],
        body: Container(
          child: Padding(
              padding: const EdgeInsets.all(25.0),
              child: Form(
                  key: formKey,
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
                            Padding(
                              padding: const EdgeInsets.all(10),
                              child: btn_company(context),
                            ),
                          ])),
                      AppStyle().space_box(15),
                      AppStyle().text("รหัสบัตรประชาชน 13 หลัก", 20),
                      TextFormField(
                          maxLength: 13,
                          controller: idcard_controller,
                          keyboardType: TextInputType.number,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'กรุณากรอก รหัสบัตรประชาชน 13 หลัก';
                            } else if (value.length < 13) {
                              return 'กรุณากรอก รหัสบัตรประชาชนให้ครบ 13 หลัก';
                            }
                            return null;
                          }),
                      const SizedBox(
                        height: 15,
                      ),
                      SizedBox(
                        height: 50,
                        width: double.infinity,
                        child: ElevatedButton(
                          child: const Text("เข้าสู่ระบบ",
                              style: TextStyle(fontSize: 20)),
                          onPressed: () {
                            try {
                              //AppStyle().toast_text(_token);
                              if (formKey.currentState!.validate()) {
                                final driverID = API().saveUserProfileMem(
                                    'drv_r',
                                    idcard_controller.text,
                                    _token.toString());
                                if (driverID.toString() != "null") {
                                  Navigator.of(context).push(
                                    MaterialPageRoute(
                                      fullscreenDialog: false,
                                      builder: (context) => HomeScreen(
                                        driverID: driverID,
                                      ),
                                    ),
                                  );
                                } else {
                                  AppStyle().close_loading(context);
                                }
                              }
                            } catch (e) {
                              // AppStyle().toast_text("ไม่สามารถเชื่อมต่อได้ กรุณาลองอีกครั้ง");
                            }
                          },
                        ),
                      )
                    ],
                  )))),
        ));
  }
  Widget btn_company(context) {
  return ElevatedButton(
    onPressed: () {
      //next_function();
    },
    child: const Text(
      "พขร.บริษัท",
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

Widget btn_egat(context) {
  return Container(
    margin: const EdgeInsets.only(left: 20),
    child: OutlinedButton(
      onPressed: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            fullscreenDialog: false,
            builder: (context) => const Login_egat_screen(),
          ),
        );
      },
      child: const Text(
        "พขร.กฟผ.",
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