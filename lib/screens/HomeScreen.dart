import 'package:flutter/material.dart';
import 'package:movie/screens/MovieScreen.dart';
import 'package:movie/screens/SeasonsScreen.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  final TextEditingController searchController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      initialIndex: 1,
      length: 2,
      child: Scaffold(
        backgroundColor: Colors.indigo,
        appBar: AppBar(
          bottom: const TabBar(tabs: [
            Tab(
              text: 'Movies',
            ),
            Tab(
              text: 'Seasons',
            )
          ]),
        ),
        body: const TabBarView(children: [
          MovieScreen(),
          SeasonsScreen(),
        ]),
      ),
    );
  }
}
