import 'package:flutter/material.dart';
import 'package:planner_app/authenticate/SignIn.dart';
import 'package:planner_app/authenticate/Signup.dart';

class Authenticate extends StatefulWidget {
  final bool? Register;

  const Authenticate({super.key, this.Register});

  @override
  _AuthenticateState createState() => _AuthenticateState();
}

class _AuthenticateState extends State<Authenticate> {
  @override
  Widget build(BuildContext context) {
    if (widget.Register == true) {
      return SignUpPage();
    } else {
      return SignInPage();
    }
  }
}
