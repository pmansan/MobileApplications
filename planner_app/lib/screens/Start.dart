import 'package:flutter/material.dart';
import 'package:planner_app/components/my_button.dart';
import 'package:planner_app/screens/wrapper.dart';

import '../components/my_button2.dart';

class StartPage extends StatelessWidget {
  final Key? key;
  StartPage({this.key}) : super(key: key);

  bool register = true;

  @override
  Widget build(BuildContext context) {
    final Size screenSize = MediaQuery.of(context).size;
    final double screenWidth = screenSize.width;
    final double screenHeight = screenSize.height;

    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.transparent,
      appBar: null,
      body: SafeArea(
        child: ListView.builder(
          itemCount: 1,
          itemBuilder: (context, index) {
            return Center(
              child: Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topRight,
                    end: Alignment.bottomLeft,
                    colors: [
                      Color(0xfbC3DAF2),
                      Colors.white,
                    ],
                  ),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(height: screenHeight * 0.1),
                    Image(
                      image: AssetImage('lib/images/plannel_logo.png'),
                      height: screenHeight * 0.2,
                    ),
                    SizedBox(height: screenHeight * 0.05),
                    Text(
                      'Welcome to Plannel!',
                      style: TextStyle(
                        color: Color(0xfb3a78b1),
                        fontSize: 25,
                        fontFamily: 'Nunito',
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: screenHeight * 0.1),
                    Padding(
                      padding: EdgeInsets.only(top: screenHeight * 0.1),
                      child: MyButton(
                        onTap: () {
                          register = false;
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => Wrapper(Register: register),
                            ),
                          );
                        },
                      ),
                    ),
                    SizedBox(height: screenHeight * 0.05),
                    Padding(
                      padding: EdgeInsets.only(bottom: screenHeight * 0.05),
                      child: MyButton2(
                        onTap: () {
                          register = true;
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => Wrapper(Register: register),
                            ),
                          );
                        },
                      ),
                    ),
                    SizedBox(height: screenHeight * 0.03),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
