import 'dart:convert';
import 'dart:io';

import 'package:edriver/api/api.dart';
import 'package:edriver/screen/summary_tab.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../api/job_api.dart';
import '../api/location.dart';
import '../theme/app_style.dart';
import '../theme/element_widget.dart';

class costFuel extends StatefulWidget {
  final costTypeID;
  final job_no;
  final commander_tel;
  final reserver_detail_jobID;
  const costFuel(this.reserver_detail_jobID, this.job_no, this.commander_tel,
      this.costTypeID,
      {super.key});

  @override
  State<costFuel> createState() => _costFuelState();
}

class _costFuelState extends State<costFuel> {
  var _is_edit = false;

  var _date_init = null;
  var _internal_no, _plate_no, _carID = "";
  var _Pay, _fuel, _dr_car;
  final CostFuelController = TextEditingController();
  final FuelLitreController = TextEditingController();
  final LocationController = TextEditingController();
  final DateController = TextEditingController();
  final BillNoController = TextEditingController();
  final mileController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  //image
  var url_pic;
  String? base64String = "";
  File? imageFile;
  PickedFile? pickedFile;

  List<Widget> _fuel_by = <Widget>[
    Text('ฟลีทการ์ด', style: TextStyle(fontSize: 14)),
    Text('ปั๊ม กฟผ.', style: TextStyle(fontSize: 14)),
    Text('เงินสด', style: TextStyle(fontSize: 14))
  ];
  List<Widget> _fuel_type = <Widget>[
    Text('NGV', style: TextStyle(fontSize: 14)),
    Text('โซฮอล์', style: TextStyle(fontSize: 14)),
    Text('ดีเซล', style: TextStyle(fontSize: 14)),
    Text('เบนซิน', style: TextStyle(fontSize: 14)),
    Text('ไฟฟ้า', style: TextStyle(fontSize: 14)),
    Text('อื่นๆ', style: TextStyle(fontSize: 14))
  ];
  List<bool> _selectedFuelBy = <bool>[false, false, false];
  List<bool> _selectedFuelType = <bool>[
    false,
    false,
    false,
    false,
    false,
    false
  ];

  @override
  void initState() {
    super.initState();
  }

  imageFromCamera() async {
    PickedFile? pickedFile = await ImagePicker()
        .getImage(source: ImageSource.camera, imageQuality: 100);
    if (pickedFile != null) {
      setState(() {
        imageFile = File(pickedFile.path);
      });
      List<int> imageBytes = File(pickedFile.path).readAsBytesSync();
      base64String = base64Encode(imageBytes);
    } else {
      return null;
    }
  }
  
  browseImage() async {
  final ImagePicker _picker = ImagePicker();
  final XFile? pickedFile = await _picker.pickImage(source: ImageSource.gallery);
  
  if (pickedFile != null) {
      setState(() {
        imageFile = File(pickedFile.path);
      });
      List<int> imageBytes = File(pickedFile.path).readAsBytesSync();
      base64String = base64Encode(imageBytes);
  } else {

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('No image selected'),
      ),
    );
  }
}

  get_fuelCost(data) async {
    if (widget.costTypeID != "") {
      _is_edit = true;
      _date_init = data["reserveDate"];
      BillNoController.text =
          (data["receipt_no"] != null) ? data["receipt_no"] : "";
      mileController.text = data["mile_before"];

      _Pay = data["pay_by"];

      if (_Pay == "f") {
        _selectedFuelBy = [true, false, false];
      } else if (_Pay == "p") {
        _selectedFuelBy = [false, true, false];
      } else if (_Pay == "c") {
        _selectedFuelBy = [false, false, true];
      }

      if (data["ngv"] != null) {
        _fuel = "n";
        _selectedFuelType = [true, false, false, false, false, false];
        FuelLitreController.text = data["ngv"];
      } else if (data["sohol_95"] != null) {
        _selectedFuelType = [false, true, false, false, false, false];
        _fuel == "s";
        FuelLitreController.text = data["sohol_95"];
      } else if (data["diesel"] != null) {
        _fuel == "d";
        _selectedFuelType = [false, false, true, false, false, false];
        FuelLitreController.text = data["diesel"];
      } else if (data["bensin"] != null) {
        _fuel == "b";
        _selectedFuelType = [false, false, false, true, false, false];
        FuelLitreController.text = data["bensin"];
      } else if (data["electric"] != null) {
        _fuel == "e";
        _selectedFuelType = [false, false, false, false, true, false];
        FuelLitreController.text = data["electric"];
      } else if (data["other_fuel"] != null) {
        _fuel == "o";
        _selectedFuelType = [false, false, false, false, false, true];
        FuelLitreController.text = data["other_fuel"];
      }

      CostFuelController.text = data["amount"];
      DateController.text = _date_init;
      LocationController.text = data["fuel_location"];
      url_pic = data["attach_file"];
    } else {
      _is_edit = false;
      _date_init = null;
      LocationController.text = await Location().GetAddressFromLatLong();
      url_pic = null;
    }
    _carID = data["carID"];
    _internal_no = data["internal_no"];
    _plate_no = data["full_plate_no"];
  }

  @override
  Widget build(BuildContext context) {
    var param = {};
    if (widget.costTypeID != "") {
      _is_edit = true;
      param = {"reserve_costID": widget.costTypeID, "cost_type": "f"};
    } else {
      param = {
        "reserve_detail_jobID": widget.reserver_detail_jobID,
        "cost_type": "f"
      };
    }

    return FutureBuilder(
        future: Job_api().get_cost(param),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return AppStyle().open_loading();
          } else {
            get_fuelCost(snapshot.data);
            return _frmCostFuel(snapshot.data);
          }
        });
  }

  Widget toggle_btnBy(_var, _select_choice, wd) {
    return ToggleButtons(
      direction: Axis.horizontal,
      onPressed: (int index) {
        setState(() {
          for (int i = 0; i < _var.length; i++) {
            _var[i] = i == index;
          }
          if (_var[0] == true) {
            _Pay = "f";
          } else if (_var[1] == true) {
            _Pay = "p";
          } else if (_var[2] == true) {
            _Pay = "c";
          }
        });
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

  Widget toggle_btnFuel(_var, _select_choice, wd) {
    return ToggleButtons(
      direction: Axis.horizontal,
      onPressed: (int index) {
        setState(() {
          for (int i = 0; i < _var.length; i++) {
            _var[i] = i == index;
          }
          if (_var[0] == true) {
            _fuel = "n";
          }
          if (_var[1] == true) {
            _fuel = "s";
          }
          if (_var[2] == true) {
            _fuel = "d";
          }
          if (_var[3] == true) {
            _fuel = "b";
          }
          if (_var[4] == true) {
            _fuel = "e";
          }
          if (_var[5] == true) {
            _fuel = "o";
          }
        });
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

  Widget _frmCostFuel(data) {
    // print(data);
    return Scaffold(
      appBar: AppBar(
        title: Text("บันทึกค่าเชื้อเพลิง"),
      ),
      body: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Container(
            margin: const EdgeInsets.fromLTRB(10, 10, 10, 10),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AppStyle().space_box(15),
                AppStyle().row_detail("หมายเลขรถ :", data["internal_no"], 16),
                AppStyle().space_box(15),
                AppStyle().row_detail("ทะเบียนรถ : ", data["plate_no"], 16),
                element_widget()
                    .textBox_number(BillNoController, 'เลขที่ใบเสร็จ', false),
                AppStyle().space_box(15),
                element_widget()
                    .textBox_number(mileController, 'เลขไมล์ก่อนเติม'),
                AppStyle().space_box(15),
                Row(
                  children: [
                    AppStyle().text("จ่ายโดย :"),
                    element_widget().text_require(),
                  ],
                ),
                AppStyle().space_box(15),
                Center(child: toggle_btnBy(_selectedFuelBy, _fuel_by, 100.0)),
                AppStyle().space_box(15),
                Row(
                  children: [
                    AppStyle().text("ประเภทเชื้อเพลิง :"),
                    element_widget().text_require(),
                  ],
                ),
                AppStyle().space_box(15),
                Center(
                    child: toggle_btnFuel(_selectedFuelType, _fuel_type, 60.0)),
                AppStyle().space_box(15),
                element_widget()
                    .textBox_number(FuelLitreController, 'ปริมาณ (ลิตร/kWh)'),
                element_widget()
                    .textBox_number(CostFuelController, 'ค่าเชื้อเพลิง (บาท)'),
                AppStyle().space_box(15),
                element_widget().textbox_string(
                    LocationController, "สถานที่เติมเชื้อเพลิง", true, false),
                AppStyle().space_box(15),
                element_widget().textbox_calendar_free(
                    DateController, "วันที่ตามใบเสร็จ", _date_init, context),
                AppStyle().space_box(35),
                AppStyle().text("ถ่ายรูปใบเสร็จ", 18, Colors.grey),
                element_widget().btn_image(imageFromCamera),
                AppStyle().space_box(15),
                AppStyle().text("เลือกรูปใบเสร็จ", 18, Colors.grey),
                element_widget().btn_pickimage(browseImage),              
                element_widget().showPic(imageFile, url_pic, false),
                AppStyle().space_box(20),
                btn(),
                AppStyle().space_box(100),
              ],
            ),
          ),
        ),
      ),
      floatingActionButton: AppStyle().getBtnMenu(widget.reserver_detail_jobID,
          widget.job_no, widget.commander_tel, context),
      bottomNavigationBar: AppStyle().butoom_bar(context, 2),
    );
  }

  btn() {
    if (_is_edit) {
      return element_widget().btn_delete(delete_cost);
    } else {
      return element_widget()
          .btn_submit(_is_edit, "ค่าเชื้อเพลิง", saveFuelCost);
    }
  }

  delete_cost() async {
    AppStyle().open_loading();
    var param = {"reserve_costID": widget.costTypeID, "cost_type": "f"};

    final result = await Job_api().delete_cost(param);

    AppStyle().toast_text_green("ลบข้อมูลเรียบร้อย");
    Navigator.of(context).pop();
    Navigator.of(context).pop();
    AppStyle().link_to(
        summarytabScreen(
            widget.reserver_detail_jobID, widget.job_no, widget.commander_tel),
        context);
  }

  saveFuelCost() async {
    var param;

    if (_Pay != "" && _Pay != null) {
      if (_fuel != "") {
        if (_formKey.currentState!.validate()) {
          AppStyle().loading(context);
          param = {
            "reserve_detail_jobID": widget.reserver_detail_jobID,
            "mile_before": mileController.text,
            "carID": _carID,
            "amount": CostFuelController.text,
            "cost_type": "f",
            "pay_by": _Pay,
            "fuel_location": LocationController.text,
            "reserveDate": DateController.text
          };
          if (base64String != "") {
            param["attach_file"] = base64String;
          }
          param["receipt_no"] = BillNoController.text;
          if (_fuel == "n") {
            param["ngv"] = FuelLitreController.text;
          }
          if (_fuel == "s") {
            param["sohol_95"] = FuelLitreController.text;
          }
          if (_fuel == "d") {
            param["diesel"] = FuelLitreController.text;
          }
          if (_fuel == "b") {
            param["bensin"] = FuelLitreController.text;
          }
          if (_fuel == "e") {
            param["electric"] = FuelLitreController.text;
          }
          if (_fuel == "o") {
            param["other_fuel"] = FuelLitreController.text;
          }

          if (_is_edit) {
            param["reserve_costID"] = widget.costTypeID;
          }
          //   print(param);
          var res = await Job_api().costRecord(param);
          //    print(res);

          AppStyle().toast_text_green("บันทึกข้อมูลเรียบร้อย");
          Navigator.of(context).pop();
          Navigator.of(context).pop();
          AppStyle().link_to(
              summarytabScreen(widget.reserver_detail_jobID, widget.job_no,
                  widget.commander_tel),
              context);
        }
      } else {
        typefuelErr();
      }
    } else {
      typePayByErr();
    }
  }

  typePayByErr() {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            scrollable: true,
            title: AppStyle().text('กรุณา ระบุจ่ายโดย', 16, Colors.red),
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

  typefuelErr() {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            scrollable: true,
            title:
                AppStyle().text('กรุณา ระบุประเภทเชื้อเพลิง', 16, Colors.red),
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
}
