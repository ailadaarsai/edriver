import 'package:edriver/screen/job_detail.dart';
import 'package:edriver/theme/app_style.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:flutter_map/flutter_map.dart';

class timeTabScreen extends StatelessWidget {
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
              Text(
                'อยู่ระหว่างดำเนินการ ',
                style: TextStyle(fontSize: 18, color: Colors.red),
              ),
              row_detail("Job #", "650121-0001-J001"),
              row_detail("วันที่", " 22 ม.ค. 65"),
              MAp(context),
              AppStyle().space_box(15),
              btn_start(),
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

  Widget MAp(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;
    return Padding(
      padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
      child: new Image.network(
          "https://storage.googleapis.com/support-forums-api/attachment/thread-70206669-3978723013709606432.jpg",
          height: 300,
          width: screenSize.width),
    );
  }

  Widget btn_start() {
    return Center(
      child: Container(
        margin: const EdgeInsets.only(left: 20),
        child: ElevatedButton(
          onPressed: () {},
          child: const Text(
            "เริ่มเดินทาง",
            style: TextStyle(fontSize: 28.0, color: Colors.white),
          ),
          style: ElevatedButton.styleFrom(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(28.0),
            ),
            primary: Colors.blue,
            shadowColor: Colors.grey,
          ),
        ),
      ),
    );
  }
}
