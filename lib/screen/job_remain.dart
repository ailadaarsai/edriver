import 'package:edriver/api/job_api.dart';
import 'package:edriver/screen/close_job_menu.dart';
import 'package:edriver/theme/app_style.dart';
import 'package:flutter/material.dart';

import '../api/api.dart';

class jobRemainScreen extends StatefulWidget {
  const jobRemainScreen({Key? key}) : super(key: key);

  @override
  State<jobRemainScreen> createState() => _jobRemainScreenState();
}

class _jobRemainScreenState extends State<jobRemainScreen> {
  final ScrollController _controller = ScrollController();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: Job_api().job_remain(),
        builder: (context, snapshot) {
          if (snapshot.data != null) {
            List? dt = snapshot.data;
            if (dt!.length > 0) {
              return SingleChildScrollView(
                physics: ScrollPhysics(),
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      tab_job(snapshot.data),
                    ]),
              );
            } else {
              return AppStyle().no_job("ไม่มีงานที่รอปิดงาน");
            }
          } else {
            return AppStyle().no_job("ไม่มีงานที่รอปิดงาน");
          }
        });
  }

  Widget tab_job(dtJob) {
    final count = dtJob.length;

    Size screenSize = MediaQuery.of(context).size;
    return ListView.builder(
      controller: _controller,
      shrinkWrap: true,
      itemCount: count,
      itemBuilder: (_, index) {
        final row = dtJob[index];
        return SizedBox(
          width: screenSize.width - 10,
          child: Card(
            color: Colors.pink[100],
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
                    AppStyle().row_detail("วันที่",
                        "${row["job_date"]} (${row["cnt_date"]} วัน)"),
                    AppStyle().row_detail("จังหวัด",
                        "${row["province_name"]} / ${row["amphur_name"]}"),
                    AppStyle().row_detail("ทะเบียนรถ", row["full_plate_no"]),
                    AppStyle()
                        .row_detail("เลขทะเบียนภายใน", row["internal_no"]),
                    AppStyle().row_detail("จุดหมาย", "${row["work_location"]}"),
                    AppStyle()
                        .row_detail("ผู้โดยสาร", row["commander_fullname"]),
                    AppStyle().space_box(10),
                    /*   btn(row["reserve_detail_jobID"], row["job_no"],
                        row["commander_mobile"]),*/
                    AppStyle().space_box(10),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
