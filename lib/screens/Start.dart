import 'package:flutter/material.dart';
import 'package:planner_app/components/my_button.dart';
import 'package:planner_app/screens/SigIn.dart';
import 'package:planner_app/screens/Signup.dart';

import '../components/my_button2.dart';

class StartPage extends StatelessWidget {
  // ignore: prefer_const_constructors_in_immutables
  StartPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.transparent,
      //No app bar
      appBar: null,
      body: SafeArea(
        //Centramos
        child: Center(
          //Fondo degradado
          child: Container(
              decoration: const BoxDecoration(
                  gradient: LinearGradient(
                begin: Alignment.topRight,
                end: Alignment.bottomLeft,
                colors: [
                  Color(0xfbC3DAF2),
                  Colors.white,
                ],
              )),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  //Espacio
                  const SizedBox(height: 80),

                  // Logo
                  const Image(
                    image: AssetImage('lib/images/plannel_logo.png'),
                    height: 130,
                  ),

                  //Espacio
                  const SizedBox(height: 70),

                  //Texto bienvenida
                  const Text(
                    'Welcome to Plannel!',
                    style: TextStyle(
                        color: Color(0xfb3a78b1),
                        fontSize: 20,
                        fontFamily: 'Nunito',
                        fontWeight: FontWeight.bold),
                  ),

                  //Espacio
                  const SizedBox(height: 150),

                  // Sign in button
                  MyButton(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => SignInPage()),
                      );
                    },
                  ),

                  const SizedBox(height: 10),

                  // Sign up button
                  MyButton2(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => SignUpPage()),
                      );
                    },
                  ),

                  //Espacio
                  const SizedBox(height: 25),
                ], //Children
              )),
        ),
      ),
    );
  }
}
