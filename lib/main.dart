import 'package:flutter/material.dart';
import 'package:eztalk/utilities/router.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Eztalk',
      routes: Routes.routes,
      home: Routes.homeRoute!(context),
    );
  }
}
