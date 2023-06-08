import 'package:flutter/material.dart';
import 'package:planner_app/components/constants.dart';
import 'package:planner_app/components/loading.dart';
import 'package:planner_app/components/my_button2.dart';
import 'package:planner_app/services/auth.dart';

import '../components/my_button.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  // text editing controllers
  String email = '';
  String password = '';
  String error = '';

  bool loading = false;

  final AuthService _auth = AuthService();

  final _formKey = GlobalKey<FormState>();

  // sign user in method
  void signUserIn() {}


  @override
  Widget build(BuildContext context) {
    final Size screenSize = MediaQuery.of(context).size;
    final double screenWidth = screenSize.width;
    final double screenHeight = screenSize.height;

    return loading
        ? Loading()
        : Scaffold(
            resizeToAvoidBottomInset: false,
            backgroundColor: Colors.white,
            appBar: AppBar(
              iconTheme: const IconThemeData(
                color: Color(0xffb3a78b1),
                size: 35,
              ),
              backgroundColor: Colors.white,
              elevation: 0,
            ),
            body: SafeArea(
              child: SingleChildScrollView(
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Padding(
                        padding: EdgeInsets.only(
                          left: 0.08 * screenWidth,
                          bottom: 0.06 * screenHeight,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          mainAxisSize: MainAxisSize.max,
                          verticalDirection: VerticalDirection.down,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: const [
                            Text(
                              'Sign up',
                              style: TextStyle(
                                color: Color(0xfb3a78b1),
                                fontFamily: 'Nunito',
                                fontSize: 28,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(
                          left: 0.08 * screenWidth,
                          bottom: 0.03 * screenHeight,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: const [
                            Text(
                              'E-mail',
                              style: TextStyle(
                                color: Color(0xfb3a78b1),
                                fontFamily: 'Nunito',
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(
                          left: 0.08 * screenWidth,
                          right: 0.08 * screenWidth,
                          bottom: 0.01 * screenHeight,
                        ),
                        child: TextFormField(
                          validator: (String? val) =>
                              val!.isEmpty ? "Enter an email" : null,
                          onChanged: (val) {
                            setState(() => email = val);
                          },
                          obscureText: false,
                          decoration:
                              textInputDecoration.copyWith(hintText: 'Email'),
                        ),
                      ),
                      SizedBox(height: 0.02 * screenHeight),
                      Padding(
                        padding: EdgeInsets.only(
                          left: 0.08 * screenWidth,
                          bottom: 0.03 * screenHeight,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: const [
                            Text(
                              'Password',
                              style: TextStyle(
                                color: Color(0xfb3a78b1),
                                fontFamily: 'Nunito',
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(
                          left: 0.08 * screenWidth,
                          right: 0.08 * screenWidth,
                          bottom: 0.03 * screenHeight,
                        ),
                        child: TextFormField(
                          validator: (String? val) => val!.length < 6
                              ? "Enter a password 6+ chars long"
                              : null,
                          onChanged: (val) {
                            setState(() => password = val);
                          },
                          obscureText: true,
                          decoration:
                              textInputDecoration.copyWith(hintText: 'Password'),
                        ),
                      ),
                      SizedBox(height: 0.12 * screenHeight),
                      MyButton(
                        onTap: () async {
                          if (_formKey.currentState!.validate()) {
                            setState(() => loading = true);
                            dynamic result =
                                await _auth.registerEmail(email, password);
                            if (result == null) {
                              setState(() {
                                error = 'Invalid credentials';
                                loading = false;
                              });
                            }
                          }
                        },
                      ),
                      SizedBox(height: 0.014 * screenHeight),
                      Text(
                        error,
                        style: TextStyle(color: Colors.red, fontSize: 18),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
  }
}

