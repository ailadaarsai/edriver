import 'package:edriver/api/job_api.dart';
import 'package:edriver/screen/costFuel.dart';

import 'package:flutter/material.dart';

import 'package:flutter/src/widgets/framework.dart';

import '../theme/app_style.dart';

class listFuelScreen extends StatefulWidget {
  final String jobID;
  final String cost_type;
  final String Job_no;
  final String commader_tel;
  const listFuelScreen(
      this.jobID, this.cost_type, this.Job_no, this.commader_tel,
      {super.key});

  @override
  State<listFuelScreen> createState() => _listFuelScreenState();
}

class _listFuelScreenState extends State<listFuelScreen> {
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
        title: Text("ข้อมูลค่าเชื้อเพลิง"),
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
                costFuel(widget.jobID, widget.Job_no, widget.commader_tel, ""),
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
        SizedBox(
          height: 10,
        ),
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
                      costFuel(widget.jobID, widget.Job_no, widget.commader_tel,
                          row["reserve_fuel_recordlD"]),
                      context);
                },
                child: Padding(
                  padding: const EdgeInsets.all(10),
                  child: Column(
                    //mainAxisAlignment: MainAxisAlignment.spaceEvenly,

                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      AppStyle().space_box(10),
                      AppStyle().row_detail("จ่ายโดย", pay_name(row["pay_by"])),
                      AppStyle()
                          .row_detail("ประเภทเชื้อเพลิง ", fuel_type(row)),
                      AppStyle()
                          .row_detail("ปริมาณ ", fuel_litre(row) + " ลิตร/kWh"),
                      AppStyle()
                          .row_detail("ค่าเชื้อเพลิง ", "${row["amount"]} บาท"),
                      AppStyle().row_detail(
                          "สถานที่เติมเชื้อเพลิง ", "${row["fuel_location"]}"),
                      AppStyle().row_detail(
                          "วันที่ตามใบเสร็จ ", "${row["reserveDate"]}"),
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

  pay_name(pay_type) {
    if (pay_type == "f") {
      return "ฟลีทการ์ด";
    } else if (pay_type == "c") {
      return "เงินสด";
    } else {
      return "ปั๊ม กฟผ.";
    }
  }

  fuel_type(row) {
    if (row["ngv"] != null) {
      return "NGV";
    } else if (row["sohol_95"] != null) {
      return "โซฮอล์";
    } else if (row["diesel"] != null) {
      return "ดีเซล";
    } else if (row["bensin"] != null) {
      return "เบนซิน";
    } else if (row["electric"] != null) {
      return "ไฟฟ้า";
    } else if (row["other_fuel"] != null) {
      return "อื่นๆ";
    }
  }

  fuel_litre(row) {
    if (row["ngv"] != null) {
      return row["ngv"];
    } else if (row["sohol_95"] != null) {
      return row["sohol_95"];
    } else if (row["diesel"] != null) {
      return row["diesel"];
    } else if (row["bensin"] != null) {
      return row["bensin"];
    } else if (row["electric"] != null) {
      return row["electric"];
    } else if (row["other_fuel"] != null) {
      return row["other_fuel"];
    }
  }
}
