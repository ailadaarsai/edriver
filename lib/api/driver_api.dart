import 'package:edriver/api/share_pref.dart';
import 'api.dart';

class driver_api {
  Future<String> saveUserProfileMem(
      String driverType, String empNo, token) async {
    String urlProfile = "login_driver";
    Map paramDriver = {};
    if (driverType == "drv_r") {
      paramDriver = {"driverType": "drv_r", "IDCard": empNo, "token": token};
    } else {
      paramDriver = {"driverType": "drv_e", "empID": empNo, "token": token};
    }
    //print(paramDriver);
    final result = await API().callApi(urlProfile, paramDriver);

    // String driverName = result["driver_name"];
    Share_pref().save_data("driverID", result["driverID"]);
    Share_pref().save_data("driverType", result["driver_typeID"]);
    //Share_pref()
    //   .save_data("driver_name", result["name"] + " " + result["surname"]);
    //  print(result);
    return result["driverID"];
  }

  Future<dynamic> get_driver_profile() async {
    String driverID = await Share_pref().read_data("driverID");
    Map param = {"driverID": driverID};

    final result = await API().callApi("get_user_profile", param);

    Share_pref().save_data("driverType", result["driver_typeID"]);
    //  Share_pref().save_data("driver_name", result["driver_name"]);
    if (result["file_pictureID"] != null) {
      String url = API().urlPrefix;
      String urlReplace = url.replaceAll("/driver_api", "");

      result["driver_pic"] = urlReplace + "/" + result["file_pictureID"];
    }

    return result;
  }

  Future<List> get_driver() async {
    var driverID = await Share_pref().read_data("driverID");
    String urlProfile = "get_driver";
    Map paramDriver = {"driverID": driverID};

    final result = await API().callApi(urlProfile, paramDriver);
    // String driver_name = result["driver_name"].toString();
    // String token = result["token"].toString();

    return result;
  }

  Future<dynamic> update_driver_tel(String driver_tel) async {
    var driverID = await Share_pref().read_data("driverID");

    String urlProfile = "update_driver";
    Map paramDriver = {"driverID": driverID, "tel1": driver_tel};

    final result = await API().callApi(urlProfile, paramDriver);

    return result;
  }

  Future<dynamic> update_driver_address(dynamic driver_address) async {
    var driverID = await Share_pref().read_data("driverID");

    String urlProfile = "update_driver";
    Map paramDriver = {"driverID": driverID, "address": driver_address};
    // print(paramDriver);
    final result = await API().callApi(urlProfile, paramDriver);
    return result;
  }

  Future<bool> is_driver_EGAT() async {
    List<String> _egat_type = ["drv_egat", "drv_spc"];
    // print(_egat_type);
    String drv_type = await Share_pref().read_data("driverType");
    //  print(drv_type);
    if (_egat_type.contains(drv_type)) {
      return true;
    } else {
      return false;
    }
  }
}
