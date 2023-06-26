import 'package:flutter/material.dart';
import 'package:planner_app/models/plannel.dart';
import 'package:provider/provider.dart';

class UserData extends StatefulWidget {
  const UserData({super.key});

  @override
  State<UserData> createState() => _UserDataState();
}

class _UserDataState extends State<UserData> {
  @override
  Widget build(BuildContext context) {
    final users = Provider.of<List<Planner>>(context);

    users.forEach((user) {
      print(user.name);
      print(user.email);
    });

    return Text(users.toString());
  }
}
