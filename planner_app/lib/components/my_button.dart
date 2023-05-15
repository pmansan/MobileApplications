import 'package:flutter/material.dart';

class MyButton extends StatelessWidget {
  final Function()? onTap;

  const MyButton({super.key, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(25),
        margin: const EdgeInsets.symmetric(horizontal: 25),
        decoration: BoxDecoration(
          color: Colors.transparent,
          border: Border.all(color: Color(0xfb3a78b1)),
          borderRadius: BorderRadius.circular(50),
        ),
        child: const Center(
          child: Text(
            "Log In",
            style: TextStyle(
              color:  Color(0xfb3a78b1),
              fontFamily: 'Nunito',
              fontWeight: FontWeight.bold,
              fontSize: 20,
            ),
          ),
        ),
      ),
    );
  }
}