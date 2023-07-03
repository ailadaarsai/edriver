import 'package:edriver/api/job_api.dart';
import 'package:flutter/material.dart';
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';
import 'package:qr_flutter/qr_flutter.dart';

import '../theme/app_style.dart';

class jobTabScreen extends StatefulWidget {
  final String jobID;
  const jobTabScreen(this.jobID, {Key? key}) : super(key: key);

  @override
  State<jobTabScreen> createState() => _jobTabScreenState();
}

class _jobTabScreenState extends State<jobTabScreen> {
  final ScrollController _controller = ScrollController();
  @override
  Widget build(BuildContext context) {
    //AppStyle().toast_text(widget.jobID);
    return FutureBuilder(
        future: Job_api().get_job_detail(widget.jobID),
        builder: (context, snapshot) {
          if (snapshot.data != null) {
            if (snapshot.data.toString() != "[]") {
              return job_detail(snapshot.data);
            } else {
              return AppStyle().no_job("ไม่พบข้อมูล");
            }
          } else {
            return AppStyle().open_loading();
          }
        });
  }

  Widget job_detail(dt_job) {
    final row = dt_job[0];
    if (row.length > 0) {
      Size screenSize = MediaQuery.of(context).size;
      return ListView.builder(
        controller: _controller,
        shrinkWrap: true,
        itemCount: 1,
        itemBuilder: (_, index) {
          final row = dt_job[index];
          return SizedBox(
            width: screenSize.width - 10,
            child: Card(
              child: InkWell(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    AppStyle().space_box(10),
                    AppStyle().row_detail("Job #", row["job_no"]),
                    AppStyle().row_detail("ทะเบียนรถ", row["full_plate_no"]),
                    AppStyle()
                        .row_detail("เลขทะเบียนภายใน", row["internal_no"]),
                    AppStyle().row_detail("วันที่",
                        "${row["job_date"]} (${row["cnt_date"]} วัน)"),
                    AppStyle().row_detail(
                        "เวลานัดหมาย", "${row["appointment_time"]} น."),
                    AppStyle().row_detail(
                        "จุดนัดหมาย",
                        "${row["appointment_name"]} / " +
                            AppStyle().convertNullToDash(
                                row["appointment_other"].toString())),
                    AppStyle().row_detail("จังหวัด",
                        "${row["province_name"]} / ${row["amphur_name"]}"),
                    AppStyle().row_detail("จุดหมาย", "${row["work_location"]}"),
                    AppStyle().row_detail(
                        "ผู้ควบคุมรถ", "${row["commander_fullname"]}"),
                    AppStyle().space_box(10),
                    btn(context, row["commander_mobile"]),
                    AppStyle().space_box(10),
                    QR_code(row),
                    AppStyle().space_box(20),
                  ],
                ),
              ),
            ),
          );
        },
      );
    } else {
      return AppStyle().no_job("ไม่พบข้อมูล");
    }
  }

  Widget QR_code(row) {
    try {
      final comm = row["commander_empID"];
      return Column(children: [
        AppStyle().text("แบบสำรวจความพึงพอใจ", 20, Colors.green),
        QrImage(
          data:
              "https://ecar.egat.co.th/Evaluation_satisfy_form/reserve_car/${row["enc_jobID"]}/${row["enc_empID"]}",
          version: QrVersions.auto,
          size: 150.0,
        ),
      ]);
    } catch (e) {
      return Container();
    }
  }

  Widget btn(BuildContext context, String phone_num) {
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
              _callNumber(phone_num);
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
