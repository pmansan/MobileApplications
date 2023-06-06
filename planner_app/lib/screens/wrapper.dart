import 'package:flutter/material.dart';
import 'package:planner_app/authenticate/authenticate.dart';
import 'package:planner_app/models/user.dart';
import 'package:planner_app/screens/Home.dart';
import 'package:provider/provider.dart';

class Wrapper extends StatelessWidget {
  bool? Register;

  Wrapper({super.key, this.Register});

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<MyUser?>(context);
    print('User-->' + user.toString());
    if (user == null) {
      return Authenticate(Register: Register);
    } else {
      return HomePage();
    }
  }
}
