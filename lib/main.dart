import 'dart:io';

import 'package:flutter/material.dart';
import 'package:movie/screens/MovieScreen.dart';
import 'package:movie/screens/SplashScreen.dart';
import 'package:get/get.dart';
import 'package:movie/screens/testScreen.dart';

import 'screens/DescriptionScreen.dart';

void main() {
  HttpOverrides.global = new MyHttpOverrides();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.indigo,
      ),
      initialRoute: '/',
      getPages: [
        GetPage(name: '/', page: () => const SplashScreen()),
        GetPage(name: '/home', page: () => const MovieScreen()),
      ],
      home: SplashScreen(),
    );
  }
}

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}
