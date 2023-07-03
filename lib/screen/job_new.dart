import 'package:edriver/api/job_api.dart';
import 'package:edriver/screen/home.dart';
import 'package:edriver/theme/app_style.dart';
import 'package:flutter/material.dart';

class jobNewScreen extends StatefulWidget {
  const jobNewScreen({Key? key}) : super(key: key);
  @override
  State<jobNewScreen> createState() => _jobNewScreenState();
}

class _jobNewScreenState extends State<jobNewScreen> {
  final ScrollController _controller = ScrollController();

  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
      GlobalKey<RefreshIndicatorState>();

  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: Job_api().get_new_job(),
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
                        children: [listview_job(snapshot.data)]),
                  ));
                } else {
                  return AppStyle().no_job("ไม่มีงานใหม่");
                }
              } else {
                //AppStyle().toast_text("null");
                return AppStyle().no_job("ไม่มีงานใหม่");
              }
              break;

            default:
              // debugPrint("Snapshot " + snapshot.toString());
              return AppStyle()
                  .open_loading(); // also check your listWidget(snapshot) as it may return null.
          }
        });
  }

  Widget listview_job(dt_new_job) {
    final count = dt_new_job.length;

    Size screenSize = MediaQuery.of(context).size;
    return ListView.builder(
      controller: _controller,
      shrinkWrap: true,
      itemCount: count,
      itemBuilder: (_, index) {
        final row = dt_new_job[index];
        return SizedBox(
          width: screenSize.width - 10,
          child: Card(
            color: Colors.lightGreen[100],
            child: InkWell(
              onTap: () {},
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
                    AppStyle().row_detail(
                        "เวลานัดหมาย", "${row["appointment_time"]} น."),
                    AppStyle().row_detail("จังหวัด",
                        "${row["province_name"]} / ${row["amphur_name"]}"),
                    AppStyle().row_detail("จุดหมาย", "${row["work_location"]}"),
                    AppStyle().row_detail("ทะเบียนรถ", row["full_plate_no"]),
                    AppStyle()
                        .row_detail("เลขทะเบียนภายใน", row["internal_no"]),
                    AppStyle().space_box(10),
                    btn(row["reserve_detail_jobID"]),
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

  Widget btn(reserve_detail_jobID) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          /* ElevatedButton.icon(
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
          ),*/
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
              minimumSize: const Size(100, 35),
            ),
            onPressed: () async {
              AppStyle().open_loading();
              try {
                await Job_api().confirm_job(reserve_detail_jobID);
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => HomeScreen(),
                  ),
                );
              } catch (e) {
                AppStyle().open_loading();
              }
            },
          ),
        ],
      ),
    );
  }
}
