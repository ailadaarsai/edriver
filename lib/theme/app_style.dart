import 'package:edriver/screen/calendar.dart';
import 'package:edriver/screen/contact.dart';
import 'package:edriver/screen/fuel.dart';
import 'package:edriver/screen/home.dart';
import 'package:edriver/screen/notify.dart';
import 'package:edriver/screen/user_data.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class AppStyle {
  Widget space_box(double aheight) {
    return SizedBox(
      height: aheight,
    );
  }

  Widget logo() {
    return Center(
      child: SizedBox(
        child: Image.asset("assets/images/img_logo.png"),
      ),
    );
  }

  Widget text(String text, double fontSize) {
    return Text(text,
        style: TextStyle(fontSize: fontSize
            // color: textColor
            ));
  }

  loading_dialog(BuildContext context) {
    AlertDialog alert = AlertDialog(
      content: new Row(
        children: [
          CircularProgressIndicator(),
          Container(
              margin: EdgeInsets.only(left: 7), child: Text(" Loading..")),
        ],
      ),
    );
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  close_loading(BuildContext context) {
    Navigator.pop(context);
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

  Widget butoom_bar(BuildContext context, var pageIndex) {
    int _selectedIndex = pageIndex;
    final List<Widget> _pageWidget = <Widget>[
      const userDataScreeen(),
      const CalendarScreeen(),
      const HomeScreen(),
      const FuelScreen(),
      const ContactScreeen(),
    ];

    return BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.account_box_outlined),
            label: 'ข้อมูล พขร.',
            backgroundColor: Colors.green,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.calendar_view_month),
            label: 'ตารางงาน',
            backgroundColor: Colors.green,
          ),
          BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: 'หน้าแรก',
              backgroundColor: Colors.green),
          BottomNavigationBarItem(
            icon: Icon(Icons.plumbing_sharp),
            label: 'เติมน้ำมัน',
            backgroundColor: Colors.green,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.phone),
            label: 'ติดต่อสถานี',
            backgroundColor: Colors.green,
          ),
        ],
        currentIndex: pageIndex,
        selectedItemColor: Colors.yellow,
        showUnselectedLabels: true,
        unselectedItemColor: Colors.white,
        onTap: (pageIndex) {
          var page = _pageWidget[pageIndex];
          Navigator.of(context).push(
            MaterialPageRoute(
              fullscreenDialog: false,
              builder: (context) => page,
            ),
          );
        });
  }

  Widget form_notify(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.notifications),
      onPressed: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            fullscreenDialog: false,
            builder: (context) => const NotifyScreeen(),
          ),
        );
      },
    );
  }
}
