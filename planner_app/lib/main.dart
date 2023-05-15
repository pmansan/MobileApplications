import 'package:flutter/material.dart';
import 'package:planner_app/screens/CreateActivity.dart';
// import 'package:planner_app/screens/ActivitiesList.dart';
// import 'package:planner_app/screens/CreateActivity.dart';
// import 'package:planner_app/screens/Home.dart';
// import 'package:planner_app/screens/Login.dart';
// import 'package:planner_app/screens/ActivitiesList.dart';
import 'package:planner_app/screens/Start.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(fontFamily: 'Nunito'),
      //Página a la que redirige cuando se enciende
      home: StartPage(),
    );
  }
}