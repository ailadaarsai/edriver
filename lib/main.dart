// ignore_for_file: prefer_const_constructors
import 'dart:io';
import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:edriver/screen/calendar.dart';
import 'package:edriver/screen/job_new.dart';
import 'package:edriver/screen/job_today.dart';
import 'package:edriver/screen/time_record.dart';
import 'package:edriver/theme/app_style.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:edriver/screen/home.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:overlay_support/overlay_support.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

Future<void> main() async {
  //

  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  runApp(const MyApp());

  AwesomeNotifications().initialize('resource://drawable/logo', [
    // notification icon
    NotificationChannel(
      channelKey: 'k1',
      channelName: 'time_record',
      channelDescription: 'time_record_notification',
      playSound: true,
      enableVibration: true,
      enableLights: true,
      channelShowBadge: true,
      defaultColor: Colors.green[200],
      ledColor: Colors.white,
      importance: NotificationImportance.High,
    ),
  ]);

  ReceivedAction? receivedAction = await AwesomeNotifications()
      .getInitialNotificationAction(removeFromActionEvents: false);
  if (receivedAction?.channelKey == 'k1')
    jobTodayScreen();
  else
    HomeScreen();
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return OverlaySupport(
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        localizationsDelegates: [
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: [
          const Locale('en', 'US'), // English
          const Locale('th', 'TH'), // Thai
        ],
        title: 'eCar_driver',
        theme: ThemeData(
          primarySwatch: Colors.green,
        ),
        home: HomeScreen(),
      ),
    );
  }
}
