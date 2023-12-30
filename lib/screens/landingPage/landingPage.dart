import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smesterproject/constants/Constantcolors.dart';
import 'package:smesterproject/screens/landingPage/landingHelpers.dart';

class Landingpage extends StatelessWidget {
  Landingpage({super.key});
  final ConstantColors constantColors = ConstantColors();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: constantColors.whiteColor,
      body: Stack(
        children: [
          bodyColor(),
          Provider.of<LandingHelpers>(context, listen: false)
              .bodyImage(context),
          Provider.of<LandingHelpers>(context, listen: false)
              .taglineText(context),
          Provider.of<LandingHelpers>(context, listen: false)
              .mainButton(context),
          Provider.of<LandingHelpers>(context, listen: false)
              .privacyText(context)
        ],
      ),
    );
  }

  bodyColor() {
    return Container(
      decoration: BoxDecoration(
          gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              stops: [
            0.5,
            0.9
          ],
              colors: [
            Colors.black,
            constantColors.darkColor,
          ])),
    );
  }
}
