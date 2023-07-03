import 'package:edriver/api/job_api.dart';
import 'package:edriver/screen/close_job_menu.dart';
import 'package:edriver/screen/summary_tab.dart';
import 'package:edriver/theme/app_style.dart';
import 'package:edriver/theme/element_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get_connect/http/src/utils/utils.dart';
import 'package:speech_to_text/speech_recognition_result.dart';
import 'package:speech_to_text/speech_to_text.dart';

class mileRecordScreen extends StatefulWidget {
  final String jobID;
  final String time;
  final String job_no;
  final String commander_tel;
  const mileRecordScreen(this.jobID, this.time, this.job_no, this.commander_tel,
      {Key? key})
      : super(key: key);
  @override
  _mileRecordScreenState createState() => _mileRecordScreenState();
}

class _mileRecordScreenState extends State<mileRecordScreen> {
  final _formKey = GlobalKey<FormState>();
  var _dr_job;
  var _mile_begin;
  var _mile_end;
  var _is_edit = false;
  var _mile = "";
  final mileController = TextEditingController();
  SpeechToText _speechToText = SpeechToText();
  var _speechEnabled = false;
  var _lastWords;

  @override
  void initState() {
    get_mile_record();
    super.initState();
    _initSpeech();
  }

  /// This has to happen only once per app
  void _initSpeech() async {
    _speechEnabled = await _speechToText.initialize();
    setState(() {});
  }

  /// Each time to start a speech recognition session
  void _startListening() async {
    await _speechToText.listen(onResult: _onSpeechResult);
    setState(() {
      _mile = "";
    });
  }

  void _stopListening() async {
    await _speechToText.stop();
    setState(() {
      _speechEnabled = true;
    });
  }

  void _showIcon() {
    setState(() {
      _speechEnabled = !_speechEnabled;
      (_speechEnabled) ? _stopListening() : _startListening();
    });
  }

  void _onSpeechResult(SpeechRecognitionResult result) {
    setState(() {
      _mile = result.recognizedWords;
      mileController.text = _mile;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("บันทึกเวลาทำงาน"),
      ),
      body: frm_mile_record(),
      floatingActionButton: AppStyle().getBtnMenu(
          widget.jobID, widget.job_no, widget.commander_tel, context),
      bottomNavigationBar: AppStyle().butoom_bar(context, 2),
    );
  }

  frm_mile_record() {
    return SingleChildScrollView(
        child: Form(
      key: _formKey,
      child: Container(
          margin: const EdgeInsets.all(10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              AppStyle().space_box(20),
              Container(
                child: Column(
                  children: [
                    (widget.time == "b")
                        ? AppStyle()
                            .text("เลขไมล์เริ่มต้น : ", 20, Colors.black)
                        : AppStyle()
                            .text("เลขไมล์สิ้นสุด : ", 20, Colors.black),
                    AppStyle().space_box(10),
                    mileTextField(),
                    AppStyle().space_box(30),
                    element_widget()
                        .btn_submit(_is_edit, "เลขไมล์", save_mileRecord),
                    AppStyle().space_box(30),
                  ],
                ),
              )
            ],
          )),
    ));
  }

  get_mile_record() async {
    Map param = {"reserve_detail_jobID": widget.jobID};
    var dr = await Job_api().get_mileData(param);

    if (dr != null) {
      if (widget.time == "b") {
        if (dr["mile_begin"] != null || dr["mile_begin"] != null) {
          _mile = dr["mile_begin"];
        } else {
          _mile = "";
        }
      } else {
        if (dr["mile_end"] != null) {
          _mile = dr["mile_end"];
        } else {
          _mile = "";
        }
      }
    } else {
      _mile = "";
    }
    setState(() {
      if (_mile != "") {
        _is_edit = true;
      } else {
        _is_edit = false;
      }
    });

    mileController.text = _mile;
  }

  Widget mileTextField() {
    return TextFormField(
        controller: mileController,
        keyboardType: TextInputType.number,
        decoration: InputDecoration(
          suffixIcon: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween, // added line
            mainAxisSize: MainAxisSize.min, // added line
            children: <Widget>[
              IconButton(
                tooltip: 'Listen',
                icon: Icon(_speechEnabled ? Icons.mic_off : Icons.mic),
                onPressed: () {
                  _showIcon();
                },
              ),
              element_widget().textIconClear(mileController),
            ],
          ),
        ),
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'กรุณากรอก เลขไมล์';
          }
          return null;
        });
  }

  save_mileRecord() async {
    _stopListening();
    AppStyle().loading(context);
    final mile_number = mileController.text.replaceAll(" ", "");
    try {
      if (_formKey.currentState!.validate()) {
        var param = {
          "jobID": widget.jobID,
          "mile_number": mile_number,
          "time": widget.time
        };
        //  print(param);
        final result = await Job_api().save_mile(param);
        if (result == "success") {
          AppStyle().toast_text_green("บันทึกข้อมูลเรียบร้อย");
          AppStyle().popScreen(context);
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
}
