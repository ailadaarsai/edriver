import 'package:edriver/api/api.dart';
import 'package:edriver/api/job_api.dart';
import 'package:edriver/screen/check_up.dart';
import 'package:edriver/screen/mile_record.dart';
import 'package:edriver/screen/cost_record.dart';
import 'package:edriver/screen/summary_tab.dart';
import 'package:edriver/screen/time_record.dart';
import 'package:edriver/theme/element_widget.dart';
import 'package:flutter/material.dart';
import 'package:edriver/theme/app_style.dart';

class closeJobMenuScreen extends StatefulWidget {
  final String jobID;
  final String job_no;
  final String commander_tel;
  const closeJobMenuScreen(this.jobID, this.job_no, this.commander_tel,
      {Key? key})
      : super(key: key);

  @override
  State<closeJobMenuScreen> createState() => _closeJobMenuScreenState();
}

class _closeJobMenuScreenState extends State<closeJobMenuScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Map>(
        future: Job_api().get_job_detail_close(widget.jobID),
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.done:
              return job_tab(snapshot.data);

            default:
              // debugPrint("Snapshot " + snapshot.toString());
              return AppStyle()
                  .open_loading(); // also check your listWidget(snapshot) as it may return null.
          }
        });
  }

  card(header_text, element) {
    return Container(
        decoration: const BoxDecoration(
          //color: Colors.black12,
          borderRadius: BorderRadius.all(Radius.circular(15)),
        ),
        padding: const EdgeInsets.all(10),
        child: Column(children: [
          Row(
            children: [
              Text(
                header_text,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.teal,
                ),
              ),
            ],
          ),
          SizedBox(
            width: 16,
          ),
          element_widget().underline(
            Colors.black,
          ),
          element
        ]));
  }

  Widget job_tab(dr) {
    // print(widget.jobID);
   // print(dr);
    return Scaffold(
      appBar: AppBar(
        //title: Text("Job # "),
        title: Text("Job # " + widget.job_no),
        actions: <Widget>[
          AppStyle().form_notify(context),
        ],
      ),
      body: SingleChildScrollView(
        child: Container(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                child: Container(
                  margin: const EdgeInsets.all(10),
                  child: frm_save_job(dr),
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: AppStyle().getBtnMenu(
          widget.jobID, widget.job_no, widget.commander_tel, context),
      bottomNavigationBar: AppStyle().butoom_bar(context, 2),
    );
  }

  frm_save_job(dr) {
    var driver_action = dr["driver_action"].toString();
    var status = Job_api().get_job_status(driver_action);

    if (status["is_edit"] == true) {
      return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        element_widget().row_tmp_2(card(" 1. ตรวจสภาพรถ", step1(widget.jobID)),
            card(" 2. บันทึกเลขไมล์", step2(dr))),
        AppStyle().space_box(15),
        Divider(color: Colors.blue, height: 15),
        AppStyle().space_box(15),
        element_widget().row_tmp_2(card(" 3. บันทึกเวลาทำงาน", step3()),
            card(" 4. บันทึกค่าใช้จ่าย", step4())),
        element_widget().row_tmp_2(
            Container(),
            AppStyle().text("* หากไม่บันทึกจะไม่สามารถเบิกค่าใช้จ่ายได้", 15,
                Colors.deepOrange),
            [3, 7]),
        AppStyle().space_box(15),
        Divider(color: Colors.blue, height: 15),
        AppStyle().space_box(15),
        AppStyle().textLabel(
            "ขั้นตอนที่ 5 : ตรวจสอบข้อมูล และส่งรายงานการทำงาน",
            Colors.teal,
            16),
        AppStyle().space_box(15),
        Center(child: step5()),
        AppStyle().space_box(15),
        Divider(color: Colors.grey, height: 15),
      ]);
    } else {
      return Container(
        child: Center(
          child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
            AppStyle().space_box(40),
            AppStyle().textLabel(
              "ไม่สามารถบันทึก/ แก้ไขข้อมูลได้  !!!",
              Colors.red,
              24,
            ),
            AppStyle().space_box(20),
            AppStyle()
                .text("เพราะ : ${status["status_name"]}  ", 18, Colors.red)
          ]),
        ),
      );
    }
  }

  Widget step2(dr) {
    final mileBegin =
        (dr["mile_begin"].toString() != 'null') ? dr["mile_begin"] : "-";
    final mileEnd =
        (dr["mile_end"].toString() != 'null') ? dr["mile_end"] : "-";
    final status = _get_status_step2(mileBegin, mileEnd);
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            TextButton.icon(
                style: AppStyle().buttonStyle(),
                onPressed: () {
                  go_mile_record("b");
                },
                icon: Icon(Icons.onetwothree_rounded),
                label: Text("เลขไมล์เริ่มต้น")),
            Visibility(
                visible: (status == "0") ? false : true,
                child: TextButton.icon(
                  style: AppStyle().buttonStyle(),
                  onPressed: () {
                    go_mile_record("a");
                  },
                  icon: Icon(Icons.onetwothree_rounded),
                  label: Text("เลขไมล์สิ้นสุด"),
                )),
          ],
        ),
      ],
    );
  }

  Widget step3() {
    //  print("step3 " + commandet_tel);
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            TextButton.icon(
                style: AppStyle().buttonStyle(),
                onPressed: () {
                  go_time_record();
                },
                icon: Icon(Icons.timer),
                label: Text("บันทึกเวลาทำงาน")),
          ],
        ),
      ],
    );
  }

  Widget step4() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Column(
          children: [
            TextButton.icon(
                style: AppStyle().buttonStyle(),
                onPressed: () {
                  go_cost_record();
                },
                icon: Icon(Icons.attach_money),
                label: Text("บันทึกค่าใช้จ่าย")),
          ],
        ),
      ],
    );
  }

  Widget step5() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Column(
          children: [
            TextButton.icon(
                style: AppStyle().buttonStyle(),
                onPressed: () {
                  go_to_summary();
                },
                icon: Icon(Icons.details),
                label: Text("ตรวจสอบข้อมูล/ส่งรายงานการทำงาน")),
          ],
        ),
      ],
    );
  }

  Widget step1(jobID) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          TextButton.icon(
              style: AppStyle().buttonStyle(),
              onPressed: () {
                go_checkUp("b");
              },
              icon: Icon(Icons.car_repair_outlined),
              label: Text("ก่อนเดินทาง")),
          TextButton.icon(
              style: AppStyle().buttonStyle(),
              onPressed: () {
                go_checkUp("a");
              },
              icon: Icon(Icons.car_repair_outlined),
              label: Text("หลังเดินทาง")),
        ],
      ),
    );
  }

  String _get_status_step2(String mile_begin, String mile_end) {
    if (mile_begin != '-' && mile_end != "-") {
      //Complete
      return "2";
    } else if (mile_begin != '-' || mile_end != "-") {
      //ongoing
      return "1";
    } else {
      return "0";
    }
  }

  void go_checkUp(time) {
    //AppStyle().toast_text("GO " + jobID);
    AppStyle().link_to(
        checkUpScreen(widget.jobID, time, widget.job_no, widget.commander_tel),
        context);
  }

  void go_mile_record(String time) {
    //AppStyle().toast_text("GO " + jobID);
    AppStyle().link_to(
        mileRecordScreen(
            widget.jobID, time, widget.job_no, widget.commander_tel),
        context);
  }

  void go_time_record() {
    AppStyle().link_to(
        timeRecordScreen(widget.jobID, widget.job_no, widget.commander_tel),
        context);
  }

  void go_cost_record() {
    AppStyle().link_to(
        costRecordScreen(widget.jobID, widget.job_no, widget.commander_tel),
        context);
  }

  void go_to_summary() {
    AppStyle().link_to(
        summarytabScreen(widget.jobID, widget.job_no, widget.commander_tel),
        context);
  }
}
