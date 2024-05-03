import 'dart:convert';
import 'dart:io';

import 'package:edriver/screen/summary_tab.dart';
import 'package:edriver/theme/app_style.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../api/job_api.dart';
import '../api/location.dart';
import '../theme/element_widget.dart';

class costOther extends StatefulWidget {
  final reserve_detail_jobID;
  final job_no;
  final commander_tel;
  final costTypeID;
  const costOther(this.reserve_detail_jobID, this.job_no, this.commander_tel,
      this.costTypeID,
      {super.key});

  @override
  State<costOther> createState() => _costOtherState();
}

class _costOtherState extends State<costOther> {
  final _form = GlobalKey<FormState>();
  var _is_edit = false;

  var _dr_job, _dr_cost = {};
  var _address = "";
  final CostOtherController = TextEditingController();
  final LocationController = TextEditingController();
  final DateController = TextEditingController();
  final RemarkController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  var _date_init, _start_date, _end_date;

  //image
  var url_pic;
  String? base64String = "";
  File? imageFile;
  PickedFile? pickedFile;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var param = {};
    if (widget.costTypeID != "") {
      _is_edit = true;
      param = {
        "reserve_detail_jobID": widget.reserve_detail_jobID,
        "reserve_costID": widget.costTypeID,
        "cost_type": "o"
      };
    } else {
      param = {"reserve_detail_jobID": widget.reserve_detail_jobID};
    }
    return FutureBuilder(
        future: Job_api().get_cost(param),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return AppStyle().open_loading();
          } else {
            //get_job_detail();
            //get_otherCost();
            return _frmCostOther(snapshot.data);
          }
        });
  }

  get_otherCost(data) async {
    if (widget.costTypeID != "") {
      _is_edit = true;
      _date_init = data["date"];
      CostOtherController.text = data["price"];
      LocationController.text = data["location"];
      RemarkController.text = data["remark"];
      DateController.text = _date_init;
      url_pic = data["attach_file"];
    } else {
      LocationController.text = await Location().GetAddressFromLatLong();
      _is_edit = false;
      url_pic = null;
      var dt_car = await Job_api().get_job_detail(widget.reserve_detail_jobID);
      var dr = dt_car[0];
    }
  }

  Widget _frmCostOther(data) {
    // get_job_detail();
    get_otherCost(data);

    return Scaffold(
      appBar: AppBar(
        title: Text("บันทึกค่าใช้จ่ายอื่น ๆ"),
      ),
      body: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Container(
            margin: const EdgeInsets.fromLTRB(20, 10, 10, 10),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                element_widget().textBox_number(
                    CostOtherController, 'ค่าใช้จ่ายอื่นๆ (บาท)'),
                AppStyle().space_box(15),
                element_widget()
                    .textbox_string(RemarkController, "รายละเอียดการซื้อ/จ้าง"),
                AppStyle().space_box(15),
                element_widget().textbox_string(
                    LocationController, "สถานที่ชำระเงิน", true),
                AppStyle().space_box(15),
                element_widget().textbox_calendar_free(
                    DateController, "วันที่ชำระเงิน", _date_init, context),
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
      return element_widget().row_tmp_3(
          element_widget().btn_edit(saveOtherCost),
          Container(),
          element_widget().btn_delete(delete_cost),
          [4, 1, 4]);
    } else {
      return element_widget()
          .btn_submit(_is_edit, "ค่าใช้จ่ายอื่นๆ", saveOtherCost);
    }
  }

  delete_cost() async {
    AppStyle().open_loading();
    var param = {"reserve_costID": widget.costTypeID, "cost_type": "o"};
    final result = await Job_api().delete_cost(param);
    if (result == "success") {
      AppStyle().toast_text_green("ลบข้อมูลเรียบร้อย");
      Navigator.of(context).pop();
      Navigator.of(context).pop();
      AppStyle().link_to(
          summarytabScreen(
              widget.reserve_detail_jobID, widget.job_no, widget.commander_tel),
          context);
    } else {
      element_widget().toastSaveIncomplete();
    }
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

  saveOtherCost() async {
    AppStyle().loading(context);
    var param;
    if (_formKey.currentState!.validate()) {
      param = {
        "reserve_detail_jobID": widget.reserve_detail_jobID,
        "remark": RemarkController.text,
        "location": LocationController.text,
        "price": CostOtherController.text,
        "date": DateController.text,
        "cost_type": "o",
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
          summarytabScreen(
              widget.reserve_detail_jobID, widget.job_no, widget.commander_tel),
          context);
    } else {
      AppStyle().close_load(context);
    }
  }
}
