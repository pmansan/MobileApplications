import 'package:flutter/material.dart';
import 'package:planner_app/components/my_button.dart';
import 'package:planner_app/components/my_button_anon_signin.dart';
import 'package:planner_app/components/my_textfield.dart';
import 'package:planner_app/screens/Home.dart';
import 'package:planner_app/services/auth.dart';
//import 'package:planner_app/components/square_tile.dart';

class SignInPage extends StatefulWidget {
  const SignInPage({super.key});

  @override
  State<SignInPage> createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  // text editing controllers
  final usernameController = TextEditingController();
  final passwordController = TextEditingController();

  // Authentication instance
  final AuthService _auth = AuthService();

  // sign user in method
  void signUserIn() {}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.white,
      //With app bar
      appBar: AppBar(
        iconTheme: const IconThemeData(
            color: Color(0xffb3a78b1), size: 35 //change your color here
            ),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            //Title text
            Padding(
              padding: const EdgeInsets.only(left: 30.0, bottom: 30),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                mainAxisSize: MainAxisSize.max,
                verticalDirection: VerticalDirection.down,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Text(
                    'Sign in',
                    style: TextStyle(
                        color: Color(0xfb3a78b1),
                        fontFamily: 'Nunito',
                        fontSize: 28,
                        fontWeight: FontWeight.bold),
                  ),
                ], //Children
              ),
            ),

            Padding(
              padding: const EdgeInsets.only(left: 30.0, bottom: 15),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: const [
                  Text(
                    'E-mail',
                    style: TextStyle(
                        color: Color(0xfb3a78b1),
                        fontFamily: 'Nunito',
                        fontSize: 20,
                        fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),

            // username textfield
            MyTextField(
              controller: usernameController,
              hintText: '',
              obscureText: false,
            ),

            //Password text
            Padding(
              padding: const EdgeInsets.only(left: 30.0, bottom: 15),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: const [
                  Text(
                    'Password',
                    style: TextStyle(
                        color: Color(0xfb3a78b1),
                        fontFamily: 'Nunito',
                        fontSize: 20,
                        fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),

            // Password textfield
            MyTextField(
              controller: passwordController,
              hintText: '',
              obscureText: true,
            ),

            // forgot password? text
            Padding(
              padding:
                  const EdgeInsets.only(left: 30.0, right: 30, bottom: 180),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text(
                    'Forgot Password?',
                    style: TextStyle(
                      color: Colors.grey[600],
                      fontFamily: 'Nunito',
                    ),
                  ),
                ],
              ),
            ),

            // sign in button
            MyButton(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => HomePage()),
                );
              },
            ),

            Padding(
              padding: const EdgeInsets.only(left: 30.0, right: 30),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Or',
                    style: TextStyle(color: Colors.grey[600]),
                  ),
                ],
              ),
            ),

            MyButton_Anon(
              onTap: () async {
                dynamic result = await _auth.signInAnon();
                if (result == null) {
                  print("Error signin in");
                } else {
                  print("Signing in succesful");
                }
              },
            ),
          ], //children
        ),
      ),
    );
    ;
  }
}