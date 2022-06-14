import 'package:edriver/screen/job_detail.dart';
import 'package:edriver/theme/app_style.dart';
import 'package:flutter/material.dart';
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';
import 'package:path/path.dart';

class jobTabScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisSize: MainAxisSize.max,
      children: <Widget>[
        Container(
          margin: EdgeInsets.all(10),
          child: Column(
            children: [
              AppStyle().space_box(10),
              row_detail("Job #", "650121-0001-J001"),
              row_detail("วันที่", " 22 - 25 ม.ค. 65 (4 วัน)"),
              row_detail("เวลา", " 10:00 น.  สถานที่  ท.103"),
              row_detail("จุดหมาย", " เขื่อนศรีฯ จ.กาญจนบุรี"),
              row_detail("ผู้ควบคุมรถ", "คุณบุญญนิตย์ วงศ์รักษ์มิตร"),
              AppStyle().space_box(10),
              btn(context),
              AppStyle().space_box(15),
            ],
          ),
        ),
      ],
    );
  }

  Widget row_detail(String left, String right) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
      child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
        Text(left, style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        Text(right, style: TextStyle(fontSize: 16))
      ]),
    );
  }

  Widget btn(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
        child: Row(mainAxisAlignment: MainAxisAlignment.end, children: [
          ElevatedButton.icon(
            icon: Icon(
              Icons.phone,
              color: Colors.white,
              size: 24.0,
            ),
            label: Text(
              " โทร.หาผู้ควบคุมรถ",
              style: TextStyle(fontSize: 16.0, color: Colors.white),
            ),
            onPressed: () {
              _callNumber("0999999999");
            },
            style: ElevatedButton.styleFrom(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(28.0),
              ),
              primary: Colors.blue,
              minimumSize: const Size(100, 40),
            ),
          )
        ]));
  }

  _callNumber(String phone_num) async {
    // const number = '08592119XXXX'; //set the number here
    bool? res = await FlutterPhoneDirectCaller.callNumber(phone_num);
  }
}
