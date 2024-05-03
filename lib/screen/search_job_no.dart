import 'dart:ffi';

import 'package:edriver/api/job_api.dart';
import 'package:edriver/api/share_pref.dart';
import 'package:edriver/screen/home.dart';
import 'package:edriver/screen/job_detail.dart';
import 'package:edriver/screen/job_tab.dart';
import 'package:edriver/screen/summary_tab.dart';
import 'package:edriver/theme/element_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';
import 'package:qr_flutter/qr_flutter.dart';

import '../api/api.dart';
import '../theme/app_style.dart';

class searchJobNoScreeen extends StatefulWidget {
  const searchJobNoScreeen({Key? key}) : super(key: key);

  @override
  State<searchJobNoScreeen> createState() => _searchJobNoScreeenState();
}

class _searchJobNoScreeenState extends State<searchJobNoScreeen> {
  final _form = GlobalKey<FormState>();
  final jobNoController = TextEditingController();
  final ScrollController _controller = ScrollController();
  List<dynamic> listjob = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("ค้นหาเลขที่ใบงาน"),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            padding: const EdgeInsets.all(10.0),
            // padding: const EdgeInsets.symmetric(horizontal: 32),
            height: MediaQuery.of(context).size.height,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                //logo
                // SvgPicture.asset("assets/icon_oinkgram.svg",height: 64,color: Colors.pink.shade200,)
               // Flexible(child: Container()),
                element_widget().textbox_string(jobNoController, "เลขที่ใบงาน"),
                const SizedBox(
                  height: 10,
                ),
                element_widget()
                    .btn("ค้นหาเลขที่ใบงาน", Icon(Icons.search), search_job_no),
                const SizedBox(
                  height: 10,
                ),
                list_job_detail(listjob),
                const SizedBox(
                  height: 50,
                ),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: AppStyle().butoom_bar(context, 3),
    );
  }

  search_job_no() async {
    //AppStyle().toast_text(jobNoController.text);
    var _driverID = await Share_pref().read_data("driverID");
    Map param = {"job_no": jobNoController.text, "driverID": _driverID};
    AppStyle().open_loading();

    List<dynamic> result = await API().callApi("search_job_no", param);

    setState(() {
      if (result != []) {
        listjob = result;
        list_job_detail(listjob);
        // AppStyle().close_load(context);
      }
    });
  }

  Widget list_job_detail(listjob) {
    if (listjob != []) {
      var count = listjob.length;
      if (count > 0) {
        var screenSize = MediaQuery.of(context).size;
        return ListView.builder(
          controller: _controller,
          shrinkWrap: true,
          itemCount: count,
          itemBuilder: (_, index) {
            final row = listjob[index];
            return SizedBox(
              width: screenSize.width,
              child: Card(
                color: Colors.lightBlue[100],
                child: InkWell(
                  onTap: () {
                    var jobID = row["reserve_detail_jobID"];
                    var job_no = row["job_no"];
                    var commander_mobile = row["commander_mobile"];

                    AppStyle().link_to(
                        jobDetailScreen(jobID, job_no, commander_mobile),
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
                        AppStyle()
                            .row_detail("ทะเบียนรถ", row["full_plate_no"]),
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
                        AppStyle()
                            .row_detail("จุดหมาย", "${row["work_location"]}"),
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
      } else {
        return AppStyle().no_job("ไม่พบข้อมูล");
      }
    } else {
      return Container();
    }
  }
}
