import 'package:flutter/material.dart';

import '../api/api.dart';
import '../theme/app_style.dart';

class NotifyScreeen extends StatefulWidget {
  const NotifyScreeen({Key? key}) : super(key: key);

  @override
  State<NotifyScreeen> createState() => _NotifyScreeenState();
}

class _NotifyScreeenState extends State<NotifyScreeen> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: API().read_data("driver_name"),
      builder: (context, snapshot) {
        return Scaffold(
          appBar: AppBar(
            title: const Text("การแจ้งเตือน"),
            actions: const <Widget>[
              // AppStyle().form_notify(),
            ],
          ),
          body: const Center(
            child: Text(
              'การแจ้งเตือน ',
              style: TextStyle(fontSize: 24),
            ),
          ),
          bottomNavigationBar: AppStyle().butoom_bar(context, 2),
        );

        return const CircularProgressIndicator(); // or some other widget
      },
    );
  }
}
