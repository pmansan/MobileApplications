import 'package:flutter/material.dart';

const textInputDecoration = InputDecoration(
  fillColor: Color(0xFFE0E0E0),
  filled: true,
  enabledBorder: OutlineInputBorder(
    borderSide: BorderSide(color: Colors.white),
    borderRadius: BorderRadius.all(Radius.circular(20)),
  ),
  focusedBorder: OutlineInputBorder(
    borderSide: BorderSide(color: Color(0xFFE0E0E0)),
  ),
);
