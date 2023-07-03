import 'package:edriver/api/job_api.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';

import '../api/api.dart';
import '../theme/app_style.dart';

class jobDetailScreen extends StatefulWidget {
  final String jobID;
  final String job_no;
  final String commander_tel;
  const jobDetailScreen(this.jobID, this.job_no, this.commander_tel, {Key? key})
      : super(key: key);

  @override
  State<jobDetailScreen> createState() => _jobDetailScreenState();
}

class _jobDetailScreenState extends State<jobDetailScreen> {
  final ScrollController _controller = ScrollController();
  late String jobID;

  Widget build(BuildContext context) {
    return FutureBuilder(
        future: Job_api().get_job_detail(widget.jobID),
        builder: (context, snapshot) {
          if (snapshot.data != null) {
            if (snapshot.data.toString() != "[]") {
              jobID = widget.jobID;
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

    Size screenSize = MediaQuery.of(context).size;
    return Scaffold(
        appBar: AppBar(
          title: Text("ข้อมูลใบงาน : " + widget.job_no.toString()),
        ),
        body: Padding(
          padding: const EdgeInsets.fromLTRB(15, 15, 15, 15),
          child: ListView.builder(
            controller: _controller,
            shrinkWrap: true,
            itemCount: 1,
            itemBuilder: (_, index) {
              final row = dt_job[index];
              return SizedBox(
                width: screenSize.width - 10,
                child: Card(
                  //  color: Colors.lightGreen[100],
                  child: InkWell(
                    //  onTap: () {},
                    child: Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Column(
                        //mainAxisAlignment: MainAxisAlignment.spaceEvenly,

                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          AppStyle().space_box(10),
                          AppStyle().row_detail("Job #", row["job_no"], 16),
                          AppStyle().row_detail(
                              "ทะเบียนรถ", row["full_plate_no"], 16),
                          AppStyle().row_detail(
                              "เลขทะเบียนภายใน", row["internal_no"], 16),
                          AppStyle().row_detail(
                              "วันที่",
                              "${row["job_date"]} (${row["cnt_date"]} วัน)",
                              16),
                          AppStyle().row_detail("เวลานัดหมาย",
                              "${row["appointment_time"]} น.", 16),
                          AppStyle().row_detail(
                              "จุดนัดหมาย",
                              "${row["appointment_name"]} / " +
                                  AppStyle().convertNullToDash(
                                      row["appointment_other"].toString()),
                              16),
                          AppStyle().row_detail(
                              "จังหวัด",
                              "${row["province_name"]} / ${row["amphur_name"]}",
                              16),
                          AppStyle().row_detail(
                              "จุดหมาย", "${row["work_location"]}", 16),
                          AppStyle().row_detail("ผู้ควบคุมรถ",
                              "${row["commander_fullname"]}", 16),
                          AppStyle().space_box(10),
                          //   AppStyle().btn(context, row["commander_mobile"]),
                          AppStyle().space_box(20),
                          AppStyle()
                              .text("แบบสำรวจความพึงพอใจ", 20, Colors.green),
                          AppStyle().space_box(10),
                          AppStyle().QR_code(
                              "https://ecar.egat.co.th/Evaluation_satisfy_form/reserve_car/${row["enc_jobID"]}"),
                          AppStyle().space_box(20),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
        floatingActionButton: AppStyle()
            .getBtnMenu(jobID, widget.job_no, widget.commander_tel, context),
        bottomNavigationBar: AppStyle().butoom_bar(context, 2));
  }
}
