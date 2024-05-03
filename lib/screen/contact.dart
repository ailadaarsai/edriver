import 'package:edriver/api/share_pref.dart';
import 'package:flutter/material.dart';
import 'package:edriver/theme/app_style.dart';

class ContactScreeen extends StatefulWidget {
  const ContactScreeen({Key? key}) : super(key: key);

  @override
  State<ContactScreeen> createState() => _ContactScreeenState();
}

class _ContactScreeenState extends State<ContactScreeen> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: Share_pref().read_data("driver_name"),
      builder: (context, snapshot) {
        return Scaffold(
          appBar: AppBar(
            title: const Text("ติดต่อสถานี"),
            actions: <Widget>[
              AppStyle().form_notify(context),
            ],
          ),
          body: SingleChildScrollView(
            child: Container(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(30, 20, 30, 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Text("สถานีจัดรถ",
                        style: TextStyle(fontSize: 24, color: Colors.green)),
                    Divider(color: Colors.green, height: 15),
                    AppStyle().space_box(15),
                    row_station("สถานีรถเก๋ง", "024365222"),
                    row_station("สถานีรถตู้", "024360578"),
                    row_station("สถานีรถบัส", "024365243"),
                    AppStyle().space_box(30),
                    Text("ธุรการ",
                        style: TextStyle(fontSize: 24, color: Colors.green)),
                    Divider(color: Colors.green, height: 20),
                    AppStyle().space_box(15),
                    row_station("สถานีรถเก๋ง", "024360574"),
                    row_station("สถานีรถตู้", "024365226"),
                    row_station("สถานีรถบัส", "024365226"),
                  ],
                ),
              ),
            ),
          ),
          bottomNavigationBar: AppStyle().butoom_bar(context, 4),
        );

        return AppStyle().open_loading(); // or some other widget
      },
    );
  }

  Widget row_station(String staion_name, String phone_num) {
    return Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
      Text(staion_name, style: TextStyle(fontSize: 20)),
      btn_tel(phone_num)
    ]);
  }

  Widget btn_tel(String phone_num) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        ElevatedButton(
          onPressed: () {
            AppStyle().callNumber(phone_num);
          },
          child: const Text(
            "โทร.",
            style: TextStyle(fontSize: 16.0, color: Colors.white),
          ),
          style: ElevatedButton.styleFrom(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(28.0),
            ),
            primary: Colors.green,
            minimumSize: const Size(80, 30),
          ),
        ),
      ],
    );
  }
}
