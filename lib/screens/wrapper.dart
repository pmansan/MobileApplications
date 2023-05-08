import 'package:flutter/material.dart';
import 'package:planner_app/models/user.dart';
import 'package:planner_app/screens/Home.dart';
import 'package:planner_app/screens/Start.dart';
import 'package:provider/provider.dart';
import 'package:planner_app/models/user.dart';

class Wrapper extends StatelessWidget {
  const Wrapper({super.key});

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<MyUser?>(context);
    print(user);
    if (user == null) {
      print('Signed out');
      return StartPage();
    } else {
      return HomePage();
    }
  }
}
