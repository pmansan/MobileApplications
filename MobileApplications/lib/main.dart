import 'package:flutter/material.dart';
import 'package:sampleproject/QuizzPage.dart';
import 'package:sampleproject/homepage.dart';
import 'package:sampleproject/QuizzPage.dart';


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
          '/':(context) => const HomePage(),
          '/quizzpage': (context) => const QuizzPage()
        }
    );
  }
}