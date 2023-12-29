import 'package:flutter/material.dart';
import 'package:smesterproject/constants/Constantcolors.dart';
class Landingpage extends StatelessWidget {
   Landingpage({super.key});
  ConstantColors constantColors = ConstantColors();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: constantColors.whiteColor,
    );
  }
}
