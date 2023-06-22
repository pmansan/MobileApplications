import 'package:flutter/material.dart';

class Searchbar extends StatelessWidget {
  final controller;
  final String hintText;
  // final bool obscureText;

  const Searchbar({
    super.key,
    required this.controller,
    required this.hintText,
    // required this.obscureText,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25.0),
      child: TextField(
        controller: controller,

        // obscureText: obscureText,
        style: TextStyle(
          fontSize: 15.0,
          fontFamily: 'Nunito',
        ),
        decoration: InputDecoration(
            contentPadding: EdgeInsets.symmetric(horizontal: 8.0, vertical: 0),
            enabledBorder: const OutlineInputBorder(
              borderSide: BorderSide(color: Colors.white),
              borderRadius: BorderRadius.all(Radius.circular(50)),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.grey.shade400),
            ),
            fillColor: Colors.grey.shade200,
            filled: true,
            hintText: hintText,
            hintStyle: TextStyle(color: Colors.grey[500])),
      ),
    );
  }
}
