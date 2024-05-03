import 'dart:convert';
import 'dart:io';

import 'package:edriver/screen/summary_tab.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../api/job_api.dart';

import '../theme/app_style.dart';
import '../theme/element_widget.dart';

class costCarPark extends StatefulWidget {
  final reserver_detail_jobID;
  final job_no;
  final commander_tel;
  final costTypeID;
  const costCarPark(this.reserver_detail_jobID, this.job_no, this.commander_tel,
      this.costTypeID,
      {super.key});

  @override
  State<costCarPark> createState() => _costCarParkState();
}

class _costCarParkState extends State<costCarPark> {
  var _is_edit = false;

  final CostCarParkController = TextEditingController();
  final receiptController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  //image
  var url_pic;
  String? base64String = "";
  File? imageFile;
  PickedFile? pickedFile;

  @override
  Widget build(BuildContext context) {
    var param = {};
    if (widget.costTypeID != "") {
      _is_edit = true;
      param = {"reserve_costID": widget.costTypeID, "cost_type": "c"};
    } else {
      param = {"reserve_detail_jobID": widget.reserver_detail_jobID};
    }

    return FutureBuilder(
        future: Job_api().get_cost(param),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return AppStyle().open_loading();
          } else {
            get_car_park(snapshot.data);
            return _frmCostCarPark();
          }
        });
  }

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

  get_car_park(data) async {
    if (widget.costTypeID != "") {
      _is_edit = true;
      receiptController.text = data["receipt_num"];
      CostCarParkController.text = data["price"];
      url_pic = data["attach_file"];
    } else {
      _is_edit = false;
      url_pic = null;
    }
  }

  Widget _frmCostCarPark() {
    return Scaffold(
      appBar: AppBar(
        title: Text("บันทึกค่าที่จอดรถ"),
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
                    CostCarParkController, 'ยอดรวมค่าที่จอดรถ (บาท)'),
                AppStyle().space_box(15),
                element_widget()
                    .textBox_number(receiptController, "จำนวนใบเสร็จ (ฉบับ)"),
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
      floatingActionButton: AppStyle().getBtnMenu(widget.reserver_detail_jobID,
          widget.job_no, widget.commander_tel, context),
      bottomNavigationBar: AppStyle().butoom_bar(context, 2),
    );
  }

  btn() {
    if (_is_edit) {
      return element_widget().row_tmp_3(element_widget().btn_edit(saveCarPark),
          Container(), element_widget().btn_delete(delete_cost), [4, 1, 4]);
    } else {
      return element_widget().btn_submit(_is_edit, "ค่าที่จอดรถ", saveCarPark);
    }
  }

  delete_cost() async {
    AppStyle().open_loading();
    var param = {"reserve_costID": widget.costTypeID, "cost_type": "c"};
    final result = await Job_api().delete_cost(param);
    if (result == "success") {
      AppStyle().toast_text_green("ลบข้อมูลเรียบร้อย");
      Navigator.of(context).pop();
      Navigator.of(context).pop();
      AppStyle().link_to(
          summarytabScreen(widget.reserver_detail_jobID, widget.job_no,
              widget.commander_tel),
          context);
    } else {
      element_widget().toastSaveIncomplete();
    }
  }

  saveCarPark() async {
    var param;
    AppStyle().loading(context);
    if (_formKey.currentState!.validate()) {
      param = {
        "reserve_detail_jobID": widget.reserver_detail_jobID,
        "receipt_num": receiptController.text,
        "price": CostCarParkController.text,
        "cost_type": "c",
      };
      if (widget.costTypeID != null) {
        param["reserve_costID"] = widget.costTypeID;
      }
      if (base64String != "") {
        param["attach_file"] = base64String;
      }

      await Job_api().costRecord(param);

      AppStyle().toast_text_green("บันทึกข้อมูลเรียบร้อย");
      Navigator.of(context).pop();
      Navigator.of(context).pop();
      AppStyle().link_to(
          summarytabScreen(widget.reserver_detail_jobID, widget.job_no,
              widget.commander_tel),
          context);
      //}
    } else {
      AppStyle().close_load(context);
    }
  }
}
