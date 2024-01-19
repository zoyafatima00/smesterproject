import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';
import 'package:smesterproject/screens/Homepage/Homepage.dart';
import 'package:smesterproject/services/FirebaseOperations.dart';

import '../../constants/Constantcolors.dart';
import 'ChatroomHelpers.dart';

class ChatRoom extends StatefulWidget {
  ChatRoom({super.key});

  @override
  State<ChatRoom> createState() => _ChatRoomState();
}

class _ChatRoomState extends State<ChatRoom> {
  final ConstantColors constantColors = ConstantColors();
  bool isButtonPressedFirstTime = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
          backgroundColor: constantColors.blueGreyColor,
          child: Icon(
            FontAwesomeIcons.plus,
            color: constantColors.greenColor,
          ),
          onPressed: () {
            Provider.of<ChatRoomHelper>(context,listen: false).showChatRoomSheet(context);
            //Provider.of<FirebaseOperations>(context,listen: false).addImages();
            if (!isButtonPressedFirstTime) {
              Provider.of<FirebaseOperations>(context, listen: false).addImages();
              setState(() {
                isButtonPressedFirstTime = true;
              });
            }

          }),
      appBar:  AppBar(
        backgroundColor: constantColors.darkColor.withOpacity(0.6),
        centerTitle: true,
        actions: [
          IconButton(icon: Icon(EvaIcons.moreVertical,color: constantColors.whiteColor,), onPressed: () {
          },)
        ],
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios_new_rounded,
            color: constantColors.whiteColor,
          ),
          onPressed: () {
            Navigator.pushReplacement(
                context,
                PageTransition(
                    child: const Homepage(), type: PageTransitionType.leftToRight));
          },
        ),

        // leading:IconButton(icon: Icon(FontAwesomeIcons.plus,color: constantColors.greenColor,), onPressed: () {
          //   Provider.of<ChatRoomHelper>(context,listen: false).showChatRoomSheet(context);
          //
          // },),
        title: RichText(
          text: TextSpan(
              text: 'Chat ',
              style: const TextStyle(color: Colors.white,fontSize: 20,fontWeight: FontWeight.bold),
              children: [
                TextSpan(text: 'Box',
                  style: TextStyle(color: constantColors.lightBlueColor,fontSize: 20,fontWeight: FontWeight.bold),)
              ]
          ),
        ),

      ),
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: Provider.of<ChatRoomHelper>(context, listen: false).showChatrooms(context),
      ),
    );
  }

}
