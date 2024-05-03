import 'dart:convert';
import 'dart:io';

import 'package:edriver/api/driver_api.dart';
import 'package:edriver/screen/cost_record.dart';

import 'package:edriver/theme/app_style.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../api/api.dart';
import '../api/job_api.dart';
import '../api/location.dart';
import '../theme/element_widget.dart';

class costTaxi extends StatefulWidget {
  final reserve_detail_jobID;
  final job_no;
  final commander_tel;
  final costTypeID;

  const costTaxi(this.reserve_detail_jobID, this.job_no, this.commander_tel,
      this.costTypeID,
      {super.key});

  @override
  State<costTaxi> createState() => _costTaxiState();
}

class _costTaxiState extends State<costTaxi> {
  final _form = GlobalKey<FormState>();

  var _is_edit = false;

  var _dr_job, _dr_cost = {};
  var _userLocation, _date_init = "";
  var _Egat_location = "กฟผ. บางกรวย";
  final CostTaxiController = TextEditingController();
  final LocationController = TextEditingController();
  final DateController = TextEditingController();
  final LocationToController = TextEditingController();
  var _txType = "";
  final _formKey = GlobalKey<FormState>();
  List<Widget> _taxi_type = <Widget>[
    Text('ขามา', style: TextStyle(fontSize: 14)),
    Text('ขากลับ', style: TextStyle(fontSize: 14)),
  ];
  List<bool> _selectedTaxiType = <bool>[false, false];

  //image
  var url_pic;
  String? base64String = "";
  File? imageFile;
  PickedFile? pickedFile;

  @override
  void initState() {
    geUserLocation();
    get_TaxiCost();
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

  geUserLocation() async {
    var _dr = await driver_api().get_driver_profile();
    _userLocation = AppStyle().convertNullToDash(_dr["address"].toString());
  }

  get_TaxiCost() async {
    _is_edit = false;
    if (widget.costTypeID != "") {
      _is_edit = true;
      var param = {"reserve_costID": widget.costTypeID, "cost_type": "tx"};
      _dr_cost = await Job_api().get_cost(param);
      _date_init = _dr_cost["date"];
      _txType = _dr_cost["location_type"];
      setState(() {
        if (_txType == "d") {
          _selectedTaxiType = [true, false];
        } else {
          _selectedTaxiType = [false, true];
        }
      });

      CostTaxiController.text = _dr_cost["price"];
      LocationController.text = _dr_cost["location"];
      LocationToController.text = _dr_cost["location_to"];
      DateController.text = _date_init;
      url_pic = _dr_cost["attach_file"];
    } else {
      _date_init = API().date_now();
      LocationController.text = await Location().GetAddressFromLatLong();
      url_pic = null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: Job_api().get_job_detail(widget.reserve_detail_jobID),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return AppStyle().open_loading();
          } else {
            return _frmTaxi(snapshot.data);
          }
        });
  }

  Widget _frmTaxi(data) {
    var row = data[0];

    return Scaffold(
      appBar: AppBar(
        title: Text("บันทึกค่า Taxi"),
      ),
      body: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Container(
            margin: const EdgeInsets.fromLTRB(20, 10, 10, 10),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AppStyle().space_box(15),
                Row(
                  children: [
                    AppStyle().text("การเดินทาง :"),
                    element_widget().text_require()
                  ],
                ),
                AppStyle().space_box(15),
                Center(child: toggle_btn(_selectedTaxiType, _taxi_type, 100.0)),
                element_widget()
                    .textBox_number(CostTaxiController, 'ค่ารถ Taxi (บาท)'),
                AppStyle().space_box(15),
                element_widget()
                    .textbox_string(LocationController, "สถานที่ต้นทาง"),
                AppStyle().space_box(15),
                element_widget()
                    .textbox_string(LocationToController, "สถานปลายทาง"),
                AppStyle().space_box(15),
                element_widget().textbox_calendar(
                    DateController,
                    "วันที่ชำระเงิน",
                    _date_init,
                    row["start_date"],
                    row["end_date"],
                    context),
                AppStyle().space_box(15),
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
      floatingActionButton: AppStyle().getBtnMenu(widget.reserve_detail_jobID,
          widget.job_no, widget.commander_tel, context),
      bottomNavigationBar: AppStyle().butoom_bar(context, 2),
    );
  }

  btn() {
    if (_is_edit) {
      return element_widget().btn_delete(delete_cost);
    } else {
      return element_widget().btn_submit(_is_edit, "ค่ารถ Taxi", saveTaxiCost);
    }
  }

  delete_cost() async {
    AppStyle().open_loading();
    var param = {"reserve_costID": widget.costTypeID, "cost_type": "tx"};
    final result = await Job_api().delete_cost(param);
    if (result == "success") {
      AppStyle().toast_text_green("ลบข้อมูลเรียบร้อย");
      Navigator.of(context).pop();
      Navigator.of(context).pop();
      AppStyle().link_to(
          costRecordScreen(
              widget.reserve_detail_jobID, widget.job_no, widget.commander_tel),
          context);
    } else {
      element_widget().toastSaveIncomplete();
    }
  }

  Widget toggle_btn(_var, _select_choice, wd) {
    return ToggleButtons(
      direction: Axis.horizontal,
      onPressed: (int index) {
        setState(() {
          for (int i = 0; i < _var.length; i++) {
            _var[i] = i == index;
          }

          if (_var[0] == true) {
            LocationController.text = _userLocation;
            LocationToController.text = _Egat_location;
            _txType = "d";
          } else {
            LocationController.text = _Egat_location;
            LocationToController.text = _userLocation;
            _txType = "r";
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

  saveTaxiCost() async {
    Map<String, dynamic> param;

    if (_txType != "") {
      if (_formKey.currentState!.validate()) {
        AppStyle().loading(context);
        param = {
          "reserve_detail_jobID": widget.reserve_detail_jobID,
          "location_to": LocationToController.text,
          "location": LocationController.text,
          "price": CostTaxiController.text,
          "date": DateController.text,
          "cost_type": "tx",
          "location_type": _txType
        };
        if (_is_edit) {
          param["reserve_costID"] = widget.costTypeID;
        }

        if (base64String != "") {
          param["attach_file"] = base64String;
        }

        final result = await Job_api().costRecord(param);

        AppStyle().toast_text_green("บันทึกข้อมูลเรียบร้อย");
        Navigator.of(context).pop();
        Navigator.of(context).pop();
        AppStyle().link_to(
            costRecordScreen(widget.reserve_detail_jobID, widget.job_no,
                widget.commander_tel),
            context);
      }
    } else {
      typeTaxiErr();
    }
  }

  typeTaxiErr() {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            scrollable: true,
            title: AppStyle()
                .text('กรุณา ระบุการเดินทาง(ขามา/ขากลับ)', 16, Colors.red),
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
