import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';
import 'package:smesterproject/constants/Constantcolors.dart';
import 'package:smesterproject/screens/Homepage/Homepage.dart';
import 'package:smesterproject/screens/landingPage/landingServices.dart';
import 'package:smesterproject/screens/landingPage/landingUtils.dart';

import '../../services/Authentications.dart';
//import 'package:smesterproject/services/Authentication.dart';

class LandingHelpers with ChangeNotifier {
  ConstantColors constantColors = ConstantColors();
  Widget bodyImage(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.65,
      width: MediaQuery.of(context).size.width * 1,
      decoration: const BoxDecoration(
          image: DecorationImage(
        image: AssetImage("assets/images/3598274.jpg"),
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
        child: SizedBox(
          width: MediaQuery.of(context).size.width,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              GestureDetector(
                onTap: (){
                  emailAuthSheet(context);

                },
                child: Container(
                  width: 80.0,
                  height: 40.0,
                  decoration: BoxDecoration(
                      border: Border.all(color: constantColors.yellowColor),
                      borderRadius: BorderRadius.circular(10.0)),
                  child: Icon(
                    EvaIcons.emailOutline,
                    color: constantColors.yellowColor,
                  ),
                ),
              ),
              GestureDetector(
                onTap: () {
                  print('Signing with google');
                  Provider.of<Authentication>(context, listen: false)
                      .signInWithGoogle()
                      .whenComplete(() {
                    Navigator.pushReplacement(
                        context,
                        PageTransition(
                            child: const Homepage(),
                            type: PageTransitionType.leftToRight));
                  });
                },
                child: Container(
                  width: 80.0,
                  height: 40.0,
                  decoration: BoxDecoration(
                      border: Border.all(color: constantColors.redColor),
                      borderRadius: BorderRadius.circular(10.0)),
                  child: Icon(
                    FontAwesomeIcons.google,
                    color: constantColors.redColor,
                  ),
                ),
              ),
            ],
          ),
        ));
  }

  Widget privacyText(BuildContext context) {
    return Positioned(
        top: 645.0,
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
  emailAuthSheet(BuildContext context){
    return showModalBottomSheet(context: context, builder: (context){
      return  Container(
        height: MediaQuery.of(context).size.height * 0.5,
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
          color: constantColors.blueGreyColor,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(15.0),
            topRight: Radius.circular(15.0)
          )
        ),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 150.0),
              child: Divider(
                thickness: 4.0,
                color: constantColors.whiteColor,
              ),
            ),
            Provider.of<LandingService>(context,listen: false)
                .passwordLessSignIn(context),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                MaterialButton(
                  color: constantColors.blueColor,
                    child: Text("Log In",style:TextStyle(
                      color: constantColors.whiteColor,
                      fontSize: 18.0,
                      fontWeight: FontWeight.bold
                    ),),
                    onPressed:(){
                      Provider.of<LandingService>(context,listen: false).logInSheet(context);
                    }
                ),
                MaterialButton(
                  color: constantColors.redColor,
                    child: Text("Sign Up",style:TextStyle(
                        color: constantColors.whiteColor,
                        fontSize: 18.0,
                        fontWeight: FontWeight.bold
                    ),),
                    onPressed:(){
                    Provider.of<LandingUtils>(context,listen: false).selectAvatarOptionsSheet(context);
                    }
                )
              ],
            )

          ],
        ),

      );
    });
  }
}
