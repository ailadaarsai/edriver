import 'package:edriver/api/job_api.dart';
import 'package:edriver/screen/costTaxi.dart';

import 'package:flutter/material.dart';

import 'package:flutter/src/widgets/framework.dart';

import '../theme/app_style.dart';

class listTaxiScreen extends StatefulWidget {
  final String jobID;
  final String cost_type;
  final String Job_no;
  final String commader_tel;
  const listTaxiScreen(
      this.jobID, this.cost_type, this.Job_no, this.commader_tel,
      {super.key});

  @override
  State<listTaxiScreen> createState() => _listTaxiScreenState();
}

class _listTaxiScreenState extends State<listTaxiScreen> {
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
        title: Text("ข้อมูลค่า Taxi"),
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
                costTaxi(widget.jobID, widget.Job_no, widget.commader_tel, ""),
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
                      costTaxi(widget.jobID, widget.Job_no, widget.commader_tel,
                          row["reserve_costID"]),
                      context);
                },
                child: Padding(
                  padding: const EdgeInsets.all(10),
                  child: Column(
                    //mainAxisAlignment: MainAxisAlignment.spaceEvenly,

                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      AppStyle().space_box(10),
                      AppStyle().row_detail("เที่ยว ",
                          (row["location_type"] == "d") ? "ขามา" : "ขากลับ"),
                      AppStyle()
                          .row_detail("ค่าแท็กซี่ ", row["price"] + " บาท"),
                      AppStyle().row_detail("จาก ", row["location"]),
                      AppStyle().row_detail("ถึง ", row["location_to"]),
                      AppStyle().row_detail("วันที่ชำระเงิน ", row["date"]),
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
  }
}
