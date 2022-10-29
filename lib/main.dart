import 'dart:developer';

import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:plants_care/core/utils/injector.dart' as di;
import 'package:plants_care/core/utils/notification_helper.dart';
import 'package:plants_care/core/utils/shared_pref_helper.dart';
import 'package:plants_care/features/base/view_model_provider.dart';
import 'package:plants_care/features/home/data/data_sources/local_data_source.dart';
import 'package:plants_care/features/home/presentation/pages/view/home_base.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();

  di.init();
  await SharedPrefHelper.initialize();
  await NotificationHelper.initialize();
  //final a = await AwesomeNotifications().getLocalTimeZoneIdentifier();
  await di.injector<LocalDataSource>().openDB();

  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]);

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner:false,
      title: 'Plants Care',
      home: HomeBasePage(),
    );
  }
}

