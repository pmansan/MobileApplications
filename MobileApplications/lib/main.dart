import 'package:flutter/material.dart';
import 'package:MobileApplications/screens/QuizzPage.dart';
import 'package:MobileApplications/screens/homepage.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          primarySwatch: Colors.indigo,
        ),
        initialRoute: '/',
        routes: {
          '/': (context) => const HomePage(),
          '/quizzpage': (context) => const QuizzPage()
        });
  }
}
