import 'package:edriver/api/job_api.dart';
import 'package:edriver/screen/home.dart';
import 'package:edriver/screen/job_tab.dart';
import 'package:edriver/theme/element_widget.dart';
import 'package:flutter/material.dart';

import '../api/api.dart';
import '../theme/app_style.dart';

class NotifyScreeen extends StatefulWidget {
  const NotifyScreeen({Key? key}) : super(key: key);

  @override
  State<NotifyScreeen> createState() => _NotifyScreeenState();
}

class _NotifyScreeenState extends State<NotifyScreeen> {
  final ScrollController _controller = ScrollController();
  final jobNoController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    /*FutureBuilder(
        future: Job_api().get_notify_unread(),
        builder: (context, snapshot) {
          if (snapshot.data != null) {
            if (snapshot.data.toString() != "[]") {
              return noti(snapshot.data);
            } else {*/
    return Scaffold(
      appBar: AppBar(
        title: const Text("ค้นหาเลขที่ใบงาน"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Center(
            child: Column(
          children: [
            element_widget().textbox_string(jobNoController, "เลขที่ใบงาน"),
            //AppStyle().
          ],
        )),
      ),
      bottomNavigationBar: AppStyle().butoom_bar(context, 2),
    );
  }
  /* } else {
            return AppStyle().open_loading();
          }
        });*/
}

/*Scaffold noti(dt_notify) {
  var count = dt_notify.length;
  return Scaffold(
      appBar: AppBar(
        title: const Text("ค้นหาใบงาน"),
      ),
      body: listview_notify(dt_notify));
  //   SingleChildScrollView(child: listview_notify(dt_notify)));
}

Widget listview_notify(dt_notify) {
  var count = dt_notify.length;

    Size screenSize = MediaQuery.of(context).size;
    return ListView.builder(
      controller: _controller,
      itemCount: count,
      itemBuilder: (_, index) {
        final row = dt_notify[index];
        return Expanded(
          child: SizedBox(
            child: Card(
              color: Colors.blueGrey[50],
              child: InkWell(
                onTap: () async {
                  //AppStyle().toast_text(row["driver_notifyID"]);
                  try {
                    await Job_api().read_notify(row["driver_notifyID"]);
                    AppStyle().link_to(HomeScreen(), context);
                  } catch (e) {}
                },
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    AppStyle().space_box(10),
                    AppStyle().text(row["title"], 16, Colors.green),
                    AppStyle().text(
                        row["desc"].replaceAll("<br>", "\n"), 14, Colors.black),
                    AppStyle().space_box(15),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}*/
