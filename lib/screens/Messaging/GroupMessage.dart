import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';
import 'package:smesterproject/screens/ChatRoom/ChatRoom.dart';
import 'package:smesterproject/screens/Homepage/Homepage.dart';
import 'package:smesterproject/screens/Messaging/GroupMessageHelpers.dart';
import 'package:smesterproject/services/Authentications.dart';

import '../../constants/Constantcolors.dart';

class GroupMessage extends StatefulWidget {
  final DocumentSnapshot documentSnapshot;
  GroupMessage({super.key, required this.documentSnapshot});

  @override
  State<GroupMessage> createState() => _GroupMessageState();
}

class _GroupMessageState extends State<GroupMessage> {
  final ConstantColors constantColors = ConstantColors();
  TextEditingController messageController = TextEditingController();

  @override
  void initState() {
    super.initState();

    final groupMessageHelper = Provider.of<GroupMeassageHelper>(context, listen: false);
    final documentData = widget.documentSnapshot.data();

    // Cast the document data to Map<String, dynamic> if it is not null
    if (documentData != null && documentData is Map<String, dynamic>) {
      final userUid = documentData['useruid'];

      // Check if 'useruid' is not null
      if (userUid != null) {
        groupMessageHelper.checkIfJoined(context, widget.documentSnapshot.id, userUid).whenComplete(() {
          if (!groupMessageHelper.getHasMemberJoined) {
            Timer(Duration(milliseconds: 10), () {
              groupMessageHelper.askToJoin(context, widget.documentSnapshot.id);
            });
          }
        });
      } else {
        // Handle the case where 'useruid' is null
      }
    } else {
      // Handle the case where document data is null or not a map
    }
  }



  @override
  Widget build(BuildContext context) {
    // Cast the data to Map<String, dynamic> and handle null
    var data = widget.documentSnapshot.data() as Map<String, dynamic>?;
    String roomName = data?['roomname'] ?? 'no chatroom of this name';
    String roomAvatar = data?['roomavatar'] ??
        'empty-removebg-preview.png'; // Provide a default URL
    String userUid = data?['useruid'] ?? 'no uid'; // Provide a default URL
    return Scaffold(
      appBar: AppBar(
        actions: [
          Provider.of<Authentication>(context).getUserUid == userUid
              ? Icon(
                  EvaIcons.moreVertical,
                  color: constantColors.whiteColor,
                )
              : Container(
                  height: 0.0,
                  width: 0.0,
                ),
          IconButton(
              onPressed: () {},
              icon: Icon(
                EvaIcons.logOut,
                color: constantColors.redColor,
              )),


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
                    child: ChatRoom(), type: PageTransitionType.leftToRight));
          },
        ),
        centerTitle: true,
        backgroundColor: constantColors.darkColor.withOpacity(0.6),
        title: SizedBox(
          width: MediaQuery.of(context).size.width * 0.5,
          child: Row(
            children: [
              CircleAvatar(
                backgroundColor: constantColors.darkColor,
                backgroundImage: NetworkImage(roomAvatar),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 8.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      roomName,
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16.0,
                          color: constantColors.whiteColor),
                    ),
                    StreamBuilder<QuerySnapshot>(
                        stream: FirebaseFirestore.instance.collection('chatrooms').doc(
                          widget.documentSnapshot.id
                        ).collection('members').snapshots(),
                        builder: (context,snapshot){
                          if(snapshot.connectionState == ConnectionState.waiting){
                            return const Center(
                              child: CircularProgressIndicator(),
                            );
                          }
                          else {
                            return Text('${snapshot.data?.docs.length.toString()} members',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 12.0,
                                  color: constantColors.greenColor.withOpacity(0.5)),
                            );
                          }
                        })
                  ],
                ),
              )
            ],
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          color: constantColors.darkColor,
          child: Column(
            children: [
              AnimatedContainer(
                child: Provider.of<GroupMeassageHelper>(context,listen: false).showMessages(context, widget.documentSnapshot, userUid),
                height: MediaQuery.of(context).size.height * 0.8,
                width: MediaQuery.of(context).size.width,
                duration: Duration(seconds: 1),
                curve: Curves.bounceIn,
              ),
              Padding(
                padding:EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
                child: Row(
                  children: [
                    GestureDetector(
                      child: CircleAvatar(
                        radius: 18.0,
                        backgroundColor: constantColors.transparent,
                        backgroundImage: const AssetImage('assets/icons/sunflower-removebg-preview.png'),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: SizedBox(
                        width: MediaQuery.of(context).size.width*0.68,
                        child: TextField(
                          controller: messageController,
                          style: TextStyle(
                            color: constantColors.whiteColor,
                            fontSize: 16.0,
                            fontWeight: FontWeight.bold
                          ),
                          decoration: InputDecoration(
                            hintText: 'Drop a Hi...',
                            hintStyle: TextStyle(
                                color: constantColors.greenColor,
                                fontSize: 16.0,
                                fontWeight: FontWeight.bold
                            ),
                          ),
                        ),
                      ),
                    ),
                    FloatingActionButton(onPressed: (){
                      if(messageController.text.isNotEmpty){
                        Provider.of<GroupMeassageHelper>(context,listen: false)
                            .sendMessage(context, widget.documentSnapshot, messageController);
                        messageController.clear();
                      }
                    },backgroundColor:
                      constantColors.blueColor,
                    child: Icon(Icons.send_sharp,color: constantColors.whiteColor),)
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
