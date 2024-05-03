import 'dart:core';

import 'package:edriver/screen/summary_tab.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/material.dart';

import '../api/api.dart';
import '../api/job_api.dart';

import '../theme/app_style.dart';
import '../theme/element_widget.dart';

class costWage extends StatefulWidget {
  final job_no;
  final commander_tel;
  final reserver_detail_jobID;
  const costWage(this.reserver_detail_jobID, this.job_no, this.commander_tel,
      {super.key});

  @override
  State<costWage> createState() => _costWageState();
}

class _costWageState extends State<costWage> {
  final _form = GlobalKey<FormState>();
  var _is_edit;
  int _max_cnt = 0;
  var _cntWage = 0;
  final cntDateController = TextEditingController();
  // final locationController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: Job_api().get_job_detail_close(widget.reserver_detail_jobID),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return AppStyle().open_loading();
          } else {
            set_cnt_wage(snapshot.data);
            return _wageSave(snapshot.data);
          }
        });
  }

  set_cnt_wage(data) {
    _max_cnt = int.parse(data["cnt_date"]);
    if (data["cnt_real_wage_cost"] != null) {
      var cntDate = data["cnt_real_wage_cost"];
      cntDateController.text = cntDate.toString();
    } else {
      cntDateController.text = "";
    }
  }

  Widget _wageSave(data) {
    var row = data;

    //print(row["cnt_real_wage_cost"]);
    return Scaffold(
      appBar: AppBar(
        title: Text("บันทึกค่าเบี้ยเลี้ยง"),
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
                element_widget().textBox_number(
                    cntDateController, 'จำนวนวันที่เบิกเบี้ยเลี้ยง'),
                AppStyle().space_box(20),
                btn(),
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
    return element_widget().btn_submit(false, "", save_wage_cost);
  }

  save_wage_cost() async {
    AppStyle().loading(context);
    var param;
    var cnt_save = int.parse(cntDateController.text);
    if (cnt_save > _max_cnt) {
      AppStyle().close_load(context);
      AppStyle()
          .toast_text("ไม่สามารถกรอกได้มากกว่า" + _max_cnt.toString() + " วัน");
    } else {
      if (_formKey.currentState!.validate()) {
        param = {
          "reserve_detail_jobID": widget.reserver_detail_jobID,
          "cnt_real_wage_cost": cntDateController.text,
        };
      }

      final result = await API().callApi("save_wage_cost", param);
      AppStyle().toast_text_green("บันทึกข้อมูลเรียบร้อย");
      Navigator.of(context).pop();
      Navigator.of(context).pop();
      AppStyle().link_to(
          summarytabScreen(widget.reserver_detail_jobID, widget.job_no,
              widget.commander_tel),
          context);
    }
  }
}
