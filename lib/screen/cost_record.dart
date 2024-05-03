import 'package:edriver/api/api.dart';
import 'package:edriver/api/job_api.dart';
import 'package:edriver/screen/costCarPark.dart';
import 'package:edriver/screen/costFuel.dart';
import 'package:edriver/screen/costHotel.dart';
import 'package:edriver/screen/costOther.dart';
import 'package:edriver/screen/costTaxi.dart';
import 'package:edriver/screen/costTollway.dart';
import 'package:edriver/screen/costWage.dart';
import 'package:edriver/screen/listCarPark.dart';
import 'package:edriver/screen/listFuel.dart';
import 'package:edriver/screen/listOther.dart';
import 'package:edriver/screen/listTaxi.dart';
import 'package:edriver/screen/listTollway.dart';
import 'package:edriver/theme/element_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';

import '../api/driver_api.dart';
import '../theme/app_style.dart';

class costRecordScreen extends StatefulWidget {
  final String jobID;
  final String job_no;
  final String commander_tel;
  const costRecordScreen(this.jobID, this.job_no, this.commander_tel,
      {super.key});

  @override
  State<costRecordScreen> createState() => _costRecordScreenState();
}

class _costRecordScreenState extends State<costRecordScreen> {
  TextEditingController tollwayController = TextEditingController();
  TextEditingController carParkController = TextEditingController();
  TextEditingController fuelController = TextEditingController();
  TextEditingController otherController = TextEditingController();
  var _isRegion = false;

  var _isEGAT = false;

  @override
  void initState() {
    super.initState();
    is_egat();
  }

  @override
  Widget build(BuildContext context) {
    var param = {"reserve_detail_jobID": widget.jobID};
    return FutureBuilder(
        future: Job_api().sumCost(param),
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.done:
              if (snapshot.data.toString() != "[]") {
                return Scaffold(
                  appBar: AppBar(
                    title: Text("บันทึกค่าใช้จ่าย"),
                  ),
                  body: SingleChildScrollView(
                    child: job_summary(snapshot.data, context),
                  ),
                  floatingActionButton: AppStyle().getBtnMenu(widget.jobID,
                      widget.job_no, widget.commander_tel, context),
                  bottomNavigationBar: AppStyle().butoom_bar(context, 2),
                );
                break;
              } else {
                return AppStyle().open_loading();
              }
            default:
              // debugPrint("Snapshot " + snapshot.toString());
              return AppStyle()
                  .open_loading(); // also check your listWidget(snapshot) as it may return null.
          }
        });
  }

  is_egat() async {
    _isEGAT = await driver_api().is_driver_EGAT();
    setState(() {});
  }

  Widget job_summary(data, context) {
    _isRegion = (data["region_type"] == "p") ? true : false;
    return Container(
      margin: const EdgeInsets.fromLTRB(20, 10, 10, 10),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          AppStyle().text("Job # " + widget.job_no, 24, Colors.blueGrey),
          AppStyle().space_box(15),
          AppStyle().text(
              "* หากไม่บันทึกจะไม่สามารถเบิกค่าใช้จ่ายได้", 16, Colors.red),
          AppStyle().space_box(15),
          Wage_region(data),
          hotel_region(data),
          row_cost(
              "ค่าทางด่วน",
              AppStyle().a_link_text(
                  data["tollway"],
                  listTollwayScreen(
                      widget.jobID, "t", widget.job_no, widget.commander_tel),
                  context),
              save_tollway),
          row_cost(
              "ค่าที่จอดรถ",
              AppStyle().a_link_text(
                  data["park"],
                  listCarParkScreen(
                      widget.jobID, "c", widget.job_no, widget.commander_tel),
                  context),
              save_car_park),
          row_cost(
              "ค่าเชื้อเพลิง",
              AppStyle().a_link_text(
                  data["fuel"],
                  listFuelScreen(
                      widget.jobID, "f", widget.job_no, widget.commander_tel),
                  context),
              save_fuel),
          row_cost(
              "ค่าใช้จ่ายอื่นๆ",
              AppStyle().a_link_text(
                  data["other"],
                  listOtherScreen(
                      widget.jobID, "o", widget.job_no, widget.commander_tel),
                  context),
              save_other),
            AppStyle().space_box(100),
          element_widget().visible(
              row_cost(
                  "ค่า Taxi",
                  AppStyle().a_link_text(
                      data["taxi"],
                      listTaxiScreen(widget.jobID, "tx", widget.job_no,
                          widget.commander_tel),
                      context),
                  save_taxi),
              _isEGAT),

              AppStyle().space_box(50),
        ],
      ),
    );
  }

  Wage_region(data) {
    if (_isRegion == false) {
      return Row(
        children: <Widget>[
          Expanded(
              flex: 5,
              child: Container(
                  child: Text(
                "ค่าเบี้ยเลี้ยง :",
                textAlign: TextAlign.left,
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 16,
                    fontWeight: FontWeight.bold),
              ))),
          Expanded(
            flex: 4,
            child: Align(
                alignment: Alignment.centerRight,
                child: AppStyle().text("0.00", 16, Colors.black)),
          ),
          Expanded(
            flex: 2,
            child: Text("บาท",
                textAlign: TextAlign.right,
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 16,
                )),
          ),
          Expanded(
            flex: 2,
            child: Container(),
          ),
        ],
      );
    } else {
      return row_cost(
          "ค่าเบี้ยเลี้ยง",
          AppStyle().a_link_text(
              API().numberFormat(data["r_wage"]),
              costWage(widget.jobID, widget.job_no, widget.commander_tel),
              context),
          save_wage);
    }
  }

  hotel_region(data) {
    if (_isRegion == false) {
      return Row(
        children: <Widget>[
          Expanded(
              flex: 3,
              child: Container(
                  child: Text(
                "ค่าที่พัก :",
                textAlign: TextAlign.left,
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 16,
                    fontWeight: FontWeight.bold),
              ))),
          Expanded(
            flex: 4,
            child: Align(
                alignment: Alignment.centerRight,
                child: AppStyle().text("0.00", 16, Colors.black)),
          ),
          Expanded(
            flex: 2,
            child: Text("บาท",
                textAlign: TextAlign.right,
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 16,
                )),
          ),
          Expanded(
            flex: 2,
            child: Container(),
          ),
        ],
      );
    } else {
      return row_cost(
          "ค่าที่พัก",
          AppStyle().a_link_text(
              API().numberFormat(data["r_hotel"]),
              costHotel(widget.jobID, widget.job_no, widget.commander_tel),
              context),
          save_hotel);
    }
  }

  Widget row_cost(text, w, func) {
    return Row(
      children: <Widget>[
        Expanded(
            flex: 5,
            child: Container(
                child: Text(
              "${text} :",
              textAlign: TextAlign.left,
              style: TextStyle(
                  color: Colors.black,
                  fontSize: 16,
                  fontWeight: FontWeight.bold),
            ))),
        Expanded(
          flex: 4,
          child: Align(alignment: Alignment.centerRight, child: w),
        ),
        Expanded(
          flex: 2,
          child: Text("บาท",
              textAlign: TextAlign.right,
              style: TextStyle(
                color: Colors.black,
                fontSize: 16,
              )),
        ),
        Expanded(
          flex: 2,
          child: Container(
            child: RawMaterialButton(
              onPressed: () {
                func();
              },
              elevation: 2.0,
              fillColor: Colors.teal,
              child: Icon(
                Icons.add,
                size: 15.0,
                color: Colors.white,
              ),
              padding: EdgeInsets.all(10.0),
              shape: CircleBorder(),
            ),
          ),
        ),
      ],
    );
  }

  save_wage() {
    AppStyle().link_to(
        costWage(widget.jobID, widget.job_no, widget.commander_tel), context);
  }

  save_hotel() {
    AppStyle().link_to(
        costHotel(widget.jobID, widget.job_no, widget.commander_tel), context);
  }

  save_tollway() {
    AppStyle().link_to(
        costTollway(widget.jobID, widget.job_no, widget.commander_tel, ""),
        context);
  }

  save_car_park() {
    AppStyle().link_to(
        costCarPark(widget.jobID, widget.job_no, widget.commander_tel, ""),
        context);
  }

  save_fuel() {
    AppStyle().link_to(
        costFuel(widget.jobID, widget.job_no, widget.commander_tel, ""),
        context);
  }

  save_other() {
    AppStyle().link_to(
        costOther(widget.jobID, widget.job_no, widget.commander_tel, ""),
        context);
  }

  save_taxi() {
    AppStyle().link_to(
        costTaxi(widget.jobID, widget.job_no, widget.commander_tel, ""),
        context);
  }
}
