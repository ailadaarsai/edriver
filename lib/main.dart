// ignore_for_file: prefer_const_constructors, unused_import, deprecated_member_use
import 'package:edriver/flutter/packages/flutter/test/cupertino/sliding_segmented_control_test.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:io';
import 'dart:async';
import 'package:flutter/services.dart' show rootBundle;
import 'package:flutter/src/widgets/framework.dart';
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
import 'package:url_launcher/url_launcher.dart';
import 'package:responsive_framework/responsive_framework.dart';



final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  bool checkversion = await checkAppVersion();
  if (checkversion) {
    runApp(const MyApp());
  } else {
    print('missed');
    runApp(const ShowDialogExampleApp());
  }
  print('App Run');
  AwesomeNotifications().initialize('resource://drawable/logo', [
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

class ShowDialogExampleApp extends StatelessWidget {
  const ShowDialogExampleApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: DialogExample(),
    );
  }
}

class DialogExample extends StatelessWidget {
  const DialogExample({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Future.delayed(Duration.zero, () {
      _dialogBuilder(context);
    });

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

  Future<void> _dialogBuilder(BuildContext context) {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Version Outeded'),
          content: const Text(
            'Please update version lasted on store.',
          ),
          actions: <Widget>[
            TextButton(
              style: TextButton.styleFrom(
                textStyle: Theme.of(context).textTheme.headline6,
              ),
              child: const Text('OK'),
              onPressed: () {
                _launchAppStore();
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> _launchAppStore() async {
    final Uri appStoreUrl =
        Uri.parse('https://ecar.egat.co.th/ebus_ipa/edriver.apk');
    if (await launchUrl(appStoreUrl)) {
      await launchUrl(appStoreUrl);
    } else {
      throw Exception('Could not launch $appStoreUrl');
    }
  }
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return OverlaySupport(
      child: MaterialApp(
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

Future<bool> checkAppVersion() async {
  final currentVersion = await getCurrentAppVersionFromJson();
  final latestVersion = await getLatestAppVersion();
  print(currentVersion);
  print(latestVersion);
  if (currentVersion != latestVersion) {
    return false;
  } else {
    return true;
  }
}


Future<String> getCurrentAppVersionFromJson() async {
  try {
    final jsonContent = await rootBundle.loadString('assets/version.json');
    final jsonData = json.decode(jsonContent);
    final latestVersion = jsonData['version'];
    return latestVersion;
  } catch (e) {
    print('Error reading version.json: $e');
    return ''; // Return empty string or handle the error as needed
  }
}

Future<String> getLatestAppVersion() async {
  final response = await http
      .get(Uri.parse('https://ecar.egat.co.th/ebus_ipa/edrriver_version.json'));
  if (response.statusCode == 200) {
    return jsonDecode(response.body)['version'];
  } else {
    throw Exception('Failed to get latest app version');
  }
}
