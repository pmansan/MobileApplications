import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:planner_app/firebase_options.dart';
// import 'package:planner_app/screens/ActivitiesList.dart';
// import 'package:planner_app/screens/CreateActivity.dart';
// import 'package:planner_app/screens/Home.dart';
// import 'package:planner_app/screens/Login.dart';
// import 'package:planner_app/screens/ActivitiesList.dart';
import 'package:planner_app/screens/Start.dart';
import 'package:planner_app/screens/wrapper.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      //Página a la que redirige cuando se enciende
      home: Wrapper(),
    );
  }
}
