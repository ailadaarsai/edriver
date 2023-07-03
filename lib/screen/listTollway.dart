import 'package:edriver/api/job_api.dart';
import 'package:edriver/screen/costTollway.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:get/get_state_manager/src/simple/get_widget_cache.dart';

import '../api/api.dart';
import '../theme/app_style.dart';

class listTollwayScreen extends StatefulWidget {
  final String jobID;
  final String cost_type;
  final String Job_no;
  final String commader_tel;
  const listTollwayScreen(
      this.jobID, this.cost_type, this.Job_no, this.commader_tel,
      {super.key});

  @override
  State<listTollwayScreen> createState() => _listTollwayScreenState();
}

class _listTollwayScreenState extends State<listTollwayScreen> {
  final ScrollController _controller = ScrollController();
  @override
  Widget build(BuildContext context) {
    var param = {
      "reserve_detail_jobID": widget.jobID,
      "cost_type": widget.cost_type
    };
    return FutureBuilder(
        future: Job_api().get_costRecord(param),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return AppStyle().open_loading();
          } else {
            return cost(snapshot.data);
          }
        });
  }

  Scaffold cost(data) {
    return Scaffold(
      appBar: AppBar(
        title: Text("ข้อมูลค่าทางด่วน"),
        actions: <Widget>[
          AppStyle().form_notify(context),
        ],
      ),
      body: SingleChildScrollView(
        physics: ScrollPhysics(),
        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          Padding(
            padding: const EdgeInsets.all(10),
            child: listview_cost(data),
          ),
        ]),
      ),
      floatingActionButton:
          Column(mainAxisAlignment: MainAxisAlignment.end, children: [
        FloatingActionButton(
          onPressed: () {
            AppStyle().link_to(
                costTollway(
                    widget.jobID, widget.Job_no, widget.commader_tel, ""),
                context);
          },
          backgroundColor: Colors.green,
          child: const Icon(Icons.add),
          heroTag: null,
        ),
        SizedBox(
          height: 10,
        ),
        AppStyle().getBtnMenu(
            widget.jobID, widget.Job_no, widget.commader_tel, context),
      ]),
      bottomNavigationBar: AppStyle().butoom_bar(context, 2),
    );
  }

  Widget listview_cost(dt) {
    if (dt != null) {
      final count = dt.length;

      Size screenSize = MediaQuery.of(context).size;
      if (count > 0) {
        return ListView.builder(
          controller: _controller,
          shrinkWrap: true,
          itemCount: count,
          itemBuilder: (_, index) {
            final row = dt[index];
            return SizedBox(
              width: screenSize.width - 10,
              child: Card(
                color: Colors.yellow[100],
                child: InkWell(
                  onTap: () {
                    AppStyle().link_to(
                        costTollway(widget.jobID, widget.Job_no,
                            widget.commader_tel, row["reserve_costID"]),
                        context);
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(10),
                    child: Column(
                      //mainAxisAlignment: MainAxisAlignment.spaceEvenly,

                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        AppStyle().space_box(10),
                        AppStyle().row_detail(
                            "ยอดรวมค่าทางด่วน", row["price"] + " บาท"),
                        AppStyle().row_detail(
                            "จำนวนใบเสร็จ ", row["receipt_num"] + " ใบ"),
                        AppStyle().space_box(10),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        );
      } else {
        return Center(
          child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [AppStyle().text("ไม่มีข้อมูล  !!!", 24, Colors.red)]),
        );
      }
    } else {
      return Center(
        child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [AppStyle().text("ไม่มีข้อมูล  !!!", 24, Colors.red)]),
      );
    }
  }
}
