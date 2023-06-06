import 'package:flutter/material.dart';
import 'package:planner_app/components/constants.dart';
import 'package:planner_app/components/loading.dart';
import 'package:planner_app/components/my_button2.dart';
import 'package:planner_app/services/auth.dart';

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
    return loading
        ? Loading()
        : Scaffold(
            resizeToAvoidBottomInset: false,
            backgroundColor: Colors.white,
            //App Bar
            appBar: AppBar(
              iconTheme: const IconThemeData(
                  color: Color(0xffb3a78b1), size: 35 //change your color here
                  ),
              backgroundColor: Colors.white,
              elevation: 0,
            ),

            body: SafeArea(
              //Columna para que sea hacia abajo
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
                            'Sign up',
                            style: TextStyle(
                                color: Color(0xfb3a78b1),
                                fontFamily: 'Nunito',
                                fontSize: 28,
                                fontWeight: FontWeight.bold),
                          ),
                        ], //Children
                      ),
                    ),

                    //Emailtext
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

                    // Email or username textfield
                    TextFormField(
                        validator: (String? val) =>
                            val!.isEmpty ? "Enter an email" : null,
                        onChanged: (val) {
                          setState(() => email = val);
                        },
                        obscureText: false,
                        decoration:
                            textInputDecoration.copyWith(hintText: 'Email')),

                    const SizedBox(height: 30),

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

                    // const SizedBox(height: 15),

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

                    const SizedBox(height: 150),

                    // Sign up button
                    MyButton2(
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

                    SizedBox(height: 12),
                    Text(
                      error,
                      style: TextStyle(color: Colors.red, fontSize: 18),
                    )
                  ], //children
                ),
              ),
            ),
          );
    ;
  }
}
