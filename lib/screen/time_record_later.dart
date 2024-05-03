import 'package:edriver/screen/summary_tab.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rounded_date_picker/flutter_rounded_date_picker.dart';

import 'package:intl/intl.dart';
import '../api/api.dart';
import '../api/job_api.dart';
import '../api/share_pref.dart';
import '../theme/app_style.dart';
import '../theme/element_widget.dart';

class TimeRecordLater extends StatefulWidget {
  final String jobID;
  final String job_no;
  final String comander_tel;
  final String reserve_record_timeID;
  const TimeRecordLater(
      this.jobID, this.job_no, this.comander_tel, this.reserve_record_timeID,
      {super.key});
  @override
  State<TimeRecordLater> createState() => _TimeRecordLaterState();
}

class _TimeRecordLaterState extends State<TimeRecordLater> {
  var _dr_job, _dr_time = {};
  var _start_date, _end_date, _date_init, _driver_typeID;
  var _jobID = "";
  var _is_save_start = true;
  var _start_time, _end_time, _onway_time;
  var _is_save_end = true;
  var _is_edit_time = false;
  var _is_end = false;
  final _job_no = "";
  late DateTime _reseveDate;
  final _formKey = GlobalKey<FormState>();
  final reserve_dateController = TextEditingController();
  final location_startController = TextEditingController();
  final location_endController = TextEditingController();
  final time_startController = TextEditingController();
  final time_onWayController = TextEditingController();
  final time_endController = TextEditingController();
  bool _is_loading = true;
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: Job_api().get_job_detail(widget.jobID),
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.done:
              get_basicData(snapshot.data);

              return time_record(snapshot.data);

            default:
              // debugPrint("Snapshot " + snapshot.toString());
              return AppStyle()
                  .open_loading(); // also check your listWidget(snapshot) as it may return null.
          }
        });
    //return time_record(context);
  }

  void initState() {
    super.initState();
    setData();
  }

  get_basicData(dt) async {
    _driver_typeID = await Share_pref().read_data("driverType");
    _dr_job = dt[0];
    _start_date = _dr_job["start_date"];
    _end_date = _dr_job["end_date"];

    if (widget.reserve_record_timeID != "") {
      _is_edit_time = true;
    } else {
      _is_edit_time = false;
      _start_time = _onway_time = _end_time = "";
      _date_init = _start_date;
    }
  }

  setData() async {
    Map param = {};
    if (widget.reserve_record_timeID != "") {
      param = {"resreve_record_timeID": widget.reserve_record_timeID};
    } else {
      param = {"reserve_detail_jobID": widget.jobID};
    }
    var data = await Job_api().job_time_record(param);
    var dr = data[0];

    if (widget.reserve_record_timeID != "") {
      _date_init = dr["reserveDate"];
      reserve_dateController.text = _date_init.toString();
    }

    if (dr["time_begin"].toString() != "null" &&
        widget.reserve_record_timeID != '') {
      _start_time = dr["time_begin"];
      time_startController.text = _start_time;
      location_startController.text =
          (dr["location_begin"] != null) ? dr["location_begin"] : "";
    }

    if (dr["time_end"].toString() != "null" &&
        widget.reserve_record_timeID != '') {
      _end_time = dr["time_end"];
      location_endController.text = dr["location_end"];
      time_endController.text = _end_time;
    }
    if (dr["time_on_way"] != null && widget.reserve_record_timeID != '') {
      _is_end = true;
      time_onWayController.text = dr["time_on_way"];
      _onway_time = dr["time_on_way"];
    }
  }

  Widget time_record(data) {
    frm_edit_time(data);

    return Scaffold(
      appBar: AppBar(
        title: Text("บันทึกเวลาทำงาน"),
      ),
      body: SingleChildScrollView(
        child: frm_edit_time(data),
      ),
      floatingActionButton: AppStyle().getBtnMenu(
          widget.jobID, widget.job_no, widget.comander_tel, context),
      bottomNavigationBar: AppStyle().butoom_bar(context, 2),
    );
  }

  Widget frm_edit_time(dr) {
    setData();
    return Form(
      key: _formKey,
      child: Container(
        margin: const EdgeInsets.all(10),
        child: Column(mainAxisAlignment: MainAxisAlignment.start, children: [
          AppStyle().text("Job # " + widget.job_no, 24, Colors.blueGrey),
          AppStyle().space_box(15),
          AppStyle().text(
              "บันทึกเฉพาะวันที่ และช่วงเวลาที่ปฏิบัติงานเพื่อภารกิจของ กฟผ. เท่านั้น",
              16,
              Colors.red),
          text_calendar(),

          AppStyle().space_box(15),
          element_widget()
              .ddl("เวลา (เริ่มต้น)", time_startController, _start_time),
          element_widget().textbox_string(
              location_startController, "สถานที่ปฏิบัติงาน (เริ่มต้น)", true),
          AppStyle().space_box(15),
          element_widget().visible(
              element_widget().ddl("เวลา (ลงระหว่างทาง)", time_onWayController,
                  _onway_time, false),
              _is_end),
          AppStyle().space_box(15),
          element_widget().ddl("เวลา (สิ้นสุด)", time_endController, _end_time),

          element_widget().textbox_string(
              location_endController, "สถานที่ปฏิบัติงาน (สิ้นสุด)", true),
          AppStyle().space_box(20),
          btn(),
          AppStyle().space_box(20),
          // btn_save(),
        ]),
      ),
    );
  }

  text_calendar() {
    return TextFormField(
        readOnly: true,
        controller: reserve_dateController,
        textAlign: TextAlign.left,
        cursorWidth: 1,
        decoration: InputDecoration(
          label: Row(
            children: [
              Text("วันที่ปฏิบัติงาน"),
              element_widget().text_require()
            ],
          ),
          suffixIcon: Icon(Icons.calendar_month),
        ),
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'กรุณาระบุ วันที่ปฏิบัติงาน';
          }
        },
        onTap: () async {
          showRoundedDatePicker(
            locale: Locale('th', 'TH'),
            //era: EraMode.BUDDHIST_YEAR,
            theme: ThemeData(primarySwatch: Colors.teal),
            context: context,
            height: 300,
            initialDate: DateTime.parse(_date_init),
            firstDate: DateTime.parse(_start_date),
            lastDate: DateTime.parse(_end_date),
            borderRadius: 16,
          ).then((selectedDate) {
            if (selectedDate != null) {
              reserve_dateController.text =
                  DateFormat('yyyy-MM-dd').format(selectedDate);
              if (selectedDate == DateTime.parse(_end_date)) {
                setState(() {
                  _is_end = true;
                });
              } else {
                setState(() {
                  _is_end = false;
                  time_onWayController.text = "";
                });
              }
            }
          });
        });
  }

  btn() {
    if (widget.reserve_record_timeID != "") {
      return element_widget().row_tmp_3(
          element_widget().btn_edit(editTimeRecord),
          Container(),
          element_widget().btn_delete(deleteTimeRecord),
          [4, 1, 4]);
    } else {
      return element_widget()
          .btn_submit(_is_edit_time, "เวลาทำงาน", saveTimeRecord);
    }
  }

  saveTimeRecord() async {
    AppStyle().loading(context);

    try {
      Map param = {};
      if (_formKey.currentState!.validate()) {
        param = {
          "reserve_detail_jobID": widget.jobID,
          "reserveDate": reserve_dateController.text,
          "time_begin": time_startController.text,
          "time_end": time_endController.text,
          "location_begin": location_startController.text,
          "location_end": location_endController.text,
          "is_cal_ot": "1",
          "driver_typeID": _driver_typeID,
        };
        if (time_onWayController.text != "") {
          param["time_on_way"] = time_onWayController.text;
        }
        if (widget.reserve_record_timeID != "") {
          param["resreve_record_timeID"] = widget.reserve_record_timeID;
        }
        var start = time_startController.text;
        var start_explode = start.toString().split(":");
        var time_s = int.parse(start_explode[0]);

        var end = time_endController.text;
        var end_explode = end.toString().split(":");
        var time_e = int.parse(end_explode[0]);
       
        if (time_e > time_s) {
          var res = await API().callApi("time_record", param);
          AppStyle().close_load(context);
          AppStyle().toast_text_green("บันทึกข้อมูลเรียบร้อย");
          AppStyle().popScreen(context);
          AppStyle().link_to(
              summarytabScreen(
                  widget.jobID, widget.job_no, widget.comander_tel),
              context);
        } else {
          AppStyle().close_load(context);
          time_err();
        }
      } else {
        AppStyle().close_load(context);
      }
    } catch (e) {
      AppStyle().close_load(context);
    }
  }

  editTimeRecord() async {
    AppStyle().loading(context);
    try {
      Map param = {};
      if (_formKey.currentState!.validate()) {
        param = {
          "reserve_detail_jobID": widget.jobID,
          "reserveDate": reserve_dateController.text,
          "time_begin": time_startController.text,
          "time_end": time_endController.text,
          "location_begin": location_startController.text,
          "location_end": location_endController.text,
          "is_cal_ot": "1",
          "driver_typeID": _driver_typeID,
        };
        if (time_onWayController.text != "") {
          param["time_on_way"] = time_onWayController.text;
        }
        if (widget.reserve_record_timeID != "") {
          param["resreve_record_timeID"] = widget.reserve_record_timeID;
        }
        var start = time_startController.text;
        var start_explode = start.toString().split(":");
        var time_s = int.parse(start_explode[0]);

        var end = time_endController.text;
        var end_explode = end.toString().split(":");
        var time_e = int.parse(end_explode[0]);
       
        if (time_e > time_s) {
          final res = await API().callApi("time_record", param);

          if (res == "success") {
            AppStyle().toast_text_green("บันทึกข้อมูลเรียบร้อย");
            AppStyle().popScreen(context);
            AppStyle().link_to(
                summarytabScreen(
                    widget.jobID, widget.job_no, widget.comander_tel),
                context);
          }
        } else {
          AppStyle().close_load(context);
          time_err();
        }
      } else {
        AppStyle().close_load(context);
      }
    } catch (e) {}
  }

  time_err() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            scrollable: true,
            title: AppStyle().text(
                'กรุณา ระบุเวลาเริ่มต้น น้อยกว่า สิ้นสุด', 18, Colors.red),
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

  deleteTimeRecord() async {
    setState(() {
      _is_loading = true;
    });
    var param = {"resreve_record_timeID": widget.reserve_record_timeID};
    var res = await API().callApi("delete_time_record", param);

    if (res == "success") {
      AppStyle().toast_text_green("ลบข้อมูลเวลาทำงานเรียบร้อยแล้ว");
      AppStyle().popScreen(context);
      AppStyle().link_to(
          summarytabScreen(widget.jobID, widget.job_no, widget.comander_tel),
          context);
    } else {
      element_widget().toastSaveIncomplete();
    }
  }
}
