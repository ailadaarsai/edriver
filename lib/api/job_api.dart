import 'package:edriver/api/share_pref.dart';
import '../theme/app_style.dart';
import 'api.dart';

class Job_api {
  Future<List> get_new_job() async {
    var driverID = await Share_pref().read_data("driverID");
    String urlProfile = "new_job";
    Map paramDriver = {"driverID": driverID};

    final result = await API().callApi(urlProfile, paramDriver);

    return result;
  }

  Future<List> get_today_job() async {
    var driverID = await Share_pref().read_data("driverID");
    String urlProfile = "job_today";
    Map paramDriver = {"driverID": driverID};

    final result = await API().callApi(urlProfile, paramDriver);

    return result;
  }

  Future<List> get_job_detail(reserve_detail_jobID) async {
    String urlProfile = "job_detail";
    Map paramDriver = {"reserve_detail_jobID": reserve_detail_jobID};

    final result = await API().callApi(urlProfile, paramDriver);

    return result;
  }

  Future<void> confirm_job(String reserve_detail_jobID) async {
    String urlProfile = "confirm_job";
    Map paramDriver = {"reserve_detail_jobID": reserve_detail_jobID};

    final result = await API().callApi(urlProfile, paramDriver);
    if (result == "success") {
      AppStyle().toast_text_green("ยืนยันรับงานเรียบร้อยแล้ว");
    }
    return result;
  }

  Future<void> read_notify(String notifyID) async {
    String urlProfile = "read_notify";
    Map paramDriver = {"driver_notifyID": notifyID};

    final result = await API().callApi(urlProfile, paramDriver);

    return result;
  }

  Future<List> job_remain() async {
    var driverID = await Share_pref().read_data("driverID");
    print(driverID);
    String urlProfile = "job_remain";
    Map paramDriver = {"driverID": driverID};

    final result = await API().callApi(urlProfile, paramDriver);
    print(result);

    return result;
  }

  Future<List> get_notify_unread() async {
    var driverID = await Share_pref().read_data("driverID");

    String urlProfile = "get_all_notify";
    Map paramDriver = {"driverID": driverID};

    final result = await API().callApi(urlProfile, paramDriver);
    return result;
  }

  Future<List> getDateJob() async {
    var driverID = await Share_pref().read_data("driverID");

    String urlProfile = "driver_count_job";
    Map paramDriver = {"driverID": driverID};

    final result = await API().callApi(urlProfile, paramDriver);
    return result;
  }

  Future<List> driverCalendar() async {
    var driverID = await Share_pref().read_data("driverID");

    String urlProfile = "driver_calendar";
    Map paramDriver = {"driverID": driverID};

    final result = await API().callApi(urlProfile, paramDriver);
    return result;
  }

  Future<dynamic> get_mileData(Map param) async {
    String urlProfile = "get_mileData";

    final result = await API().callApi(urlProfile, param);

    return result;
  }

  Future<dynamic> save_mile(Map param) async {
    String urlProfile = "save_mile";
    final result = await API().callApi(urlProfile, param);
    return result;
  }

  Future<dynamic> save_time(Map param) async {
    String url = "time_record";

    final result = await API().callApi(url, param);

    return result;
  }

  Future<Map> get_job_detail_close(String jobID) async {
    String urlProfile = "get_job_detail_close";
    Map paramDriver = {"jobID": jobID};
    Map result = await API().callApi(urlProfile, paramDriver);

    return result;
  }

  Future<Map> job_detail(String jobID) async {
    String urlProfile = "get_job_detail";
    Map paramDriver = {"jobID": jobID};
    Map result = await API().callApi(urlProfile, paramDriver);

    return result;
  }

  Future<List> job_time_record(paramDriver) async {
    String urlProfile = "job_time_record";

    final result = await API().callApi(urlProfile, paramDriver);

    return result;
  }

  Future<dynamic> checkUpCar(Map param) async {
    String urlProfile = "checkUpCar";
    final result = await API().callApi(urlProfile, param);

    return result;
  }

  Future<dynamic> checkUpCar_history(Map param) async {
    String urlProfile = "get_checkUpCar";
    final result = await API().callApi(urlProfile, param);

    return result;
  }

  Future<Map> sumCost(Map param) async {
    String urlProfile = "get_sum_cost";

    final result = await API().callApi(urlProfile, param);

    return result;
  }

  Future<dynamic> costRecord(Map param) async {
    String urlProfile = "cost_record";
    final result;
    result = await API().callApi(urlProfile, param);
    return result;
  }

  Future<List> get_costRecord(param) async {
    String urlProfile = "get_costRecord";

    final result = await API().callApi(urlProfile, param);

    return result;
  }

  Future<dynamic> get_cost(Map param) async {
    String urlProfile = "get_costRow";

    final result = await API().callApi(urlProfile, param);

    return result;
  }

  Future<dynamic> sent_report(Map param) async {
    String urlProfile = "sent_report";

    final result = await API().callApi(urlProfile, param);

    return result;
  }

  Future<dynamic> delete_cost(param) async {
    String urlProfile = "delete_costID";

    final result = await API().callApi(urlProfile, param);

    return result;
  }

  get_job_status(driver_action) {
    var status = {"is_edit": false, "status_name": ""};
    if (driver_action.toString() == "0") {
      status["is_edit"] = false;
      status["status_name"] = "ยังไม่จัดรถ";
    } else if (driver_action.toString() == "1") {
      status["is_edit"] = true;
      status["status_name"] = "พขร. ยืนยันงานแล้ว";
    } else if (driver_action.toString() == "7") {
      status["is_edit"] = false;
      status["status_name"] = "กดส่งรายงานการเดินทางแล้ว";
    } else if (driver_action.toString() == "8") {
      status["is_edit"] = false;
      status["status_name"] = "รอ พขร. กดยืนยันงาน";
    }
    return status;
  }
    Future<dynamic> search_job_no(Map param) async {
    String urlProfile = "search_job_no";

    final result = await API().callApi(urlProfile, param);

    return result;
  }
}
