import 'package:flutter/material.dart';
import 'package:sampleproject/QuizzPage.dart';
//import 'dart:ui';
//import 'package:font_awesome_flutter/font_awesome_flutter.dart';
//import 'package:flutter/material.dart';
import 'package:sampleproject/constants/colors.dart';
import 'package:sampleproject/QuizzPage.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/HomePage.jpg'),
            fit: BoxFit.cover
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text('Do you know all your songs?',
              style: TextStyle(color: ColorConstants.starterWhite, fontSize: 17, fontWeight: FontWeight.w600, ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32,),
            MaterialButton(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(31)),
              height: 58,
              color: ColorConstants.primaryColor,
              onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const QuizzPage())),
              child: const Text('Get Started', style: TextStyle(color: Colors.white, fontSize: 18),) ,
            ),
            const SizedBox(height: 32,)
          ],
        ),
      ),
    );
  }
}