import 'dart:convert';
import 'dart:io';
import 'package:edriver/api/api.dart';

import 'package:edriver/screen/summary_tab.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/material.dart';

import 'package:image_picker/image_picker.dart';
import '../api/job_api.dart';

import '../theme/app_style.dart';
import '../theme/element_widget.dart';

class costTollway extends StatefulWidget {
  final reserve_detail_jobID;
  final job_no;
  final commander_tel;
  final costTypeID;

  const costTollway(this.reserve_detail_jobID, this.job_no, this.commander_tel,
      this.costTypeID,
      {super.key});

  @override
  State<costTollway> createState() => _costTollwayState();
}

class _costTollwayState extends State<costTollway> {
  bool _is_edit = false;
  var _price, _receipt_num = "";
  final _formKey = GlobalKey<FormState>();
  final TollWayPriceController = TextEditingController();
  final receiptController = TextEditingController();
  var _dr_cost = {};

  //image
  var url_pic;
  String? base64String = "";
  File? imageFile;
  PickedFile? pickedFile;

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

  @override
  Widget build(BuildContext context) {
    var param = {};
    if (widget.costTypeID != "") {
      _is_edit = true;
      param = {
        "reserve_detail_jobID": widget.reserve_detail_jobID,
        "reserve_costID": widget.costTypeID,
        "cost_type": "t"
      };
    } else {
      param = {"reserve_detail_jobID": widget.reserve_detail_jobID};
    }
print(param);
    return FutureBuilder(
        future: Job_api().get_cost(param),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return AppStyle().open_loading();
          } else {
            // print(snapshot.data);
    
            getTolway(snapshot.data);
           
            return sc_tollway();
          }
        });
  }

  getTolway(data) {

    if (data != null && data.toString() !="[]") {
  
      _is_edit = true;
      _price = data["price"];
      _receipt_num = data["receipt_num"];
      receiptController.text = _receipt_num;
      TollWayPriceController.text = _price;
      url_pic = data["attach_file"];
    } else {

      _is_edit = false;
      url_pic = null;
    }
  }

  sc_tollway() {
    return Scaffold(
      appBar: AppBar(
        title: Text("บันทึกค่าทางด่วน"),
      ),
      body: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Container(
            margin: const EdgeInsets.fromLTRB(20, 10, 10, 10),
            child: _frmCostTollway(),
          ),
        ),
      ),
      floatingActionButton: AppStyle().getBtnMenu(widget.reserve_detail_jobID,
          widget.job_no, widget.commander_tel, context),
      bottomNavigationBar: AppStyle().butoom_bar(context, 2),
    );
  }

  Widget _frmCostTollway() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        element_widget().textBox_number(
            TollWayPriceController, 'ยอดรวมค่าทางด่วนทั้งใบงาน (บาท)'),
        AppStyle().space_box(15),
        element_widget().textBox_number(
          receiptController,
          "จำนวนใบเสร็จ (ฉบับ)",
        ),
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
    );
  }

  btn() {
    if (_is_edit) {
      return element_widget().row_tmp_3(
          element_widget().btn_edit(save_tollWayCost),
          Container(),
          element_widget().btn_delete(delete_cost),
          [4, 1, 4]);
    } else {
      return element_widget()
          .btn_submit(_is_edit, "ค่าทางด่วน", save_tollWayCost);
    }
  }

  delete_cost() async {
    AppStyle().open_loading();
    var param = {"reserve_costID": widget.costTypeID, "cost_type": "t"};
    final result = await Job_api().delete_cost(param);
    if (result == "success") {
      AppStyle().toast_text_green("ลบข้อมูลเรียบร้อย");
      Navigator.of(context).pop();
      AppStyle().link_to(
          summarytabScreen(
              widget.reserve_detail_jobID, widget.job_no, widget.commander_tel),
          context);
    } else {
      element_widget().toastSaveIncomplete();
    }
  }

  save_tollWayCost() async {

    var param;

    AppStyle().loading(context);
    
    if (_formKey.currentState!.validate()) {
      var param = {
        "reserve_detail_jobID": widget.reserve_detail_jobID,
        "receipt_num": receiptController.text,
        "price": TollWayPriceController.text,
        "cost_type": "t",
      };
      if (base64String != "") {
        param["attach_file"] = base64String;
      }
      if (widget.costTypeID != "") {
        param["reserve_costID"] = widget.costTypeID;
      }

      final result = await API().callApi("cost_record", param);

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
