import 'package:flutter/material.dart';
import 'package:planner_app/components/my_button2.dart';
import 'package:planner_app/components/my_textfield.dart';
import 'package:planner_app/screens/Home.dart';
//import 'package:planner_app/components/square_tile.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  // text editing controllers
  final usernameController = TextEditingController();
  final passwordController = TextEditingController();

  // sign user in method
  void signUserIn() {}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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

            //const SizedBox(height: 30),

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
            MyTextField(
              controller: usernameController,
              hintText: '',
              obscureText: false,
            ),

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
            MyTextField(
              controller: passwordController,
              hintText: '',
              obscureText: true,
            ),

            const SizedBox(height: 215),

            // Sign up button
            MyButton2(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => HomePage()),
                );
              },
            ),
          ], //children
        ),
      ),
    );
    ;
  }
}
