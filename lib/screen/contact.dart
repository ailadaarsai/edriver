import 'package:flutter/material.dart';
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';

import '../api/api.dart';
import 'package:edriver/theme/app_style.dart';

class ContactScreeen extends StatefulWidget {
  const ContactScreeen({Key? key}) : super(key: key);

  @override
  State<ContactScreeen> createState() => _ContactScreeenState();
}

class _ContactScreeenState extends State<ContactScreeen> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: API().read_data("driver_name"),
      builder: (context, snapshot) {
        return Scaffold(
          appBar: AppBar(
            title: const Text("ติดต่อสถานี"),
            actions: <Widget>[
              AppStyle().form_notify(context),
            ],
          ),
          body: Container(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(30, 20, 30, 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.max,
                children: [
                  Text("สถานีจัดรถ",
                      style: TextStyle(fontSize: 24, color: Colors.green)),
                  Divider(color: Colors.green, height: 15),
                  AppStyle().space_box(15),
                  row_station("สถานีรถเก๋ง", "024360586"),
                  row_station("สถานีรถตู้", "024360586"),
                  row_station("สถานีรถบัส", "024360586"),
                  AppStyle().space_box(30),
                  Text("ธุรการ",
                      style: TextStyle(fontSize: 24, color: Colors.green)),
                  Divider(color: Colors.green, height: 20),
                  AppStyle().space_box(15),
                  row_station("สถานีรถเก๋ง", "024360586"),
                  row_station("สถานีรถตู้", "024360586"),
                  row_station("สถานีรถบัส", "024360586"),
                ],
              ),
            ),
          ),
          bottomNavigationBar: AppStyle().butoom_bar(context, 4),
        );

        return const CircularProgressIndicator(); // or some other widget
      },
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
