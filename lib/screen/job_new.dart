import 'package:edriver/theme/app_style.dart';
import 'package:flutter/material.dart';

class jobNewScreen extends StatelessWidget {
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
          color: Colors.green[100],
          child: Column(
            children: [
              AppStyle().space_box(10),
              row_detail("Job #", "650121-0001-J001"),
              row_detail("วันที่", " 22 - 25 ม.ค. 65 (4 วัน)"),
              row_detail("เวลา", " 10:00 น.  สถานที่  ท.103"),
              row_detail("จุดหมาย", " เขื่อนศรีฯ จ.กาญจนบุรี"),
              row_detail("ผู้โดยสาร", "คุณบุญญนิตย์ วงศ์รักษ์มิตร"),
              AppStyle().space_box(10),
              btn(),
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

  Widget btn() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          ElevatedButton.icon(
            icon: Icon(
              Icons.cancel_outlined,
              color: Colors.white,
              size: 24.0,
            ),
            label: Text(
              " ปฏิเสธงาน",
              style: TextStyle(fontSize: 16.0, color: Colors.white),
            ),
            onPressed: () {},
            style: ElevatedButton.styleFrom(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(28.0),
              ),
              primary: Colors.red,
              minimumSize: const Size(100, 50),
            ),
          ),
          ElevatedButton.icon(
            icon: Icon(
              Icons.check_box_outlined,
              color: Colors.white,
              size: 24.0,
            ),
            label: Text(
              " ยืนยันรับงาน",
              style: TextStyle(fontSize: 16.0, color: Colors.white),
            ),
            style: ElevatedButton.styleFrom(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(28.0),
              ),
              primary: Colors.green,
              minimumSize: const Size(100, 50),
            ),
            onPressed: () {},
          ),
        ],
      ),
    );
  }
}
