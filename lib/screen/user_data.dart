import 'dart:convert';
import 'package:edriver/api/driver_api.dart';

import 'package:edriver/api/share_pref.dart';

import 'package:edriver/screen/login_egat.dart';
import 'package:edriver/theme/app_style.dart';
import 'package:edriver/theme/element_widget.dart';
import 'package:flutter/material.dart';

class userDataScreeen extends StatefulWidget {
  const userDataScreeen({Key? key}) : super(key: key);

  @override
  State<userDataScreeen> createState() => _userDataScreeenState();
}

class _userDataScreeenState extends State<userDataScreeen> {
  final TextEditingController driverTelController = new TextEditingController();
  final TextEditingController addressController = new TextEditingController();
  final GlobalKey<FormState> _keyDialogForm = new GlobalKey<FormState>();
  final GlobalKey<FormState> _editAddressForm = new GlobalKey<FormState>();
  var _isEGAT;

  @override
  void initState() {
    is_egat();
    super.initState();
  }

  is_egat() async {
    _isEGAT = await driver_api().is_driver_EGAT();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return /*Scaffold(
      body: FutureBuilder<List<String>>(
        future: futureNumbersList,
        builder: (context, snapshot) {
          return RefreshIndicator(
            child: _listView(snapshot),
            onRefresh: _pullRefresh,
          );
        },
      ),
    );*/

        FutureBuilder(
            future: driver_api().get_driver_profile(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return AppStyle().open_loading();
              } else {
                //print(snapshot.data);
                return user_profile(snapshot.data);
                //print(snapshot.data);
              }
            });
  }

  Scaffold user_profile(dr) {
    //print(dr["driver_pic"]);
    //AppStyle().toast_text_green(dr["wage_cost"]);
    String wage_cost = AppStyle().convertNullToDash(dr["wage_cost"].toString());
    String hotel_cost =
        AppStyle().convertNullToDash(dr["hotel_cost"].toString());
    String ot_cost = AppStyle().convertNullToDash(dr["ot_rate"].toString());
    String address = AppStyle().convertNullToDash(dr["address"].toString());
    String driver_tel =
        AppStyle().convertNullToDash(dr["driver_tel"].toString());

    return Scaffold(
      appBar: AppBar(
        title: Text("ข้อมูล พขร."),
        actions: <Widget>[
          AppStyle().form_notify(context),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
          child: SizedBox(
            width: MediaQuery.of(context).size.width,
            child: Container(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Center(child: driver_picture(dr)),
                  AppStyle().space_box(20),
                  AppStyle().row_detail("ชื่อ", "${dr["driver_name"]}", 16),
                  AppStyle()
                      .row_detail("ค่าเบี้ยเลี้ยง / วัน", "$wage_cost บาท", 16),
                  AppStyle()
                      .row_detail("ค่าที่พัก / วัน", "$hotel_cost บาท", 16),
                  AppStyle().row_detail("อัตรา OT / ชม.", "$ot_cost บาท", 16),
                  row_mobile(driver_tel),
                  element_widget().visible(row_address(address), _isEGAT),
                  element_widget().visible(row_edit_address(), _isEGAT),
                  AppStyle().space_box(20),
                  Center(child: btn_logout(context)),
                  AppStyle().space_box(40),
                ],
              ),
            ),
          ),
        ),
      ),
      bottomNavigationBar: AppStyle().butoom_bar(context, 0),
    );
  }

  Widget driver_picture(dr) {
    print(dr["driver_pic"]);
    if (dr["driver_typeID"] == 'drv_egat' || dr["driver_typeID"] == 'drv_spc') {
      if (dr["driver_pic"] ==
          "https://ecar.egat.co.th/ecar_ice/images/profile-pic-avatar.jpg") {
        return new Image.network(dr["driver_pic"], height: 150, width: 300);
      } else {
        return Image.memory(base64.decode(dr["driver_pic"].split(',').last),
            height: 150, width: 300);
      }
    } else {
      return new Image.network(dr["driver_pic"], height: 150, width: 300);
    }
  }

  Widget row_edit_address() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Flexible(
          flex: 8,
          child: Container(),
        ),
        Expanded(
          flex: 2,
          // add this
          child: Container(
            child: InkWell(
                child: Row(
                  children: [
                    Container(
                        alignment: Alignment.topRight,
                        child: Icon(Icons.edit, color: Colors.deepOrange)),
                    Text("แก้ไข",
                        maxLines: 1,
                        textAlign: TextAlign.right,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.deepOrange,
                          decoration: TextDecoration.underline,
                        )),
                  ],
                ),
                onTap: () => {edit_address("ที่อยู่")}),
          ),
        ),
      ],
    );
  }

  Widget row_address(address) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Flexible(
          flex: 3,
          child: Container(
              child: AppStyle().textLabel("ที่อยู่", Colors.black, 16)),
        ),
        Expanded(
          flex: 7,
          // add this
          child: Text(
            "${address}",
            style: TextStyle(
              fontSize: 16,
            ),
            textAlign: TextAlign.right,
            maxLines: 3,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }

  Widget row_mobile(driver_tel) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Expanded(
          flex: 5,
          child:
              Container(child: AppStyle().textLabel("โทร.", Colors.black, 16)),
        ),
        Expanded(
          flex: 5,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              AppStyle().text(driver_tel, 16),
              Padding(
                padding: const EdgeInsets.fromLTRB(8, 0, 0, 0),
                child: InkWell(
                    child: Row(
                      children: [
                        Container(
                            alignment: Alignment.centerRight,
                            child: Icon(Icons.edit, color: Colors.deepOrange)),
                        Text("",
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.deepOrange,
                              decoration: TextDecoration.underline,
                            )),
                      ],
                    ),
                    onTap: () => {edit_mobile()}),
              ),
            ],
          ),
        ),
      ],
    );
  }

  edit_address(text) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            scrollable: true,
            title: Text('แก้ไข' + text),
            content: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Form(
                key: _editAddressForm,
                child: Column(
                  children: <Widget>[
                    element_widget()
                        .textbox_string(addressController, "ที่อยู่"),
                  ],
                ),
              ),
            ),
            actions: <Widget>[
              new ElevatedButton(
                  child: const Text('บันทึก'),
                  onPressed: () async {
                    //AppStyle().toast_text(driverTelController.text);
                    if (_editAddressForm.currentState!.validate()) {
                      final result = await driver_api()
                          .update_driver_address(addressController.text);
                      AppStyle().link_to(userDataScreeen(), context);

                      if (result != null) {
                        AppStyle().toast_text_green("บันทึกเรียบร้อยแล้ว");
                      }
                    }
                  }),
              new ElevatedButton(
                  child: const Text('ยกเลิก'),
                  style: ElevatedButton.styleFrom(
                    primary: Colors.grey, // background
                    onPrimary: Colors.white, // foreground
                  ),
                  onPressed: () {
                    Navigator.pop(context);
                  })
            ],
          );
        });
  }

  edit_mobile() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            scrollable: true,
            title: Text('แก้ไข'),
            content: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Form(
                key: _keyDialogForm,
                child: Column(
                  children: <Widget>[
                    TextFormField(
                      controller: driverTelController,
                      keyboardType: TextInputType.number,
                      maxLength: 12,
                      decoration: InputDecoration(
                        labelText: 'เบอร์โทร',
                        icon: Icon(Icons.mobile_friendly),
                        suffixIcon: IconButton(
                          onPressed: driverTelController.clear,
                          icon: Icon(Icons.clear),
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'กรุณากรอก เบอร์โทร';
                        } else if (value.length < 12) {
                          return 'กรุณากรอก เบอร์โทรให้ครบ 10 หลัก';
                        }
                      },
                    ),
                  ],
                ),
              ),
            ),
            actions: <Widget>[
              new ElevatedButton(
                  child: const Text('บันทึก'),
                  onPressed: () async {
                    //AppStyle().toast_text(driverTelController.text);
                    if (_keyDialogForm.currentState!.validate()) {
                      final result = await driver_api()
                          .update_driver_tel(driverTelController.text);
                      AppStyle().link_to(userDataScreeen(), context);

                      if (result != null) {
                        AppStyle().toast_text_green("บันทึกเรียบร้อยแล้ว");
                      }
                    }
                  }),
              new ElevatedButton(
                  child: const Text('ยกเลิก'),
                  style: ElevatedButton.styleFrom(
                    primary: Colors.grey, // background
                    onPrimary: Colors.white, // foreground
                  ),
                  onPressed: () {
                    Navigator.pop(context);
                  })
            ],
          );
        });
  }

  Widget btn_logout(context) {
    return ElevatedButton.icon(
      icon: Icon(
        Icons.logout_rounded,
        color: Colors.white,
        size: 24.0,
      ),
      label: Text(
        " ออกจากระบบ",
        style: TextStyle(fontSize: 16.0, color: Colors.white),
      ),
      onPressed: () {
        Share_pref().delete_data();
        Navigator.of(context).popUntil((route) => route.isFirst);
        AppStyle().link_to(Login_egat_screen(), context);
      },
      style: ElevatedButton.styleFrom(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(28.0),
        ),
        primary: Colors.red,
        minimumSize: const Size(100, 50),
      ),
    );
  }
}
