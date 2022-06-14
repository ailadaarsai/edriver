import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'package:edriver/provider/user_profile.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../theme/app_style.dart';

class API {
  String urlPrefix = "https://ecar.egat.co.th/driver_api";
  final prefs = SharedPreferences.getInstance();

  Future<dynamic> callApi(String urlPostfix, Map param) async {
    var url = Uri.parse("$urlPrefix/$urlPostfix");

    Map<String, String> headers = {"Content-type": "application/json"};

    final response = await http.post(url, body: param);
    try {
      // check the status code for the result
      int statusCode = response.statusCode;
      final data = json.decode(response.body);

      if (statusCode == 200) {
        String status = data['status'];
        if (status == "0") {
          AppStyle().toast_text(data['msg']);
        } else {
          final result = data['data'];

          return result;
        }
      }
    } catch (e) {
      AppStyle().toast_text('ไม่สามารถเเชื่อต่อระบบได้ กรุณาลองอีกครั้ง');
    }
  }

  Future<dynamic> getUserProfile(
      String driverType, String empNo, String token) async {
    String urlProfile = "get_driver_profile";
    Map paramDriver;
    if (driverType == "drv_r") {
      paramDriver = {"driverType": "drv_r", "IDCard": empNo, "token": token};
    } else {
      paramDriver = {"driverType": "drv_e", "empID": empNo, "token": token};
    }
    final result = await callApi(urlProfile, paramDriver);
    final driverProfile = Map<String, dynamic>.from(result);

    return driverProfile;
  }

  Future<dynamic> saveUserProfileMem(
      String driverType, String empNo, token) async {
    Map<String, dynamic> result =
        await getUserProfile(driverType, empNo, token);

    String driverName = result["driver_name"];
    //AppStyle().toast_text(driver_name);

    _save_data("driver_name", driverName);
    _save_data("driverID", result["driverID"]);
    _save_data("driverType", result["driverType"]);
    _save_data("driver_pic", result["driver_pic"]);
    _save_data("empID", result["empID"]);
    _save_data("IDCard", result["IDCard"] ?? "");
    _save_data("wage_cost", result["wage_cost"] ?? "0.00");
    _save_data("hotel_cost", result["hotel_cost"] ?? "0.00");
    _save_data("ot_rate", result["ot_rate"] ?? "0.00");
    _save_data("token", result["token"]);
    return result["driverID"];
  }

  _save_data(String key, dynamic value) async {
    final prefs = await SharedPreferences.getInstance();

    prefs.setString(key, value.toString());
    // print(key + "---" + value);
  }

  read_data(String key) async {
    final prefs = await SharedPreferences.getInstance();
    String? value = prefs.getString(key);
    // AppStyle().toast_text("api : " + value.toString());
    return value.toString();
  }

  delete_data() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    await preferences.clear();
  }
}
