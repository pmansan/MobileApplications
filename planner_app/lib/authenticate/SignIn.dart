import 'package:flutter/material.dart';
import 'package:planner_app/components/constants.dart';
import 'package:planner_app/components/loading.dart';
import 'package:planner_app/components/my_button.dart';
import 'package:planner_app/components/my_button_anon_signin.dart';
import 'package:planner_app/services/auth.dart';

class SignInPage extends StatefulWidget {
  const SignInPage({super.key});

  @override
  State<SignInPage> createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  String email = '';
  String password = '';
  String error = '';

  bool loading = false;

  // Authentication instance
  final AuthService _auth = AuthService();

  final _formKey = GlobalKey<FormState>();

  // sign user in method
  void signUserIn() {}

  @override
  Widget build(BuildContext context) {
    return loading
        ? Loading()
        : Scaffold(
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
              child: Form(
                key: _formKey,
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
                    TextFormField(
                        validator: (String? val) =>
                            val!.isEmpty ? "Enter an email" : null,
                        onChanged: (val) {
                          setState(() => email = val);
                        },
                        obscureText: false,
                        decoration:
                            textInputDecoration.copyWith(hintText: 'Email')),

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

                    TextFormField(
                        validator: (String? val) => val!.length < 6
                            ? "Enter a password 6+ chars long"
                            : null,
                        onChanged: (val) {
                          setState(() => password = val);
                        },
                        obscureText: true,
                        decoration:
                            textInputDecoration.copyWith(hintText: 'Password')),

                    // forgot password? text
                    Padding(
                      padding: const EdgeInsets.only(
                          left: 30.0, right: 30, bottom: 100),
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
                    SizedBox(height: 10),
                    MyButton(
                      onTap: () async {
                        if (_formKey.currentState!.validate()) {
                          setState(() => loading = true);
                          dynamic result =
                              await _auth.signInEmail(email, password);
                          if (result == null) {
                            setState(() {
                              error = 'Invalid credentials';
                              loading = false;
                            });
                          }
                        }
                      },
                    ),
                    SizedBox(height: 1),
                    Text(
                      error,
                      style: TextStyle(color: Colors.red, fontSize: 18),
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

                    SizedBox(height: 20),
                    MyButton_Anon(
                      onTap: () async {
                        setState(() => loading = true);
                        dynamic result = await _auth.signInAnon();
                        setState(() => loading = false);
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
            ),
          );
    ;
  }
}
