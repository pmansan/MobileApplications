import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:planner_app/firebase_options.dart';
import 'package:planner_app/models/user.dart';
import 'package:planner_app/screens/wrapper.dart';
import 'package:planner_app/services/auth.dart';
import 'package:provider/provider.dart';
import 'package:planner_app/screens/CreateActivity.dart';

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
    return StreamProvider<MyUser?>.value(
      value: AuthService().user,
      initialData: null,
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(fontFamily: 'Nunito'),
        //Página a la que redirige cuando se enciende
        home: Wrapper(),
      ),
    );
  }
}
