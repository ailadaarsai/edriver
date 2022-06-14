import 'package:edriver/screen/job_detail.dart';
import 'package:edriver/theme/app_style.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart';

class summaryTabScreeen extends StatelessWidget {
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
              Text(
                'อยู่ระหว่างดำเนินการ ',
                style: TextStyle(fontSize: 18, color: Colors.red),
              ),
              AppStyle().space_box(10),
              Text("ข้อมูลการเดินทาง",
                  style: TextStyle(fontSize: 24, color: Colors.green)),
              row_detail("23 ม.ค. 65", "08:00-18:00 น."),
              row_detail("22 ม.ค. 65", "07:00-18:00 น."),
              Text("ข้อมูลค่าใช้จ่าย",
                  style: TextStyle(fontSize: 24, color: Colors.green)),
              row_detail("ค่าผ่านทาง", "100 บาท"),
              AppStyle().space_box(10),
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
              Icons.handshake,
              color: Colors.white,
              size: 24.0,
            ),
            label: Text(
              " ดำเนินการ",
              style: TextStyle(fontSize: 16.0, color: Colors.white),
            ),
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  fullscreenDialog: false,
                  builder: (context) => jobDetailScreen(),
                ),
              );
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
}
