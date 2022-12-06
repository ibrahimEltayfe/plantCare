import 'dart:developer';
import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:plants_care/core/utils/notification_helper.dart';
import 'package:plants_care/core/utils/shared_pref_helper.dart';
import 'package:plants_care/features/home/presentation/view/home_base.dart';

import 'features/home/data/data_sources/local_data_source.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();

  await SharedPrefHelper.initialize();
  await NotificationHelper.initialize();

  final container = ProviderContainer();
  await container.read( localDataSourceProvider).openDB();

  final a = await AwesomeNotifications().getLocalTimeZoneIdentifier();
  log(a);

  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]);

  runApp(
      UncontrolledProviderScope(
        container: container,
        child: const MyApp()
      )
  );
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

