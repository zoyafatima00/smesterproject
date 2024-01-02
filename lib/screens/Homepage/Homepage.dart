import 'package:flutter/material.dart';
import 'package:smesterproject/constants/Constantcolors.dart';
class Homepage extends StatelessWidget {
   Homepage({super.key});
  ConstantColors constantColors = ConstantColors();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: constantColors.redColor,
      body: Text('Home',style: TextStyle(color: Colors.white)),

    );
  }
}
