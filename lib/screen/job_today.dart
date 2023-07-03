import 'package:edriver/api/job_api.dart';
import 'package:edriver/screen/close_job_menu.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';

import 'package:edriver/theme/app_style.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart';

import '../api/api.dart';

class jobTodayScreen extends StatefulWidget {
  const jobTodayScreen({Key? key}) : super(key: key);

  @override
  State<jobTodayScreen> createState() => _jobTodayScreenState();
}

class _jobTodayScreenState extends State<jobTodayScreen> {
  late List<dynamic> job_today;
  final ScrollController _controller = ScrollController();
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: Job_api().get_today_job(),
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.done:
              if (snapshot.data != null) {
                List? dt = snapshot.data;

                if (dt!.length > 0) {
                  return SingleChildScrollView(
                      child: Container(
                    child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [listview_job_today(context, snapshot.data)]),
                  ));
                } else {
                  return AppStyle().no_job("ไม่มีงานวันนี้");
                }
              } else {
                return AppStyle().no_job("ไม่มีงานวันนี้");
              }
              break;
            default:
              return AppStyle()
                  .open_loading(); // also check your listWidget(snapshot) as it may return null.
          }
        });
  }

  Widget listview_job_today(BuildContext context, job_today) {
    var count = job_today.length;
    Size screenSize = MediaQuery.of(context).size;
    return ListView.builder(
      controller: _controller,
      shrinkWrap: true,
      itemCount: count,
      itemBuilder: (_, index) {
        final row = job_today[index];
        return SizedBox(
          width: screenSize.width - 10,
          child: Card(
            color: Colors.lightBlue[100],
            child: InkWell(
              onTap: () {
                AppStyle().link_to(
                    closeJobMenuScreen(row["reserve_detail_jobID"],
                        row["job_no"], row["commander_mobile"]),
                    context);
              },
              child: Padding(
                padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                child: Column(
                  //mainAxisAlignment: MainAxisAlignment.spaceEvenly,
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
                    AppStyle().space_box(5),
                    /* btn(context, row["reserve_detail_jobID"], row["job_no"],
                        row["commander_mobile"]),*/
                    AppStyle().space_box(5),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget btn(BuildContext context, String reserve_detail_jobID, String job_no,
      commander_tel) {
    // AppStyle().toast_text(commander_tel);
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
            onPressed: () async {
              try {
                AppStyle().link_to(
                    closeJobMenuScreen(
                        reserve_detail_jobID, job_no, commander_tel),
                    context);
              } catch (e) {}
            },
            style: ElevatedButton.styleFrom(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(28.0),
              ),
              primary: Colors.blue,
              minimumSize: const Size(100, 35),
            ),
          )
        ]));
  }
}
