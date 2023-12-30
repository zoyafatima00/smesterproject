import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';
import 'package:smesterproject/constants/Constantcolors.dart';
import 'package:smesterproject/screens/Homepage/Homepage.dart';
import 'package:smesterproject/services/Authentication.dart';

class LandingHelpers with ChangeNotifier {
  ConstantColors constantColors = ConstantColors();
  Widget bodyImage(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.65,
      width: MediaQuery.of(context).size.width * 1,
      decoration: BoxDecoration(
          image: DecorationImage(
        image: AssetImage("assets/images/3760.jpg"),
      )),
    );
  }

  Widget taglineText(BuildContext context) {
    return Positioned(
        top: 460.0,
        left: 10.0,
        child: Container(
          constraints: BoxConstraints(maxWidth: 170.0),
          child: RichText(
            text: TextSpan(
                text: "Are",
                style: TextStyle(
                    fontFamily: 'Poppins',
                    color: constantColors.whiteColor,
                    fontWeight: FontWeight.bold,
                    fontSize: 40.0),
                children: <TextSpan>[
                  TextSpan(
                      text: ' You ',
                      style: TextStyle(
                          fontFamily: 'Poppins',
                          color: constantColors.whiteColor,
                          fontWeight: FontWeight.bold,
                          fontSize: 40.0)),
                  TextSpan(
                    text: 'Social ',
                    style: TextStyle(
                        fontFamily: 'Poppins',
                        color: constantColors.blueColor,
                        fontWeight: FontWeight.bold,
                        fontSize: 40.0),
                  ),
                  TextSpan(
                      text: '?',
                      style: TextStyle(
                          fontFamily: 'Poppins',
                          color: constantColors.whiteColor,
                          fontWeight: FontWeight.bold,
                          fontSize: 40.0)),
                ]),
          ),
        ));
  }

  Widget mainButton(BuildContext context) {
    return Positioned(
        top: 590.0,
        child: Container(
          width: MediaQuery.of(context).size.width,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              GestureDetector(
                child: Container(
                  child: Icon(
                    EvaIcons.emailOutline,
                    color: constantColors.yellowColor,
                  ),
                  width: 80.0,
                  height: 40.0,
                  decoration: BoxDecoration(
                      border: Border.all(color: constantColors.yellowColor),
                      borderRadius: BorderRadius.circular(10.0)),
                ),
              ),
              GestureDetector(
                onTap: () {
                  Provider.of<Authentication>(context, listen: false)
                      .signInWithGoogle()
                      .whenComplete(() {
                    Navigator.push(
                        context,
                        PageTransition(
                            child: Homepage(),
                            type: PageTransitionType.leftToRight));
                  });
                },
                child: Container(
                  child: Icon(
                    FontAwesomeIcons.google,
                    color: constantColors.redColor,
                  ),
                  width: 80.0,
                  height: 40.0,
                  decoration: BoxDecoration(
                      border: Border.all(color: constantColors.redColor),
                      borderRadius: BorderRadius.circular(10.0)),
                ),
              ),
              GestureDetector(
                child: Container(
                  child: Icon(
                    FontAwesomeIcons.facebookF,
                    color: constantColors.blueColor,
                  ),
                  width: 80.0,
                  height: 40.0,
                  decoration: BoxDecoration(
                      border: Border.all(color: constantColors.blueColor),
                      borderRadius: BorderRadius.circular(10.0)),
                ),
              )
            ],
          ),
        ));
  }

  Widget privacyText(BuildContext context) {
    return Positioned(
        top: 660.0,
        left: 20.0,
        right: 20.0,
        child: Container(
          child: Column(
            children: [
              Text(
                "By continuing you agree theSocial Terms of",
                style: TextStyle(color: Colors.grey.shade600, fontSize: 12.0),
              ),
              Text(
                "Services & Privacy Policy",
                style: TextStyle(color: Colors.grey.shade600, fontSize: 12.0),
              ),
            ],
          ),
        ));
  }
}
