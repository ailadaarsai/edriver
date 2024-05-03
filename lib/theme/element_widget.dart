import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_rounded_date_picker/flutter_rounded_date_picker.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import '../api/api.dart';
import '../api/location.dart';
import 'app_style.dart';

class element_widget {
  Widget textBox_number(element, text, [isNotNull = true, isReadonly = false]) {
    return TextFormField(
        decoration: InputDecoration(
          label: Row(
            children: [
              Text(text),
              visible(text_require(), isNotNull),
            ],
          ),
          suffixIcon: textIconClear(element),
        ),
        controller: element,
        readOnly: isReadonly,
        keyboardType: TextInputType.number,
        validator: (value) {
          if (isNotNull) {
            if (value == null || value.isEmpty) {
              return "กรุณาระบุ $text";
            }
          }
          return null;
        });
  }

  ddl(text, elementID, postTime, [isRequire = true]) {
    //print("text" + text);

    String? hour, minute = "";
    List<String> minute_item = <String>[
      '00',
      '30',
    ];
    List<String> houritem = <String>[
      '06',
      '07',
      '08',
      '09',
      '10',
      '11',
      '12',
      '13',
      '14',
      '15',
      '16',
      '17',
      '18',
      '19',
      '20',
      '21',
      '22',
      '23',
      '24',
      '00',
      '01',
      '02',
      '03',
      '04',
      '05'
    ];
    var time_split;

    if (postTime != null && postTime.toString() != "") {
      // print("time_split" + postTime.toString());
      time_split = postTime.toString().split(":");
      if (time_split != null) {
        hour = time_split[0].toString();
        minute = time_split[1].toString();
      } else {
        hour = '00';
        minute = '00';
      }
    } else {
      minute = '00';
    }

    return Column(children: [
      Row(
        children: [
          AppStyle().text("$text :", 16, Colors.black45),
          (isRequire) ? element_widget().text_require() : Container(),
        ],
      ),
      Row(
        children: [
          SizedBox(
            width: 150,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                DropdownButtonFormField<String>(
                  value: hour,
                  menuMaxHeight: 300,
                  validator: (value) =>
                      value == null && isRequire ? "กรุณาระบุ " + text : null,
                  items: houritem.map((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                  onChanged: (newValue) {
                    hour = newValue;
                    var time = "$hour:$minute";
                    elementID.text = time;
                  },
                ),
              ],
            ),
          ),
          SizedBox(
            width: 20,
          ),
          AppStyle().text(":"),
          SizedBox(
            width: 20,
          ),
          SizedBox(
            width: 150,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                DropdownButtonFormField<String>(
                  value: minute,
                  menuMaxHeight: 300,
                  // validator: (value) =>
                  //     value == null && isRequire ? "กรุณาระบุ " + text : null,
                  items: minute_item.map((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                  onChanged: (newValue) {
                    minute = newValue;
                    var time = "$hour:$minute";
                    elementID.text = time;
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    ]);
  }

  text_require() {
    return Text('  *',
        style: TextStyle(
            color: Colors.red, fontWeight: FontWeight.bold, fontSize: 18));
  }

  textbox_string(element, text, [isLocation = false, isNotNull = true]) {
    return TextFormField(
        controller: element,
        keyboardType: TextInputType.multiline,
        maxLines: null,
        decoration: InputDecoration(
          label: Row(
            children: [
              Text(text),
              visible(text_require(), isNotNull),
            ],
          ),
          labelStyle: TextStyle(color: Colors.black),
          suffixIcon: Row(
            mainAxisAlignment: MainAxisAlignment.start, // added line
            mainAxisSize: MainAxisSize.min, // added line
            children: <Widget>[
              visible(TextIconLocation(element), isLocation),
              textIconClear(element),
            ],
          ),
        ),
        validator: (value) {
          if (isNotNull) {
            if (value == null || value.isEmpty) {
              return "กรุณาระบุ $text";
            }
          }
          return null;
        });
  }

  getLocationName(elememt) async {
    AppStyle().open_loading();
    var _address = await Location().GetAddressFromLatLong();
    elememt.text = _address;
  }

  TextFormField textbox_calendar(
      controller, text, initialDate, startDate, endDate, context,
      [isNotNull = true]) {
    return TextFormField(
        readOnly: true,
        controller: controller,
        textAlign: TextAlign.left,
        cursorWidth: 1,
        decoration: InputDecoration(
          label: Row(
            children: [
              Text(text),
              visible(text_require(), isNotNull),
            ],
          ),
          suffixIcon: Icon(Icons.calendar_month),
        ),
        validator: (value) {
          if (isNotNull) {
            if (value == null || value.isEmpty) {
              return 'กรุณาระบุ $text';
            }
          }
        },
        onTap: () async {
          showRoundedDatePicker(
            locale: Locale('th', 'TH'),
            //era: EraMode.BUDDHIST_YEAR,
            theme: ThemeData(primarySwatch: Colors.teal),
            context: context,
            height: 300,
            initialDate: DateTime.parse(initialDate),
            // firstDate: DateTime.parse(startDate),
            //lastDate: DateTime.parse(endDate),
            borderRadius: 16,
          ).then((selectedDate) {
            if (selectedDate != null) {
              controller.text = DateFormat('yyyy-MM-dd').format(selectedDate);
            }
          });
        });
  }

  TextFormField textbox_calendar_free(controller, text, initialDate, context,
      [isNotNull = true]) {
    return TextFormField(
        readOnly: true,
        controller: controller,
        textAlign: TextAlign.left,
        cursorWidth: 1,
        decoration: InputDecoration(
          label: Row(
            children: [
              Text(text),
              visible(text_require(), isNotNull),
            ],
          ),
          suffixIcon: Icon(Icons.calendar_month),
        ),
        validator: (value) {
          if (isNotNull) {
            if (value == null || value.isEmpty) {
              return 'กรุณาระบุ $text';
            }
          }
        },
        onTap: () async {
          showRoundedDatePicker(
            locale: Locale('th', 'TH'),
            //era: EraMode.BUDDHIST_YEAR,
            theme: ThemeData(primarySwatch: Colors.teal),
            context: context,
            height: 300,
            initialDate: (initialDate == null)
                ? null
                : DateTime.parse(initialDate), //DateTime.parse(initialDate),

            borderRadius: 16,
          ).then((selectedDate) {
            if (selectedDate != null) {
              controller.text = DateFormat('yyyy-MM-dd').format(selectedDate);
            }
          });
        });
  }

  Widget btn_submit(isEdit, text, func) {
    return SizedBox(
      height: 50,
      width: double.infinity,
      child: ElevatedButton.icon(
        icon: Icon((isEdit) ? Icons.edit : Icons.save),
        style: ElevatedButton.styleFrom(
            backgroundColor: (isEdit) ? Colors.amber : Colors.teal),
        label: Text((isEdit) ? "แก้ไข" + text : "บันทึก" + text,
            style: TextStyle(fontSize: 20)),
        onPressed: () async {
          try {
            AppStyle().open_loading();
            func();
          } catch (e) {
            AppStyle().open_loading();
          }
        },
      ),
    );
  }
  Widget btn(text,icon,func){
    return SizedBox(
      height: 50,
      width: double.infinity,
      child: ElevatedButton.icon(
        icon: icon,
        style: ElevatedButton.styleFrom(
            backgroundColor: Colors.teal),
        label: Text(text,
            style: TextStyle(fontSize: 20)),
        onPressed: () async {
          try {
            AppStyle().open_loading();
            func();
          } catch (e) {
            AppStyle().open_loading();
          }
        },
      ),
    );
  }
  

  Widget btn_image(func, [text = "ถ่ายรูปใบเสร็จ"]) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        ElevatedButton.icon(
          icon: Icon(
            Icons.camera_alt_sharp,
            color: Colors.white,
            size: 25.0,
          ),
          label: Text(text),
          onPressed: () {
            func();
          },
          style: ElevatedButton.styleFrom(
            shape: new RoundedRectangleBorder(
              borderRadius: new BorderRadius.circular(10.0),
            ),
          ),
        ),
      ],
    );
  }

  Widget btn_pickimage(func, [text = "เลือกรูปใบเสร็จ"]) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        ElevatedButton.icon(
          icon: Icon(
            Icons.insert_photo,
            color: Colors.white,
            size: 25.0,
          ),
          label: Text(text),
          onPressed: () {
            func();
          },
          style: ElevatedButton.styleFrom(
            shape: new RoundedRectangleBorder(
              borderRadius: new BorderRadius.circular(10.0),
            ),
          ),
        ),
      ],
    );
  }

  Widget showPic(imageFile, url, [isRequire = true, text = "ใบเสร็จ"]) {
    if (imageFile.toString() == "null" && url == null || url.toString() == "") {
      if (isRequire) {
        return Center(
          child: Container(
              child: AppStyle().text("กรุณาถ่ายรูป" + text, 14, Colors.red)),
        );
      } else {
        return Container();
      }
    } else {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
                height: 200, width: 200, child: show_pic_url(imageFile, url)),
          ],
        ),
      );
    }
  }

  show_pic_url(imageFile, url_pic) {
    // print(url_pic);
    if (imageFile != null) {
      return Image.file(
        imageFile!,
        fit: BoxFit.cover,
      );
    } else {
      if (url_pic.toString() != "null" || url_pic != null || url_pic != "") {
        var url = API().get_server_pic(url_pic);
        //   print("url: " + url);
        return new Image.network(url, height: 150, width: 300);
      } else {
        return Container();
      }
    }
  }

  Widget visible(wg, bool typeVisible) {
    return Visibility(
      child: wg,
      visible: (typeVisible == true) ? true : false,
    );
  }

  Widget numberMicTextField(controller, lable, isLisiten) {
    return TextFormField(
        controller: controller,
        keyboardType: TextInputType.number,
        decoration: InputDecoration(
          suffixIcon: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween, // added line
            mainAxisSize: MainAxisSize.min, // added line
            children: <Widget>[
              IconButton(
                tooltip: 'Listen',
                icon: Icon(isLisiten ? Icons.mic_off : Icons.mic),
                onPressed: () {
                  //          _showIcon();
                },
              ),
              IconButton(
                // tooltip: 'Listen',
                icon: Icon(Icons.clear),
                onPressed: () {
                  controller.text = "";
                },
              ),
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

  Widget textIconClear(element) {
    return IconButton(
      // tooltip: 'Listen',
      icon: Icon(Icons.clear),
      onPressed: () {
        element.text = "";
      },
    );
  }

  Widget TextIconLocation(element) {
    return IconButton(
      tooltip: 'Listen',
      icon: Icon(Icons.location_searching_rounded),
      onPressed: () {
        getLocationName(element);
      },
    );
  }

  imageFromCamera() async {
    PickedFile? pickedFile = await ImagePicker().getImage(
        source: ImageSource.camera,
        maxHeight: 400,
        maxWidth: 350,
        imageQuality: 100);
    if (pickedFile != null) {
      var imageFile = File(pickedFile.path);
      return imageFile;
    } else {
      return null;
    }
  }

  Widget row_tmp_3(w1, w2, w3, [size = const [4, 4, 2]]) {
    return Row(
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Expanded(
            flex: size[0],
            child: Container(child: w1),
          ),
          Expanded(
            flex: size[1],
            child: Container(
              child: w2,
            ),
          ),
          Expanded(
            flex: size[2],
            child: Container(
              child: w3,
            ),
          )
        ]);
  }

  Widget btn_edit(func) {
    return SizedBox(
      height: 50,
      width: double.infinity,
      child: ElevatedButton.icon(
        icon: Icon(Icons.edit),
        style: ElevatedButton.styleFrom(backgroundColor: Colors.amber),
        label: Text("แก้ไข", style: TextStyle(fontSize: 20)),
        onPressed: () async {
          try {
            AppStyle().open_loading();
            func();
          } catch (e) {
            AppStyle().open_loading();
          }
        },
      ),
    );
  }

  Widget btn_delete(func) {
    return SizedBox(
      height: 50,
      width: double.infinity,
      child: ElevatedButton.icon(
        icon: Icon(Icons.delete_outline),
        style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
        label: Text("ลบ", style: TextStyle(fontSize: 20)),
        onPressed: () async {
          try {
            AppStyle().open_loading();
            func();
          } catch (e) {
            AppStyle().open_loading();
          }
        },
      ),
    );
  }

  Widget row_tmp_2(w1, w2, [size = const [5, 5]]) {
    return Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Expanded(
            flex: size[0],
            child: Padding(
              padding: const EdgeInsets.fromLTRB(0, 0, 4, 0),
              child: Container(child: w1),
            ),
          ),
          Expanded(
            flex: size[1],
            child: w2,
          ),
        ]);
  }

  toastSaveIncomplete() {
    AppStyle().toast_text("ไม่สามารถบันทึกได้ กรุณาลองอีกครั้ง");
  }

  containerBoxText(text) {
    return Container(
      child: Text(text, style: TextStyle(fontSize: 16, color: Colors.black45)),
      padding: const EdgeInsets.fromLTRB(20, 10, 10, 10),
      decoration: BoxDecoration(
        color: Colors.green[100],
        border: Border.all(
          color: Colors.green,
          width: 2.0,
        ),
        borderRadius: BorderRadius.circular(15),
      ),
    );
  }

  card(
    header_text,
    element,
  ) {
    return Container(
        decoration: const BoxDecoration(
          color: Colors.black12,
          borderRadius: BorderRadius.all(Radius.circular(15)),
          boxShadow: null,
        ),
        padding: const EdgeInsets.all(10),
        child: Column(children: [
          Row(
            children: [
              Text(
                header_text,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: Colors.teal,
                ),
              ),
            ],
          ),
          SizedBox(
            width: 16,
          ),
          underline(
            Colors.black,
          ),
          element
        ]));
  }

  underline(color) {
    return Divider(
      color: color,
      height: 20,
      thickness: 1,
    );
  }
}
