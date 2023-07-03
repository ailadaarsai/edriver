import 'package:shared_preferences/shared_preferences.dart';

import '../theme/app_style.dart';
import 'api.dart';

class Share_pref {
  save_data(String key, dynamic value) async {
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

  void delete_data() async {
    try {
      await Future.wait([clear_token(), clear_sharePref()]);
    } catch (e) {
      AppStyle().toast_text("พบปัญหาในการดำเนินการ กรุณาลองอีกครั้ง");
    }
  }

  Future clear_token() async {
    var driverID = await read_data("driverID");
    String urlProfile = "logout";
    Map paramDriver = {"driverID": driverID};

    final result = await API().callApi(urlProfile, paramDriver);

    return result;
  }

  Future clear_sharePref() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    await preferences.clear();
  }
}
