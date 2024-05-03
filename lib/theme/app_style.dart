
import 'package:convex_bottom_bar/convex_bottom_bar.dart';
import 'package:edriver/screen/calendar.dart';
import 'package:edriver/screen/close_job_menu.dart';
import 'package:edriver/screen/job_detail.dart';

import 'package:edriver/screen/contact.dart';

import 'package:edriver/screen/home.dart';
import 'package:edriver/screen/search_job_no.dart';
import 'package:edriver/screen/user_data.dart';
import 'package:flutter/material.dart';

import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'package:qr_flutter/qr_flutter.dart';

import '../screen/summary_tab.dart';

class AppStyle {

  Widget space_box(double aheight) {
    return SizedBox(
      height: aheight,
    );
  }

    Widget space_box_width(double awidth) {
    return SizedBox(
      width: awidth,
    );
  }

  Widget logo() {
    return Center(
      child: SizedBox(
        child: Image.asset("assets/images/img_logo.png"),
      ),
    );
  }

  Widget text(String text, [double fontSize = 18, Color color = Colors.black]) {
    return Text(text,
        textAlign: TextAlign.left,
        style: TextStyle(
          fontSize: fontSize,
          color: color,
        ));
  }

    Widget textcenter(String text, [double fontSize = 18, Color color = Colors.black]) {
    return Text(text,
        textAlign: TextAlign.center,
        style: TextStyle(
          fontSize: fontSize,
          color: color,
        ));
  }

  Widget textLabel(String text,
      [Color color_text = Colors.black, double fontSize = 16]) {
    return Text(text,
        style: TextStyle(
            fontSize: fontSize,
            color: color_text,
            fontWeight: FontWeight.bold));
  }

  toast_text(String text) {
    return Fluttertoast.showToast(
        msg: text,
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.BOTTOM,
        // timeInSecForIos: 1,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.0);
  }

  toast_text_green(String text) {
    return Fluttertoast.showToast(
        msg: text,
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.BOTTOM,
        // timeInSecForIos: 1,
        backgroundColor: Colors.green,
        textColor: Colors.white,
        fontSize: 16.0);
  }

  Widget butoom_bar(BuildContext context, var pageIndex) {
    // int _selectedIndex = pageIndex;

    final List<Widget> _pageWidget = <Widget>[
      const userDataScreeen(),
      calendarScreen(
        title: 'ปฏิทินงาน',
      ),
      const HomeScreen(),
      const searchJobNoScreeen(),
      const ContactScreeen(),
    ];

    return ConvexAppBar(
      backgroundColor: Colors.green,
      style: TabStyle.react,
      items: [
        TabItem(icon: Icons.account_box_outlined, title: 'ข้อมูล พขร.'),
        TabItem(icon: Icons.calendar_view_month, title: 'ตารางงาน'),
        TabItem(icon: Icons.home, title: 'หน้าแรก'),
        TabItem(icon: Icons.search, title: 'ค้นหา'),
        TabItem(icon: Icons.phone, title: 'ติดต่อสถานี'),
      ],
      initialActiveIndex: pageIndex,
      activeColor: Colors.yellow,
      onTap: (pageIndex) {
        var page = _pageWidget[pageIndex];
        Navigator.of(context).push(
          MaterialPageRoute(
            fullscreenDialog: false,
            builder: (context) => page,
          ),
        );
      },
    );
  }

  Widget form_notify(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.search),
      onPressed: () {
        link_to(searchJobNoScreeen(), context);
      },
    );
  }

  Widget phase_2() {
    return text('เปิดใช้งาน สิ้นปี 2566', 24, Colors.red);
  }

  Widget phase_2565() {
    return text('เปิดใช้งาน สิ้นปี 2565', 24, Colors.red);
  }

  Scaffold no_job(String txt) {
    return Scaffold(
        body: Center(
      child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [AppStyle().text("$txt  !!!", 24, Colors.red)]),
    ));
  }

  Widget row_btn(left, middle, is_edit, link, BuildContext context,
      {double size = 14}) {
    return Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(left,
              style: TextStyle(fontSize: size, fontWeight: FontWeight.bold)),
          Text(middle,
              textAlign: TextAlign.center, style: TextStyle(fontSize: size)),
          a_link_havetext(is_edit, link, context),
        ]);
  }

  Widget a_link(is_edit, link, context, [double size = 14]) {
    if (is_edit) {
      return InkWell(
          child: Row(
            children: [
              Icon(Icons.edit, color: Colors.deepOrange),
              Text("",
                  style: TextStyle(
                    fontSize: size,
                    color: Colors.deepOrange,
                    decoration: TextDecoration.underline,
                  )),
            ],
          ),
          onTap: () => {link_to(link, context)});
    } else {
      return InkWell(
          child: Row(
            children: [
              Icon(Icons.save, color: Colors.green),
              Text("บันทึก",
                  style: TextStyle(
                    fontSize: size,
                    color: Colors.green,
                    decoration: TextDecoration.underline,
                  )),
            ],
          ),
          onTap: () => {link_to(link, context)});
    }
  }

    Widget a_link_havetext(is_edit, link, context, [double size = 14]) {
    if (is_edit) {
      return InkWell(
          child: Row(
            children: [
              Icon(Icons.edit, color: Colors.deepOrange),
              Text("แก้ไข",
                  style: TextStyle(
                    fontSize: size,
                    color: Colors.deepOrange,
                    decoration: TextDecoration.underline,
                  )),
            ],
          ),
          onTap: () => {link_to(link, context)});
    } else {
      return InkWell(
          child: Row(
            children: [
              Icon(Icons.save, color: Colors.green),
              Text("บันทึก",
                  style: TextStyle(
                    fontSize: size,
                    color: Colors.green,
                    decoration: TextDecoration.underline,
                  )),
            ],
          ),
          onTap: () => {link_to(link, context)});
    }
  }

  Widget a_link_text(text, link, context, [double size = 14]) {
    return InkWell(
        child: Text(text,
            style: TextStyle(
              fontSize: size,
              color: Colors.blue,
              decoration: TextDecoration.underline,
            )),
        onTap: () => {link_to(link, context)});
  }

  Widget row_detail(
    left,
    right, [
    double size = 14,
    Color color_text = Colors.black,
  ]) {
    return Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(left,
              style: TextStyle(
                  fontSize: size,
                  fontWeight: FontWeight.bold,
                  color: color_text)),
          Flexible(
            child: Text(right,
                textAlign: TextAlign.right,
                style: TextStyle(fontSize: size, color: color_text)),
          )
        ]);
  }

  Widget row_detail_b(
    left,
    right, [
    double size = 14,
    Color color_text = Colors.black,
  ]) {
    return Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(left,
              style: TextStyle(
                  fontSize: size,
                  fontWeight: FontWeight.bold,
                  color: color_text)),
          Flexible(
            child: Text(right,
                textAlign: TextAlign.right,
                style: TextStyle(fontSize: size, color: color_text)),
          )
        ]);
  }

  link_to(NewScreen, BuildContext context) {
    Navigator.of(context)
        .push(MaterialPageRoute(builder: (context) => NewScreen));
  }

  popScreen(context) {
    Navigator.of(context).pop();
  }

  Widget open_loading() {
    return Center(
      child: CircularProgressIndicator(),
    );
  }

  String convertNullToDash(String txt, [String defaulttxt = "-"]) {
    if (txt.toString() == "null" || txt.toString() == "Null" || txt == "") {
      return defaulttxt;
    } else {
      return txt;
    }
  }

  Widget getBtnMenu(
      String jobID, String job_no, commander_moile, BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        SizedBox(
          height: 60,
          width: 60,
          child: SpeedDial(
            animatedIcon: AnimatedIcons.menu_close,
            animatedIconTheme: IconThemeData(size: 22),
            backgroundColor: Color.fromARGB(255, 111, 216, 190),
            visible: true,
            curve: Curves.bounceIn,
            children: [
              // FAB 1
              SpeedDialChild(
                  child: Icon(Icons.summarize),
                  backgroundColor: Color.fromARGB(255, 111, 216, 190),
                  onTap: () {
                    link_to(summarytabScreen(jobID, job_no, commander_moile),
                        context);
                  },
                  label: 'สรุปข้อมูลการเดินทาง',
                  labelStyle: TextStyle(
                      fontWeight: FontWeight.w500,
                      color: Colors.black,
                      fontSize: 16.0),
                  labelBackgroundColor: Color.fromARGB(255, 111, 216, 190)),
              // FAB 2
              SpeedDialChild(
                  child: Icon(Icons.phone),
                  backgroundColor: Color.fromARGB(255, 111, 216, 190),
                  onTap: () {
                    callNumber(commander_moile);
                  },
                  label: 'โทร.ผู้ควบคุมรถ',
                  labelStyle: TextStyle(
                      fontWeight: FontWeight.w500,
                      color: Colors.black,
                      fontSize: 16.0),
                  labelBackgroundColor: Color.fromARGB(255, 111, 216, 190)),
              SpeedDialChild(
                  child: Icon(Icons.save),
                  backgroundColor: Color.fromARGB(255, 111, 216, 190),
                  onTap: () {
                    link_to(closeJobMenuScreen(jobID, job_no, commander_moile),
                        context);
                  },
                  label: 'บันทึกข้อมูลการเดินทาง',
                  labelStyle: TextStyle(
                      fontWeight: FontWeight.w500,
                      color: Colors.black,
                      fontSize: 16.0),
                  labelBackgroundColor: Color.fromARGB(255, 111, 216, 190)),
              SpeedDialChild(
                  child: Icon(Icons.list),
                  backgroundColor: Color.fromARGB(255, 111, 216, 190),
                  onTap: () {
                    link_to(jobDetailScreen(jobID, job_no, commander_moile),
                        context);
                  },
                  label: 'ข้อมูลใบงาน',
                  labelStyle: TextStyle(
                      fontWeight: FontWeight.w500,
                      color: Colors.black,
                      fontSize: 16.0),
                  labelBackgroundColor: Color.fromARGB(255, 111, 216, 190)),
            ],
          ),
        ),
      ],
    );
  }

    ButtonStyle buttonStyleForCheck(BuildContext context,text) {
    return ButtonStyle( 
      textStyle: MaterialStateProperty.resolveWith<TextStyle>(
        (states) {
          final double textSize = MediaQuery.of(context).size.width * 0.04;
          return TextStyle(fontSize: textSize);
        },
      ),
      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
        RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(18.0),
          side: BorderSide(color: Colors.green)
        )
      ),
      fixedSize: MaterialStateProperty.resolveWith<Size>(
      (states) {
        // Calculate the width based on the text content
          final double textWidth = getTextWidth(text, TextStyle(fontSize: MediaQuery.of(context).size.width * 0.04));
          // Add some padding to the width
        final double widthPadding = MediaQuery.of(context).size.width * 0.2;
        // Return the fixed size with the calculated width and a minimum height
        return Size(textWidth + widthPadding, MediaQuery.of(context).size.height * 0.1);
      },
      ),
    );
  }

  ButtonStyle buttonStyle(BuildContext context,text) {
    return ButtonStyle( 
      textStyle: MaterialStateProperty.resolveWith<TextStyle>(
        (states) {
          final double textSize = MediaQuery.of(context).size.width * 0.04;
          return TextStyle(fontSize: textSize);
        },
      ),
      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
        RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(18.0),
          side: BorderSide(color: Colors.green)
        )
      ),
      fixedSize: MaterialStateProperty.resolveWith<Size>(
      (states) {
        // Calculate the width based on the text content
          final double textWidth = getTextWidth(text, TextStyle(fontSize: MediaQuery.of(context).size.width * 0.04));
          // Add some padding to the width
        final double widthPadding = MediaQuery.of(context).size.width * 0.2;
        // Return the fixed size with the calculated width and a minimum height
        return Size(textWidth + widthPadding, MediaQuery.of(context).size.height * 0.1);
      },
      ),
    );
  }

  ButtonStyle buttonStyleForOne(BuildContext context,text) {
    return ButtonStyle( 
      textStyle: MaterialStateProperty.resolveWith<TextStyle>(
        (states) {
          final double textSize = MediaQuery.of(context).size.width * 0.04;
          return TextStyle(fontSize: textSize);
        },
      ),
      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
        RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(18.0),
          side: BorderSide(color: Colors.green)
        )
      ),
      fixedSize: MaterialStateProperty.resolveWith<Size>(
      (states) {
        // Calculate the width based on the text content
          final double textWidth = getTextWidth(text, TextStyle(fontSize: MediaQuery.of(context).size.width * 0.04));
          // Add some padding to the width
        final double widthPadding = MediaQuery.of(context).size.width * 0.3;
        // Return the fixed size with the calculated width and a minimum height
        return Size(textWidth + widthPadding, MediaQuery.of(context).size.height * 0.1);
      },
      ),
    );
  }

  double getTextWidth(String text, TextStyle style) {
  final TextPainter textPainter = TextPainter(
    text: TextSpan(text: text, style: style),
    textDirection: TextDirection.ltr,
  )..layout();
  return textPainter.width;
}


  Widget QR_code(String url) {
    return QrImage(
      data: url,
      version: QrVersions.auto,
      size: 150,
      gapless: false,
    );
  }

  Widget textButton(IconData icon, String txt, void func) {
    return TextButton.icon(
      style: TextButton.styleFrom(
        backgroundColor: Colors.grey[100],
        padding: const EdgeInsets.all(20.0),
        textStyle: const TextStyle(fontSize: 16),
      ),
      onPressed: () => {func},
      icon: Column(
        children: [
          Icon(
            icon,
            color: Colors.grey,
            size: 50,
          ),
          Text(
            txt, //'Label',
            style: TextStyle(
              color: Colors.black,
            ),
          )
        ],
      ),
      label: Text(""),
    );
  }

  callNumber(String phone_num) async {
    // const number = '08592119XXXX'; //set the number here
    await FlutterPhoneDirectCaller.callNumber(phone_num);
  }

  loading(context) {
    //return EasyLoading.init();
    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return Dialog(
          child: Container(
            width: 300,
            height: 50,
            child: Center(
              child: new Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  new CircularProgressIndicator(),
                  new Text("....กำลังประมวลผล......"),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  close_load(context) {
    //return EasyLoading.dismiss();
    return Navigator.pop(context);
  }
}
