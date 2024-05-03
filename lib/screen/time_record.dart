import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:edriver/api/job_api.dart';
import 'package:edriver/api/share_pref.dart';

import 'package:edriver/theme/element_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';

import 'time_record_later.dart';
import '../api/api.dart';
import '../api/location.dart';
import '../theme/app_style.dart';

class timeRecordScreen extends StatefulWidget {
  final String jobID;
  final String job_no;
  final String comander_tel;

  const timeRecordScreen(this.jobID, this.job_no, this.comander_tel,
      {super.key});
  @override
  State<timeRecordScreen> createState() => _timeRecordScreenState();
}

class _timeRecordScreenState extends State<timeRecordScreen> {
  var _dr_job, _dt_time, _dr_time, _driver_typeID, _pause_time;
  var _start_date,
      _end_date,
      _date_init,
      _start_time,
      _end_time,
      _location_start,
      _location_end;
  var _is_save_start = true;
  var _is_show_pause, is_lastdate = false;
  bool _isLoading = false;
  var _timeID = "";
  late DateTime _reseveDate;
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    //_isLoading ? const CircularProgressIndicator() : Container();

    return Scaffold(
      appBar: AppBar(
        title: Text("บันทึกเวลาทำงาน"),
      ),
      body: SingleChildScrollView(
        child: frm_time_start(),
      ),
      floatingActionButton: AppStyle().getBtnMenu(
          widget.jobID, widget.job_no, widget.comander_tel, context),
      bottomNavigationBar: AppStyle().butoom_bar(context, 2),
    );
  }

  void initState() {
    get_jobDetail();
    check_time_later();
    set_driver_type();
    super.initState();
  }

  set_driver_type() async {
    _driver_typeID = await Share_pref().read_data("driverType");
  }

  get_jobDetail() async {
    var data = await Job_api().get_job_detail(widget.jobID);

    _dr_job = data[0];
    _date_init = API().date_now();
    _start_date = _dr_job["start_date"];
    _end_date = _dr_job["end_date"];
    if (DateTime.parse(_date_init) == DateTime.parse(_end_date)) {
      is_lastdate = true;
    }
  }

  check_time_later() async {
    try {
      var param = {
        "reserve_detail_jobID": widget.jobID,
        "reserveDate": API().date_now(),
      };

      _dt_time = await API().callApi("job_time_record", param);

      _is_show_pause = false;
      if (_dt_time != null) {
        _dr_time = _dt_time[0];

        _timeID = _dr_time["resreve_record_timeID"];
        _pause_time = _dr_time["time_on_way"];

        if (_dr_time["time_end"] == null) {
          _is_save_start = false;
          _location_start = _dr_time["location_begin"];
          _start_time = _dr_time["time_begin"];

          if (is_lastdate && _dr_time["time_on_way"] == null) {
            _is_show_pause = true;
          } else {
            _is_show_pause = false;
          }
        }
      }

      setState(() {});
    } catch (e) {}
  }

  Widget frm_time_start() {
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
          AppStyle().space_box(20),
          element_widget().row_tmp_2(AppStyle().textLabel("วันที่ปฏิบัติงาน :"),
              element_widget().containerBoxText(API().date_now())),
          AppStyle().space_box(15),
          time_start(),
          AppStyle().space_box(15),
          location_start(),
          AppStyle().space_box(15),
          time_pause(),
          AppStyle().space_box(20),
          btn(),
          AppStyle().space_box(40),
          cardTimeRecord(),
          AppStyle().space_box(100),
        ]),
      ),
    );
  }

  cardTimeRecord() {
    if (_dt_time != null) {
      return element_widget()
          .card("เวลาทำงาน", Column(children: [list_time_record(context)]));
    } else {
      return Container();
    }
  }

  list_time_record(BuildContext context) {
    if (_dt_time != null) {
      var cnt_time = _dt_time.length;
      if (cnt_time > 0) {
        return Container(
            child: Column(
                children: List.generate(_dt_time.length, (i) {
          return element_widget().row_tmp_3(
              AppStyle().text(_dt_time[i]["dateThai"], 14),
              time_onway(
                  _dt_time[i]["time_thai"], _dt_time[i]["time_on_way_thai"]),
              Column(mainAxisAlignment: MainAxisAlignment.end, children: [
                AppStyle().a_link(
                  true,
                  TimeRecordLater(
                      widget.jobID,
                      widget.job_no,
                      widget.comander_tel,
                      _dt_time[i]["resreve_record_timeID"]),
                  context,
                )
              ]),
              [3, 5, 2]);
        })));
      } else {
        return Container();
      }
    } else {
      return Container();
    }
  }

  time_onway(time, timeway) {
    if (timeway != null) {
      return AppStyle().text("$time (${timeway} น.)", 14);
    } else {
      return AppStyle().text(time, 14);
    }
  }

  time_start() {
    if (!_is_save_start) {
      return element_widget().row_tmp_2(AppStyle().textLabel("เวลาเริ่มต้น :"),
          element_widget().containerBoxText("${_start_time}  น."));
    } else {
      return Container();
    }
  }

  time_pause() {
    if (_pause_time != null) {
      return element_widget().row_tmp_2(
          AppStyle().textLabel("เวลา (ลงระหว่างทาง) :"),
          element_widget().containerBoxText("${_pause_time}  น."));
    } else {
      return Container();
    }
  }

  location_start() {
    if (!_is_save_start) {
      return element_widget().row_tmp_2(
          AppStyle().textLabel(
            "สถานที่เริ่มต้นปฏิบัติงาน :",
          ),
          element_widget().containerBoxText(_location_start));
    } else {
      return Container();
    }
  }

  btn() {
    if (_is_save_start) {
      return btn_save();
    } else if (!_is_save_start && _is_show_pause) {
      return element_widget().row_tmp_2(btn_pause(), btn_stop());
    } else {
      return btn_stop();
    }
  }

  btn_save() {
    return btn_circle(Icons.play_arrow_outlined, Colors.lightGreen, save_time);
  }

  btn_pause() {
    return btn_circle(Icons.pause, Colors.amber, pause_time);
  }

  btn_stop() {
    return btn_circle(Icons.stop, Colors.red, stop_time);
  }

  btn_circle(icon, colors_btn, func) {
    return RawMaterialButton(
      onPressed: () {
        AppStyle().loading(context);
        try {
          func();
          // AppStyle().close_load(context);
        } catch (e) {}
      },
      elevation: 2.0,
      fillColor: colors_btn,
      child: Icon(
        icon,
        size: 45.0,
        color: Colors.white,
      ),
      padding: EdgeInsets.all(15.0),
      shape: CircleBorder(),
    );
  }

  save_time() async {
    Map param = {
      "reserve_detail_jobID": widget.jobID,
      "reserveDate": API().date_now(),
      "time_begin": API().time_now(),
      "location_begin": await Location().GetAddressFromLatLong(),
      "is_cal_ot": "1"
    };

    final res = await Job_api().save_time(param);

    AppStyle().toast_text_green("บันทึกข้อมูลเรียบร้อย");
    AppStyle().close_load(context);
    setState(() {
      _is_save_start = false;
    });

    Notify();
  }

  Future<void> Notify() async {
    check_time_later();
    get_jobDetail();
    if (_is_show_pause) {
      await AwesomeNotifications().createNotification(
          content: NotificationContent(
              id: 1,
              channelKey: 'k1',
              title: "บันทึกเวลาทำงาน",
              autoDismissible: false,
              largeIcon: 'resource://drawable/logo.png',
              notificationLayout: NotificationLayout.BigText,
              body:
                  "<br> วันที่ปฏิบัติงาน : ${API().date_now()} <br> เวลาเริ่มต้น : $_start_time น. <br> สถานที่เริ่มต้นปฏิบัติงาน : $_location_start"),
          actionButtons: [
            NotificationActionButton(
              key: 'pause_time',
              color: Colors.amber,
              label: 'ลงกลางทาง',
            ),
            NotificationActionButton(
                key: 'end_time', color: Colors.red, label: 'หยุดเวลาทำงาน'),
          ]);
    } else {
      await AwesomeNotifications().createNotification(
          content: NotificationContent(
              id: 1,
              channelKey: 'k1',
              title: "บันทึกเวลาทำงาน",
              autoDismissible: false,
              largeIcon: 'resource://drawable/logo.png',
              notificationLayout: NotificationLayout.BigText,
              body:
                  "<br> วันที่ปฏิบัติงาน : ${API().date_now()} <br> เวลาเริ่มต้น : $_start_time น. <br> สถานที่เริ่มต้นปฏิบัติงาน : $_location_start"),
          actionButtons: [
            NotificationActionButton(
              key: 'end_time',
              color: Colors.red,
              label: 'หยุดเวลาทำงาน',
            ),
          ]);
    }
  }

  stop_time() async {
    const CircularProgressIndicator();
    Map param = {
      "reserve_detail_jobID": widget.jobID,
      "resreve_record_timeID": _timeID,
      "reserveDate": API().date_now(),
      "time_begin": _start_time,
      "time_end": API().time_now(),
      "driver_typeID": _driver_typeID,
      "location_end": await Location().GetAddressFromLatLong()
    };

    final res = await Job_api().save_time(param);
    setState(() {
      _is_save_start = true;
    });
    AppStyle().toast_text_green("บันทึกข้อมูลเรียบร้อย");
    AppStyle().close_load(context);
    check_time_later();

    // AppStyle().link_to(
    //    summarytabScreen(widget.jobID, widget.job_no, widget.comander_tel),
    //     context);
  }

  pause_time() async {
    const CircularProgressIndicator();
    Map param = {
      "reserve_detail_jobID": widget.jobID,
      "resreve_record_timeID": _timeID,
      "reserveDate": API().date_now(),
      "time_on_way": API().time_now(),
    };

    final res = await Job_api().save_time(param);
    AppStyle().toast_text_green("บันทึกข้อมูลเรียบร้อย");
    setState(() {
      _is_save_start = false;
      _is_show_pause = false;
      _isLoading = false;
    });
    check_time_later();
    AppStyle().close_load(context);
  }
}
