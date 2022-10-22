import 'package:flutter/material.dart';
import 'package:plants_care/features/home/presentation/pages/view/home_base.dart';

void main() {
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

