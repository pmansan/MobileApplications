import 'package:flutter/material.dart';

class MyButton_Anon extends StatelessWidget {
  final Function()? onTap;

  const MyButton_Anon({super.key, required this.onTap});

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
            "Sign In Anonimously",
            style: TextStyle(
              color: Color(0xfb3a78b1),
              fontWeight: FontWeight.bold,
              fontSize: 20,
            ),
          ),
        ),
      ),
    );
  }
}
