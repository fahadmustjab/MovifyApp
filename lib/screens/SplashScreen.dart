import 'package:flutter/material.dart';
import 'package:movie/screens/HomeScreen.dart';
import 'package:movie/screens/MovieScreen.dart';
import 'package:get/get.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  final TextEditingController searchController = TextEditingController();
  @override
  void initState() {
    super.initState();
    Future.delayed(Duration(seconds: 3), () {
      Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => MainScreen(),
          ));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SingleChildScrollView(
        child: Column(
          children: [
            Image.asset('assets/splash1.png'),
            Center(
              child: Image.asset(
                'assets/splash3.png',
                width: 200,
                height: 200,
              ),
            ),
            Container(
              child: Image.asset('assets/splash2.png'),
            )
          ],
        ),
      ),
    );
  }
}
