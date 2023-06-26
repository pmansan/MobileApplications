import 'package:flutter/material.dart';
import 'package:planner_app/components/constants.dart';
import 'package:planner_app/components/loading.dart';
import 'package:planner_app/components/my_button.dart';
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
                // size: 0.05 * screenSize.width, // Cambia el tamaño aquí
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
                          left:
                              0.08 * screenSize.width, // Cambia el espacio aquí
                          bottom: 0.06 *
                              screenSize.height, // Cambia el espacio aquí
                        ),
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
                                fontSize: 20, // Cambia el tamaño aquí
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(
                          left:
                              0.08 * screenSize.width, // Cambia el espacio aquí
                          bottom: 0.03 *
                              screenSize.height, // Cambia el espacio aquí
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: const [
                            Text(
                              'E-mail',
                              style: TextStyle(
                                color: Color(0xfb3a78b1),
                                fontFamily: 'Nunito',
                                fontSize: 15, // Cambia el tamaño aquí
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                          padding: EdgeInsets.only(
                            left: 0.08 *
                                screenSize.width, // Cambia el espacio aquí
                            right: 0.08 *
                                screenSize.width, // Cambia el espacio aquí
                            bottom: 0.01 *
                                screenSize.height, // Cambia el espacio aquí
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
                          )),
                      Padding(
                        padding: EdgeInsets.only(
                          left:
                              0.08 * screenSize.width, // Cambia el espacio aquí
                          bottom: 0.03 *
                              screenSize.height, // Cambia el espacio aquí
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: const [
                            Text(
                              'Password',
                              style: TextStyle(
                                color: Color(0xfb3a78b1),
                                fontFamily: 'Nunito',
                                fontSize: 15, // Cambia el tamaño aquí
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                          padding: EdgeInsets.only(
                            left: 0.08 *
                                screenSize.width, // Cambia el espacio aquí
                            right: 0.08 *
                                screenSize.width, // Cambia el espacio aquí
                            bottom: 0.01 *
                                screenSize.height, // Cambia el espacio aquí
                          ),
                          child: TextFormField(
                            validator: (String? val) => val!.length < 6
                                ? "Enter a password 6+ chars long"
                                : null,
                            onChanged: (val) {
                              setState(() => password = val);
                            },
                            obscureText: true,
                            decoration: textInputDecoration.copyWith(
                                hintText: 'Password'),
                          )),
                      // Padding(
                      //   padding: EdgeInsets.only(
                      //     left:
                      //         0.6 * screenSize.width, // Cambia el espacio aquí
                      //     right:
                      //         0.08 * screenSize.width, // Cambia el espacio aquí
                      //     bottom: 0.05 *
                      //         screenSize.height, // Cambia el espacio aquí
                      //   ),
                      //   child: Row(
                      //     mainAxisAlignment: MainAxisAlignment.end,
                      //     children: [
                      //       Text(
                      //         'Forgot Password?',
                      //         style: TextStyle(
                      //           color: Colors.grey[600],
                      //           fontFamily: 'Nunito',
                      //         ),
                      //       ),
                      //     ],
                      //   ),
                      // ),
                      // SizedBox(height: 0.02 * screenSize.height), // Cambia el espacio aquí
                      Padding(
                          padding: EdgeInsets.only(
                              left: 0.08 *
                                  screenSize.width, // Cambia el espacio aquí
                              right: 0.08 *
                                  screenSize.width, // Cambia el espacio aquí
                              top: 0.2 *
                                  screenSize.height // Cambia el espacio aquí
                              ),
                          child: MyButton(
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
                          )),
                      // SizedBox(height: 0.0002 * screenSize.height), // Cambia el espacio aquí
                      Text(
                        error,
                        style: TextStyle(color: Colors.red, fontSize: 18),
                      ),
                      // Padding(
                      //   padding: EdgeInsets.only(
                      //       left: 0.08 * screenSize.width,
                      //       right: 0.08 * screenSize.width),
                      //   child: Row(
                      //     mainAxisAlignment: MainAxisAlignment.center,
                      //     children: [
                      //       Text(
                      //         'Or',
                      //         style: TextStyle(color: Colors.grey[600]),
                      //       ),
                      //     ],
                      //   ),
                      // ),
                      // SizedBox(height: 0.0002 * screenSize.height), // Cambia el espacio aquí
                      // Padding(
                      //     padding: EdgeInsets.only(
                      //       left: 0.08 *
                      //           screenSize.width, // Cambia el espacio aquí
                      //       right: 0.08 *
                      //           screenSize.width, // Cambia el espacio aquí
                      //       bottom: 0.1 * screenSize.height,
                      //     ),
                      //     child: MyButton_Anon(
                      //       onTap: () async {
                      //         setState(() => loading = true);
                      //         dynamic result = await _auth.signInAnon();
                      //         setState(() => loading = false);
                      //         if (result == null) {
                      //           print("Error signing in");
                      //         } else {
                      //           print("Signing in succesful");
                      //         }
                      //       },
                      //     )),
                    ],
                  ),
                ),
              ),
            ),
          );
  }
}
