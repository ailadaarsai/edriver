import 'package:edriver/screen/summary_tab.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/material.dart';

import '../api/api.dart';
import '../api/job_api.dart';

import '../theme/app_style.dart';
import '../theme/element_widget.dart';

class costHotel extends StatefulWidget {
  final job_no;
  final commander_tel;
  final reserver_detail_jobID;
  const costHotel(this.reserver_detail_jobID, this.job_no, this.commander_tel,
      {super.key});

  @override
  State<costHotel> createState() => _costHotelState();
}

class _costHotelState extends State<costHotel> {
  final _form = GlobalKey<FormState>();
  var _is_edit;
  final cntDateController = TextEditingController();
  final locationController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  var _cntDate, _location;
  int _max_cnt = 0;
  void initState() {
    super.initState();
  }

  getDatejob() {}
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: Job_api().get_job_detail_close(widget.reserver_detail_jobID),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return AppStyle().open_loading();
          } else {
            sethotelCnt(snapshot.data);
            return _hotelSave(snapshot.data);
          }
        });
  }

  sethotelCnt(data) {
    var _dr = data;

    _max_cnt = int.parse(_dr["cnt_date"]) - 1;

    if (_dr["cnt_real_hotel_cost"] != null &&
        _dr["cnt_real_hotel_cost"].toString() != "0") {
      _cntDate = _dr["cnt_real_hotel_cost"];
      cntDateController.text = _cntDate.toString();
      locationController.text = _dr["location_hotel"];
    } else {
      cntDateController.text = "";
    }
  }

  Widget _hotelSave(data) {
    return Scaffold(
      appBar: AppBar(
        title: Text("บันทึกค่าที่พัก"),
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
                    cntDateController, 'จำนวนวันที่เข้าพัก (วัน)'),
                element_widget().textbox_string(
                    locationController, 'สถานที่พัก (อำเภอ / จังหวัด)'),
                AppStyle().space_box(20),
                btn(),
                AppStyle().space_box(20),
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
    return element_widget().btn_submit(false, "", save_hotel_cost);
  }

  save_hotel_cost() async {
    AppStyle().loading(context);
    var param;
    if (_formKey.currentState!.validate()) {
      param = {
        "reserve_detail_jobID": widget.reserver_detail_jobID,
        "cnt_real_hotel_cost": cntDateController.text,
        "location_hotel": locationController.text
      };
    }
    if (int.parse(cntDateController.text) > _max_cnt) {
      AppStyle().close_load(context);
      AppStyle().toast_text("ไม่สามารถกรอกได้มากกว่า $_max_cnt วัน");
    } else {
      final result = await API().callApi("save_hotel_cost", param);
      AppStyle().toast_text_green("บันทึกข้อมูลเรียบร้อย");
      Navigator.of(context).pop();
      AppStyle().link_to(
          summarytabScreen(widget.reserver_detail_jobID, widget.job_no,
              widget.commander_tel),
          context);
    }
  }
}
