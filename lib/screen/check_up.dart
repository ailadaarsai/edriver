import 'package:edriver/screen/summary_tab.dart';
import 'package:edriver/theme/element_widget.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/material.dart';
import '../api/job_api.dart';
import '../theme/app_style.dart';

class checkUpScreen extends StatefulWidget {
  final String jobID;
  final String time;
  final String job_no;
  final String commander_tel;

  const checkUpScreen(this.jobID, this.time, this.job_no, this.commander_tel,
      {super.key});

  @override
  State<checkUpScreen> createState() => _checkUpScreenState();
}

class _checkUpScreenState extends State<checkUpScreen> {
  late String jobID;

  var _job_detail;
  var _checkup_detail;
  var _is_edit;

  var _selectedClean;
  var _selectedMachine;
  var _selectedChassis;
  var _selectedElectric;
  var _selectedMonitor;
  var _selectedGear;
  var _selectedAsset;
  var _selectedLower;

  static const List<Widget> _isOK = <Widget>[
    Text('ปกติ', style: TextStyle(fontSize: 12)),
    Text('ผิดปกติ', style: TextStyle(fontSize: 12))
  ];

  TextEditingController RemarkController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  @override
  void initState() {
    setState(() {
      _checkup_detail = sendData();
    });

    super.initState();
  }

  Future<dynamic> sendData() async {
    _checkup_detail = await Job_api().checkUpCar_history(
        {"reserve_detail_jobID": widget.jobID, "time_check": widget.time});

    return _checkup_detail;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: Job_api().get_job_detail(widget.jobID),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return AppStyle().open_loading();
          } else {
            if (snapshot.data != null) {
              _job_detail = snapshot.data;
              return checkup(_job_detail);
            }
            return checkup(_job_detail);
          }
        });
  }

  set_editData() {
    if (_checkup_detail.toString() != "[]" &&
        (_selectedClean.toString() == "[]" ||
            _selectedClean.toString() == "null")) {
      _is_edit = true;
      get_selectDB();
    } else if (_checkup_detail.toString() == "[]" &&
        (_selectedClean.toString() == "[]" ||
            _selectedClean.toString() == "null")) {
      RemarkController.text = "";
      _is_edit = false;
      get_fromDefault();
    } else {}
  }

  get_fromDefault() {
    _selectedClean = <bool>[true, false];
    _selectedMachine = <bool>[true, false];
    _selectedChassis = <bool>[true, false];
    _selectedElectric = <bool>[true, false];
    _selectedMonitor = <bool>[true, false];
    _selectedGear = <bool>[true, false];
    _selectedAsset = <bool>[true, false];
    _selectedLower = <bool>[true, false];
  }

  get_selectDB() {
    if (_checkup_detail["remark"] != null) {
      RemarkController.text = _checkup_detail["remark"].toString();
    } else {
      RemarkController.text = "";
    }
    _selectedClean = get_checkup_item(_checkup_detail["clean"].toString());
    _selectedMachine = get_checkup_item(_checkup_detail["machine"].toString());
    _selectedChassis = get_checkup_item(_checkup_detail["chassis"].toString());
    _selectedElectric =
        get_checkup_item(_checkup_detail["electric"].toString());
    _selectedMonitor = get_checkup_item(_checkup_detail["monitor"].toString());
    _selectedGear = get_checkup_item(_checkup_detail["gear"].toString());
    _selectedAsset = get_checkup_item(_checkup_detail["asset"].toString());
    _selectedLower = get_checkup_item(_checkup_detail["lower"].toString());
  }

  get_checkup_item(item) {
    if (item.toString() == "true" || item.toString() == "0") {
      return <bool>[true, false];
    } else {
      return <bool>[false, true];
    }
  }

  Widget checkup(dt) {
    var row = dt[0];
    set_editData();

    var children2 = [
      AppStyle()
          .textLabel("Job # " + row["job_no"], Colors.deepOrangeAccent, 20),
      AppStyle().space_box(20),
      AppStyle()
          .row_detail("วันที่", "${row["job_date"]} (${row["cnt_date"]} วัน)"),
      AppStyle().row_detail("ทะเบียนรถ", row["full_plate_no"]),
      AppStyle().row_detail("เลขทะเบียนภายใน", row["internal_no"]),
      AppStyle().space_box(20),
      checkList(),
      TextFormField(
        controller: RemarkController,
        keyboardType: TextInputType.multiline,
        maxLines: null,
        decoration: InputDecoration(
          suffixIcon: IconButton(
              onPressed: RemarkController.clear, icon: Icon(Icons.clear)),
          labelText: "หมายเหตุ",
        ),
      ),
      AppStyle().space_box(20),
      element_widget().btn_submit(_is_edit, "การตรวจสภาพรถ", save_check_car),
      AppStyle().space_box(40),
    ];
    return Scaffold(
        appBar: AppBar(
          title: (widget.time == "b")
              ? Text("ตรวจสภาพรถ ก่อนเดินทาง")
              : Text("ตรวจสภาพรถ หลังเดินทาง"),
        ),
        body: SingleChildScrollView(
            child: Form(
          key: _formKey,
          child: Container(
            margin: const EdgeInsets.all(8),
            child: Center(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: children2,
              ),
            ),
          ),
        )),
        floatingActionButton: AppStyle().getBtnMenu(
            widget.jobID, widget.job_no, widget.commander_tel, context),
        bottomNavigationBar: AppStyle().butoom_bar(context, 2));
  }

  save_check_car() async {
    try {
      if (_formKey.currentState!.validate()) {
        var param = {
          "reserve_detail_jobID": widget.jobID,
          "time_check": widget.time,
          "clean": _selectedClean[0].toString(),
          "machine": _selectedMachine[0].toString(),
          "chassis": _selectedChassis[0].toString(),
          "electric": _selectedElectric[0].toString(),
          "monitor": _selectedMonitor[0].toString(),
          "gear": _selectedGear[0].toString(),
          "asset": _selectedAsset[0].toString(),
          "lower": _selectedLower[0].toString(),
        };
        if (RemarkController.text != "") {
          param["remark"] = RemarkController.text.toString();
        }
        //print(param);
        final result = await Job_api().checkUpCar(param);
        if (result == "success") {
          AppStyle().toast_text_green("บันทึกข้องมูลเรียบร้อย");
          AppStyle().popScreen(context);
          AppStyle().link_to(
              summarytabScreen(
                  widget.jobID, widget.job_no, widget.commander_tel),
              context);
        } else {
          AppStyle().toast_text('บันทึกข้อมูลไม่สำเร็จ กรุณาลองอีกครั้ง');
        }
      }
    } catch (e) {
      AppStyle().open_loading();
    }
  }

  Widget toggle_btn(_var, name) {
    return ToggleButtons(
      direction: Axis.horizontal,
      onPressed: (int index) {
        setState(() {
          for (int i = 0; i < _var.length; i++) {
            _var[i] = i == index;
          }
          setCheckUp(name, _var);
        });
      },
      borderRadius: const BorderRadius.all(Radius.circular(8)),
      selectedBorderColor: Colors.green[700],
      selectedColor: Colors.white,
      fillColor: Colors.green[200],
      color: Colors.green[400],
      constraints: const BoxConstraints(
        minHeight: 30.0,
        minWidth: 45.0,
      ),
      isSelected: _var,
      children: _isOK,
    );
    // checkList();
  }

  setCheckUp(name, value) {
    if (name == "selectedClean") {
      _selectedClean = value;
    } else if (name == "selectedMachine") {
      _selectedMachine = value;
    } else if (name == "selectedChassis") {
      _selectedChassis = value;
    } else if (name == "selectedElectric") {
      _selectedElectric = value;
    } else if (name == "selectedMonitor") {
      _selectedMonitor = value;
    } else if (name == "selectedGear") {
      _selectedGear = value;
    } else if (name == "selectedAsset") {
      _selectedAsset = value;
    } else {
      _selectedLower = value;
    }
  }

  Widget checkList() {
    return Row(
      children: <Widget>[
        Expanded(
          flex: 3,
          child: Container(
              child: Center(
            child: Column(
              children: [
                AppStyle().text("เครื่องยนต์", 12),
                toggle_btn(_selectedMachine, "selectedMachine"),
                AppStyle().text("ระบบไฟฟ้า", 12),
                toggle_btn(_selectedElectric, "selectedElectric"),
                AppStyle().text("ระบบเกียร์", 12),
                toggle_btn(_selectedGear, "selectedGear"),
                AppStyle().text("ช่วงล่าง", 12),
                toggle_btn(_selectedLower, "selectedLower"),
              ],
            ),
          )),
        ),
        Expanded(
          flex: 4,
          child: Container(
            child: Center(
              child: Image.asset("assets/images/img_car.PNG"),
            ),
          ),
        ),
        Expanded(
          flex: 3,
          child: Container(
              child: Center(
            child: Column(
              children: [
                AppStyle().text("ความสะอาด", 12),
                toggle_btn(_selectedClean, "selectedClean"),
                AppStyle().text("ตัวถังรถ", 12),
                toggle_btn(_selectedChassis, "selectedChassis"),
                AppStyle().text("จอแสดงผล", 12),
                toggle_btn(_selectedMonitor, "selectedMonitor"),
                AppStyle().text("อุปกรณ์ประจำรถ", 12),
                toggle_btn(_selectedAsset, "selectedAsset"),
              ],
            ),
          )),
        ),
      ],
    );
  }
}
