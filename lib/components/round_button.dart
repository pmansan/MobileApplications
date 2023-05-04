import 'package:flutter/material.dart';
import 'package:planner_app/screens/CreateTrip.dart';

class RoundButton extends StatelessWidget {
  final Function()? onTap;


  const RoundButton({
    super.key,
    required this.onTap
  });


  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 80.0,
        height: 80.0,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Color(0xffb3a78b1),
        ),
        child: Icon(Icons.add_rounded, color: Colors.white,size: 70,),
      ),
    );
  }
}