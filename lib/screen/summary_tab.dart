import 'dart:io';

import 'package:edriver/api/driver_api.dart';
import 'package:edriver/api/job_api.dart';
import 'package:edriver/api/share_pref.dart';
import 'package:edriver/screen/check_up.dart';
import 'package:edriver/screen/costHotel.dart';
import 'package:edriver/screen/costWage.dart';
import 'package:edriver/screen/cost_record.dart';
import 'package:edriver/screen/home.dart';

import 'package:intl/intl.dart';

import 'package:edriver/screen/listCarPark.dart';
import 'package:edriver/screen/listFuel.dart';
import 'package:edriver/screen/listOther.dart';
import 'package:edriver/screen/listTaxi.dart';
import 'package:edriver/screen/listTollway.dart';

import 'package:edriver/screen/mile_record.dart';
import 'package:edriver/screen/time_record_later.dart';
import 'package:edriver/theme/element_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import '../api/api.dart';
import '../theme/app_style.dart';

class summarytabScreen extends StatefulWidget {
  final String jobID;
  final String job_no;
  final String commander_tel;
  const summarytabScreen(this.jobID, this.job_no, this.commander_tel,
      {Key? key})
      : super(key: key);
  @override
  State<summarytabScreen> createState() => _summarytabScreenState();
}

class _summarytabScreenState extends State<summarytabScreen> {
  var _isEGAT, _is_edit = false;
  var _is_bkk = true;
  var _is_checkUp_before,
      _is_mile_begin,
      _is_mile_end,
      _is_checkUp_after = false;
  var _mile_begin, _mile_end, _total_km = "-";
  var _sum_tollway,
      _sum_car_park,
      _sum_fuel,
      _sum_other,
      _sum_taxi,
      _sum_OT_1,
      _sum_OT_15,
      _sum_OT_3,
      _jobID,
    
      _job_status;
  var _tc_wage_cost,
      _tc_hotel_cost,
      _tc_ot_cost,
      _r_wage_cost,
      _r_hotel_cost,
      _r_ot_cost,
      _r_fuel_cost,
      _car_service,
      _tc_fuel_cost,
      _total_tc_cost,
      _total_r_cost,
      _dr_job;
  var _dt_time, _dt_ot, _driver_name, checkup;

  List<bool> _selectedEasyPass = <bool>[false, false];
  List<Widget> _easyPass = <Widget>[
    Text('ใช้', style: TextStyle(fontSize: 14)),
    Text('ไม่ใช้', style: TextStyle(fontSize: 14))
  ];
  final ScrollController _controller = ScrollController();
  
  var label_before = "-";
  
  var label_after = "-";

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: Job_api().get_job_detail_close(widget.jobID),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            get_mile_record(snapshot.data);
            //get_checkup_record(snapshot.data);
            return job_detail(snapshot.data);
          } else {
            return AppStyle().open_loading();
          }
        });
  }

  void initState() {
    is_egat();
    get_time_record(widget.jobID);
    //get_checkup_record(widget.jobID);
    super.initState();
  }

  get_time_record(jobID) async {
    var param = {"reserve_detail_jobID": jobID};
    //  print(param);
    _dt_time = await Job_api().job_time_record(param);
    //print(_dt_time);
  }

    get_checkup_record(jobID) async {
    var param = {"reserve_detail_jobID": widget.jobID};

    //  print(param);
    checkup = await Job_api().checkUpCar_history(param);
    print("Checkup : ");
    print(checkup);
    //print(_dt_time);
  }

  get_mile_record(dr) {
    _dr_job = Job_api().get_job_status(dr["driver_action"]);
    _is_edit = _dr_job["is_edit"];

    _total_km = (dr["total_distance"] != null)
        ? dr["total_distance"].toString().replaceAll(".00", "")
        : "-";

    if (dr["region_type"] == "b") {
      _is_bkk = true;
    } else {
      _is_bkk = false;
    }

    _is_checkUp_before = (dr["check_before"] == "1") ? true : false;
    _is_checkUp_after = (dr["check_after"] == "1") ? true : false;
    _sum_OT_1 = dr["ot_r_1"];
    _sum_OT_15 = dr["ot_r_15"];
    _sum_OT_3 = dr["ot_r_3"];
    _tc_wage_cost = dr["tc_wage"];
    _r_wage_cost = dr["r_wage"];
    _tc_hotel_cost = dr["tc_hotel"];
    _r_hotel_cost = dr["r_hotel"];
    _tc_ot_cost = dr["tc_ot"];
    _car_service = dr["tc_car_cost"];
    _sum_tollway = dr["tollway"];
    _sum_car_park = dr["park"];
    _sum_other = dr["other"];
    _sum_taxi = dr["taxi"];
    _tc_fuel_cost = dr["tc_fuel"];
    _r_fuel_cost = dr["r_fuel"];
    _total_tc_cost = double.parse(_tc_wage_cost) +
        double.parse(_tc_hotel_cost) +
        double.parse(_tc_ot_cost) +
        double.parse(_car_service) +
        double.parse(_tc_fuel_cost) +
        double.parse(_sum_tollway) +
        double.parse(_sum_car_park) +
        double.parse(_sum_other);
    _total_r_cost = double.parse(_r_wage_cost) +
        double.parse(_r_hotel_cost) +
        double.parse(_r_fuel_cost) +
        double.parse(_sum_tollway) +
        double.parse(_sum_car_park) +
        double.parse(_sum_other) +
        double.parse(_sum_taxi);
  }

  is_egat() async {
    //ok
    _isEGAT = await driver_api().is_driver_EGAT();
  }

  Widget job_detail(dr) {
   //print(dr);
    if ((dr["mile_begin"] != null)) {
      _mile_begin = dr["mile_begin"];
      _is_mile_begin = true;
    } else {
      _mile_begin = "-";
      _is_mile_begin = false;
    }

    if (dr["mile_end"] != null) {
      _mile_end = dr["mile_end"];
      _is_mile_end = true;
    } else {
      _mile_end = "-";
      _is_mile_end = false;
    }

    return Scaffold(
      appBar: AppBar(
        title: Text("สรุปข้อมูลการเดินทาง"),
        actions: <Widget>[
          AppStyle().form_notify(context),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.max,
            children: [
              AppStyle().text("ใบงานเลขที่ : " + widget.job_no, 24, Colors.blueGrey),
              AppStyle().space_box(10),
              //element_widget().row_tmp_2(cardCheckup(),cardMile(dr["mile_begin"], dr["mile_end"])),
              cardCarRecord(dr),
              AppStyle().space_box(10),
              cardTimeRecord(),
              AppStyle().space_box(10),
              cardCostRecord(),
              AppStyle().space_box(15),
              btn_sent_report(),
              AppStyle().space_box(15),
              AppStyle().space_box(40),
            ],
          ),
        ),
      ),
      floatingActionButton: AppStyle().getBtnMenu(
          widget.jobID, widget.job_no, widget.commander_tel, context),
      bottomNavigationBar: AppStyle().butoom_bar(context, 2),
    );
  }

  Widget btn_sent_report() {
    if (_is_edit) {
      if (_mile_end != "-") {
        return Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.max,
            children: [
              Row(
                children: [
                  AppStyle().text("Easy Pass :"),
                  element_widget().text_require(),
                ],
              ),
              Center(child: toggle_btn(_selectedEasyPass, _easyPass, 100.0)),
              AppStyle().space_box(15),
              SizedBox(
                height: 50,
                width: double.infinity,
                child: ElevatedButton.icon(
                  icon: Icon(Icons.send_sharp),
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.teal),
                  label: Text("ส่งรายงานการเดินทาง",
                      style: TextStyle(fontSize: 20)),
                  onPressed: () async {
                    try {
                      if (_selectedEasyPass[0] == false &&
                          _selectedEasyPass[1] == false) {
                        easyPassErr();
                      } else {
                        AppStyle().loading(context);
                        Map param = {
                          "reserve_detail_jobID": widget.jobID,
                          "driverID": await Share_pref().read_data("driverID"),
                          "is_easy_pass":
                              (_selectedEasyPass[0] == true) ? "1" : "0",
                          "driver_action": "7",
                        };

                        final res = await Job_api().sent_report(param);
                        AppStyle().toast_text_green("บันทึกข้อมูลเรียบร้อย");
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => HomeScreen()));
                      }
                    } catch (e) {
                      AppStyle().open_loading();
                    }
                  },
                ),
              )
            ]);
      } else {
        return Container();
      }
    } else {
      return Container();
    }
  }

  Widget toggle_btn(_var, _select_choice, wd) {
    return ToggleButtons(
      direction: Axis.horizontal,
      onPressed: (int index) {
        for (int i = 0; i < _var.length; i++) {
          _var[i] = i == index;
          setState(() {});
        }
        //setCheckUp(name, _var);
      },
      borderRadius: const BorderRadius.all(Radius.circular(8)),
      selectedBorderColor: Colors.green[700],
      selectedColor: Colors.white,
      fillColor: Colors.green[200],
      color: Colors.green[400],
      constraints: BoxConstraints(
        minHeight: 40.0,
        minWidth: wd,
      ),
      isSelected: _var,
      children: _select_choice,
    );
    // checkList();
  }

  easyPassErr() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            scrollable: true,
            title:
                AppStyle().text('กรุณา ระบุการใช้ Easy Pass', 18, Colors.red),
            content: Container(),
            actions: <Widget>[
              new ElevatedButton(
                  child: const Text('ตกลง'),
                  style: ElevatedButton.styleFrom(
                    primary: Colors.green[200], // background
                    onPrimary: Colors.white, // foreground
                  ),
                  onPressed: () {
                    Navigator.pop(context);
                  })
            ],
          );
        });
  }

  cardCheckup(dr) {
    if (_is_edit == true) {
      if (dr["check_before"] == "1") {
        label_before = "ปกติ";
      } else
        label_before = "ผิดปกติ";

      if (dr["check_after"] == "1") {
        label_after = "ปกติ";
      } else
        label_after = "ผิดปกติ";
      return element_widget().card(
          "1.ตรวจสภาพรถ",
          Column(
            
            children: [
              AppStyle().row_btn(
                  "ก่อนเดินทาง",
                  "",
                  _is_checkUp_before,
                  checkUpScreen(
                      widget.jobID, "b", widget.job_no, widget.commander_tel),
                  context),
                AppStyle().space_box(10),
              AppStyle().row_btn(
                  "หลังเดินทาง",
                  "",
                  _is_checkUp_after,
                  checkUpScreen(
                      widget.jobID, "a", widget.job_no, widget.commander_tel),
                  context),
              //AppStyle().row_detail("", "")
            ],
          ));
    } else {
      return element_widget().card(
          "1.ตรวจสภาพรถ",
          Column(
            children: [
              AppStyle().row_detail("ก่อนเดินทาง", "", 14),
              AppStyle().space_box(10),
              AppStyle().row_detail("หลังเดินทาง", "", 14),
              //AppStyle().row_detail("", "")
            ],
          ));
    }
  }

  cardMile(mile_begin, mile_end) {
    if (_is_edit == true) {
      return element_widget().card(
          "2.ข้อมูลเลขไมล์",
          Column(children: [
            AppStyle().row_btn(
                "เริ่มต้น",
                _mile_begin,
                _is_mile_begin,
                mileRecordScreen(
                    widget.jobID, "b", widget.job_no, widget.commander_tel),
                context),
            AppStyle().row_btn(
                "สิ้นสุด",
                _mile_end,
                _is_mile_end,
                mileRecordScreen(
                    widget.jobID, "a", widget.job_no, widget.commander_tel),
                context),
            total_mile(_total_km),
          ]));
    } else {
      return element_widget().card(
          "2.ข้อมูลเลขไมล์",
          Column(children: [
            AppStyle().row_detail(
              "เริ่มต้น",
              _mile_begin,
            ),
            AppStyle().row_detail("สิ้นสุด", _mile_end),

            AppStyle().row_detail(
                "ระยะทาง", _total_km + " Km", 14, Colors.deepPurple),
            //total_mile(_total_km),
          ]));
    }
  }

  cardCarRecord(dr) {
    print(checkup);
    return Column(children: [
          cardCheckup(dr),
          element_widget().underline(Colors.deepPurple[200]),
          cardMile(dr["mile_begin"], dr["mile_end"])
        ]);
  }

  cardTimeRecord() {
    return element_widget().card(
        "3.เวลาทำงาน",
        Column(children: [
          rowTotalOT(),
          element_widget().underline(Colors.deepPurple[200]),
          list_time_record()
        ]));
  }

    cardCostRecord() {
      return Column(children: [
            // cardTransferCost(),
            element_widget().underline(Colors.deepPurple[200]),
            cardCostReal()
          ]);
    }

  rowTotalOT() {
    Widget w1 = 
      //alignment: Alignment.centerLeft,
      Row(
      mainAxisAlignment: MainAxisAlignment.center,
      
      children: [
        Expanded(
          child: Column( children: [
            AppStyle().textcenter("OT 1 เท่า", 14, Colors.deepPurple),
            AppStyle().textcenter(API().numberFormat(_sum_OT_1) + " ชม.", 14, Colors.deepPurple),
          ])
        ),
        Expanded(
          child: Column( children: [
          AppStyle().textcenter("OT 1.5 เท่า", 14, Colors.deepPurple),
          AppStyle().textcenter(API().numberFormat(_sum_OT_15) + " ชม.", 14, Colors.deepPurple),
        ]),
        ),
        Expanded(
          child: Column( children: [
          AppStyle().textcenter("OT 3 เท่า", 14, Colors.deepPurple),
          AppStyle().textcenter(API().numberFormat(_sum_OT_3) + " ชม.", 14, Colors.deepPurple),
      ]),
        ),
      ],

    );
    Widget w2 = Align(
    //alignment: Alignment.centerLeft,
    child: Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        AppStyle().textcenter(
            API().numberFormat(_sum_OT_1) + " ชม.", 14, Colors.deepPurple),
            AppStyle().space_box_width(30),
        AppStyle().textcenter(
            API().numberFormat(_sum_OT_15) + " ชม.", 14, Colors.deepPurple),
            AppStyle().space_box_width(30),
        AppStyle().textcenter(
            API().numberFormat(_sum_OT_3) + " ชม.", 14, Colors.deepPurple),
      ],
    )
    );
    Widget w3 = Center(child: SizedBox(
      height: 50,
      // width: 300,
      child: ElevatedButton.icon(
        icon: Icon(Icons.add),
        style: ElevatedButton.styleFrom(backgroundColor: Colors.teal),
        label: Text("เพิ่ม", style: TextStyle(fontSize: 14)),
        onPressed: () async {
          try {
            AppStyle().link_to(
                TimeRecordLater(
                    widget.jobID, widget.job_no, widget.commander_tel, ""),
                context);
          } catch (e) {
            AppStyle().open_loading();
          }
        },
      ),
    ),
    );
    if (_is_edit) {
                  return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        w1,
        
        w3,
        ],
      );
    } else {
            return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        w1,
        AppStyle().space_box(15),
        w3,
        ],
      );
    }
  }

  cardTransferCost() {
    return element_widget().card(
      "4.Transfer Cost",
      Column(
        children: [
          AppStyle().row_detail(
              "เบี้ยเลี้ยง", API().numberFormat(_tc_wage_cost) + " บาท", 13),
          AppStyle().row_detail(
              "ที่พัก", API().numberFormat(_tc_hotel_cost) + " บาท", 13),
          AppStyle()
              .row_detail("OT", API().numberFormat(_tc_ot_cost) + " บาท", 13),
          AppStyle().row_detail(
              "ค่าบริการรถ", API().numberFormat(_car_service) + " บาท", 13),
          AppStyle().row_detail(
              "เชื้อเพลิง", API().numberFormat(_tc_fuel_cost) + " บาท", 13),
          AppStyle().row_detail(
              "ทางด่วน", API().numberFormat(_sum_tollway) + " บาท", 13),
          AppStyle().row_detail(
              "ที่จอดรถ", API().numberFormat(_sum_car_park) + " บาท", 13),
          AppStyle().row_detail(
              "ค่าใช้จ่ายอื่นๆ", API().numberFormat(_sum_other) + " บาท", 13),
          AppStyle().row_detail(
              "รวม",
              API().numberFormat(_total_tc_cost) + " บาท",
              14,
              Colors.deepPurple),
        ],
      ),
    );
  }

  cardCostReal() {
    return card_real_cost(
      "4.ค่าใช้จ่ายจริง",
      Column(
        children: [
          element_widget().row_tmp_2(
            AppStyle().textLabel("เบี้ยเลี้ยง", Colors.black, 13),
            real_wage_cost(_r_wage_cost, _is_bkk),
          ),
          AppStyle().space_box(10),
          element_widget().row_tmp_2(
            AppStyle().textLabel("ที่พัก", Colors.black, 13),
            real_hotel_cost(_r_hotel_cost, _is_bkk),
          ),
          AppStyle().space_box(10),
          element_widget().row_tmp_2(
              AppStyle().textLabel("เชื้อเพลิง", Colors.black, 13),
              Align(
                  alignment: Alignment.centerRight,
                  child: r_cost(
                      _r_fuel_cost,
                      AppStyle().a_link_text(
                          API().numberFormat(_r_fuel_cost) + " บาท",
                          listFuelScreen(widget.jobID, "f", widget.job_no,
                              widget.commander_tel),
                          context,
                          13)))),
          AppStyle().space_box(10),
          element_widget().row_tmp_2(
              AppStyle().textLabel("ทางด่วน", Colors.black, 13),
              Align(
                  alignment: Alignment.centerRight,
                  child: r_cost(
                      _sum_tollway,
                      AppStyle().a_link_text(
                          API().numberFormat(_sum_tollway) + " บาท",
                          listTollwayScreen(widget.jobID, "t", widget.job_no,
                              widget.commander_tel),
                          context,
                          13)))),
          AppStyle().space_box(10),
          element_widget().row_tmp_2(
              AppStyle().textLabel("ที่จอดรถ", Colors.black, 13),
              Align(
                  alignment: Alignment.centerRight,
                  child: r_cost(
                      _sum_car_park,
                      AppStyle().a_link_text(
                          API().numberFormat(_sum_car_park) + " บาท",
                          listCarParkScreen(widget.jobID, "c", widget.job_no,
                              widget.commander_tel),
                          context,
                          13)))),
          AppStyle().space_box(10),
          element_widget().row_tmp_2(
              AppStyle().textLabel("ค่าใช้จ่ายอื่นๆ", Colors.black, 13),
              Align(
                  alignment: Alignment.centerRight,
                  child: r_cost(
                      _sum_other,
                      AppStyle().a_link_text(
                          API().numberFormat(_sum_other) + " บาท",
                          listOtherScreen(widget.jobID, "o", widget.job_no,
                              widget.commander_tel),
                          context,
                          13)))),
          AppStyle().space_box(10),
          element_widget().visible(
              element_widget().row_tmp_2(
                  AppStyle().textLabel("ค่าTaxi", Colors.black, 13),
                  Align(
                    alignment: Alignment.centerRight,
                    child: r_cost(
                        _sum_taxi,
                        AppStyle().a_link_text(
                            API().numberFormat(_sum_taxi) + " บาท",
                            listTaxiScreen(widget.jobID, "tx", widget.job_no,
                                widget.commander_tel),
                            context,
                            13)),
                  )),
              _isEGAT),
          AppStyle().row_detail(
              "รวม",
              API().numberFormat(_total_r_cost) + " บาท",
              14,
              Colors.deepPurple),
          AppStyle().row_detail("", ""),
        ],
      ),
    );
  }

  r_cost(cost, Element) {
    if (_is_edit) {
      return Element;
    } else {
      return Align(
          alignment: Alignment.centerRight,
          child: Text(API().numberFormat(cost) + " บาท",
              textAlign: TextAlign.right,
              style: TextStyle(fontSize: 13, color: Colors.black)));
    }
  }

  Widget total_mile(km) {
    return element_widget().row_tmp_2(
        AppStyle().textLabel("ระยะทาง", Colors.deepPurple, 14),
        AppStyle().textLabel("$km  Km.", Colors.deepPurple, 14),
        [4, 6]);
  }

  list_time_record() {

    if (_dt_time != null) {
      var cnt_time = _dt_time.length;
      if (cnt_time > 0) {
        if (_is_edit) {
          return Container(
              //alignment: Alignment.centerLeft,
              child: Column(
                  children: List.generate(_dt_time.length, (i) {
            return element_widget().row_tmp_3(
                AppStyle().text(convertToNewFormat(_dt_time[i]["dateThai"]), 14),
                time_onway(
                    _dt_time[i]["time_thai"], _dt_time[i]["time_on_way_thai"]),
                Column(mainAxisAlignment: MainAxisAlignment.end, children: [
                  btn_edit_time(
                      widget.jobID,
                      widget.job_no,
                      widget.commander_tel,
                      _dt_time[i]["resreve_record_timeID"]),
                ]),
                [4, 6, 1]);
          })));
        } else {
          return Container(
            //alignment: Alignment.centerLeft,
              child: Column(
                  children: List.generate(_dt_time.length, (i) {
            return element_widget().row_tmp_3(
                AppStyle().text(convertToNewFormat(_dt_time[i]["dateThai"]), 14),
                Container(),
                time_onway(
                    _dt_time[i]["time_thai"], _dt_time[i]["time_on_way_thai"]),
                [4, 6, 1]);
          })));
        }
      } else {
        return Container();
      }
    } else {
      return Container();
    }
  }

  String convertToNewFormat(String oldDateThai) {
  // Create a DateFormat object for parsing the old date format
    DateFormat oldFormat = DateFormat('dd MMM yyyy', 'th');

    // Parse the old date string
    DateTime dateTime = oldFormat.parseLoose(oldDateThai);

    // Create a new date format for the desired output
    DateFormat newFormat = DateFormat('dd MMM yy', 'th');

    // Format the date using the new format
    String newDateThai = newFormat.format(dateTime);

    return newDateThai;
  }

  btn_edit_time(jobID, job_no, tel, costID) {
    if (_is_edit == true) {
      return AppStyle().a_link(
        true,
        TimeRecordLater(jobID, job_no, tel, costID),
        context,
      );
    } else {
      return Container();
    }
  }

  real_wage_cost(cost, is_bkk) {
    if (is_bkk || !_is_edit) {
      return Align(
          alignment: Alignment.centerRight,
          child: Text(API().numberFormat(cost) + " บาท",
              textAlign: TextAlign.right,
              style: TextStyle(fontSize: 13, color: Colors.black)));
    } else {
      return Align(
          alignment: Alignment.centerRight,
          child: AppStyle().a_link_text(
              API().numberFormat(cost) + " บาท",
              costWage(widget.jobID, widget.job_no, widget.commander_tel),
              context,
              13));
    }
  }

  real_hotel_cost(cost, is_bkk) {
    if (is_bkk || !_is_edit) {
      return Align(
          alignment: Alignment.centerRight,
          child: Text(API().numberFormat(cost) + " บาท",
              textAlign: TextAlign.right,
              style: TextStyle(fontSize: 13, color: Colors.black)));
    } else {
      return Align(
          alignment: Alignment.centerRight,
          child: AppStyle().a_link_text(
              API().numberFormat(cost) + " บาท",
              costHotel(widget.jobID, widget.job_no, widget.commander_tel),
              context,
              13));
    }
  }

  time_onway(time, timeway) {
    if (timeway != null) {
      return AppStyle().text("$time (${timeway} น.)", 14);
    } else {
      return AppStyle().text(time, 14);
    }
  }

  card_real_cost(header_text, element) {
    return Container(
        decoration: const BoxDecoration(
          color: Colors.black12,
          borderRadius: BorderRadius.all(Radius.circular(15)),
          boxShadow: null,
        ),
        padding: const EdgeInsets.all(10),
        child: Column(children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                header_text,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: Colors.teal,
                ),
              ),
              btn_save_cost(Align(
                alignment: Alignment.centerRight,
                child: AppStyle().a_link(
                    false,
                    costRecordScreen(
                        widget.jobID, widget.job_no, widget.commander_tel),
                    context,
                    13),
              ))
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

  btn_save_cost(ele) {
    if (_is_edit) {
      return ele;
    } else {
      return Container();
    }
  }
}
