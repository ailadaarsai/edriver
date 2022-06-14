import 'dart:io';
import 'package:edriver/provider/user_profile.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sembast/sembast.dart';
import 'package:sembast/sembast_io.dart';

class DBConnect {
  // String dbName = "edriver"; //เก็บชื่อฐานข้อมูล

  // ถ้ายังไม่ถูกสร้าง => สร้าง
  // ถูกสร้างไว้แล้ว => เปิด
  // DBConnect("edriver");

  Future<Database> openDatabase() async {
    //หาตำแหน่งที่จะเก็บข้อมูล
    Directory appDirectory = await getApplicationDocumentsDirectory();
    String dbLocation = join(appDirectory.path, "edriver");
    // สร้าง database
    DatabaseFactory dbFactory = databaseFactoryIo;
    Database db = await dbFactory.openDatabase(dbLocation);
    return db;
  }

  /// insert User Proffile
  Future<int> InsertUserProfile(User_profile statement) async {
    var db = await openDatabase();
    var store = intMapStoreFactory.store("user_profile");

    var keyID = store.add(db, {
      "driverID": statement.driverID,
      "driverType": statement.driverType,
      "driver_name": statement.driver_name,
      "driver_pic": statement.driver_pic,
      "empID": statement.empID,
      "IDcard": statement.IDCard,
      "wage_cost": statement.wage_cost,
      "hotel_cost": statement.hotel_cost,
      "ot_rate": statement.ot_rate
    });
    db.close();
    return keyID;
  }

  ///ดึงข้อมูล User profile
  Future getUserProfile() async {
    var db = await openDatabase();
    var store = intMapStoreFactory.store("user_profile");
    var snapshot = await store.find(db);
    // Map userList = List<User_profile>();
    return snapshot;
  }
}
