import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../theme/app_style.dart';

class API {
  String urlPrefix = "https://ecar.egat.co.th/driver_api";
  //String urlPrefix = "http://10.0.2.2/ecar/driver_api";
  //String urlPrefix = "https://ecar.egat.co.th/ecar_ice/driver_api";

  final prefs = SharedPreferences.getInstance();

  Future<dynamic> callApi(String urlPostfix, Map param) async {
    var url = Uri.parse("$urlPrefix/$urlPostfix");
    print(url);

    /* Map<String, String> headers = {
      "Content-type": "application/json;charset=utf-8",
    };*/

    final response = await http.post(url, body: param);
    print(response.body);
    // print(response.statusCode);
    try {
      // check the status code for the result
      int statusCode = response.statusCode;
      //  print(statusCode);
      final data = json.decode(response.body);
      // print(data);
      if (statusCode == 200) {
        String status = data['status'];
        if (status.toString() == "0") {
          AppStyle().toast_text(data['msg']);
        } else {
          final result = data['data'];

          return result;
        }
      } else {
        AppStyle().toast_text(statusCode.toString());
      }
    } catch (e) {
      //AppStyle().toast_text('ไม่สามารถเชื่อมต่อระบบได้ กรุณาลองอีกครั้ง');
    }
  }

  get_server_pic(urlserver) {
    var new_url = "";

    if (urlserver != null) {
      String url = API().urlPrefix;
      String urlReplace = url.replaceAll("/driver_api", "");
      new_url = urlReplace + "/" + urlserver;
    }

    return new_url;
  }

  date_thai_now() {
    DateTime now = new DateTime.now();
    DateTime date_now = new DateTime((now.year) + 543, now.month, now.day);
    return date_now;
  }

  DateTime flutterDate(dbDate) {
    DateTime newDate = DateTime.parse(dbDate);
    DateTime NewDateFormat =
        new DateTime((newDate.year), newDate.month, newDate.day);
    return NewDateFormat;
  }

  String time_now() {
    String time = DateFormat('HH:mm').format(DateTime.now()).toString();
    return time;
  }

  dateNow() {
    DateTime now = new DateTime.now();
    DateTime date_now = new DateTime(now.year, now.month, now.day);
    return date_now;
  }

  String date_now() {
    String time = DateFormat('yyyy-MM-dd').format(DateTime.now()).toString();
    return time;
  }

  String DateNoTime(in_date) {
    // DateTime conv = DateTime.parse(in_date);
    DateTime new_date =
        new DateTime((in_date.year) + 543, in_date.month, in_date.day);
    return new_date.toString().replaceAll("00:00:00.000", "");
  }

  date_to_db(flutter_date) {
    DateTime conv = DateTime.parse(flutter_date);
    DateTime date_now = new DateTime((conv.year) - 543, conv.month, conv.day);
    return date_now.toString();
  }

  bool isCurrentDateInRange(String startDate, String endDate) {
    final currentDate = DateTime.now();
    return currentDate.isAfter(DateTime.parse(startDate)) &&
        currentDate.isBefore(DateTime.parse(endDate));
  }

  setStringIfNull(data, valueDefault) {
    var value = "";
    if (data == null || data == "") {
      value = valueDefault;
    } else {
      value = data;
    }
    return value;
  }

  numberFormat(number) {
    var value = new NumberFormat("#,##0.00", "en_US");
    if (number == null) {
      number = 0;
    }
    var new_number = value.format(double.parse(number.toString()));
    return new_number;
  }
}
