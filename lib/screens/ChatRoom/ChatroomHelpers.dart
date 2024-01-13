import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';
import 'package:smesterproject/screens/AltProfile/alt_profile.dart';
import 'package:smesterproject/screens/Messaging/GroupMessage.dart';
import 'package:smesterproject/services/Authentications.dart';
import 'package:smesterproject/services/FirebaseOperations.dart';

import '../../constants/Constantcolors.dart';

class ChatRoomHelper with ChangeNotifier {
  final ConstantColors constantColors = ConstantColors();
  final TextEditingController chatroomNameController = TextEditingController();
  String chatroomAvatarUrl = '';
  String get getChatroomAvatarUrl => chatroomAvatarUrl;
  String chatroomId = '';
  String get getChatroomId => chatroomId;

  void selectChatroomAvatar(String url) {
    chatroomAvatarUrl = url;
    notifyListeners();
  }

  showChatroomDetails(BuildContext context, DocumentSnapshot documentSnapshot) {
    return showModalBottomSheet(
        context: context,
        builder: (context) {
          var snapshotData = documentSnapshot.data()
              as Map<String, dynamic>?; // Cast with null safety
          String userImage =
              snapshotData?['userimage'] ?? 'empty-removebg-preview.png';
          String userName = snapshotData?['username'] ?? null;
          return Container(
            height: MediaQuery.of(context).size.height * 0.32,
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
                color: constantColors.blueGreyColor,
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(12.0),
                    topRight: Radius.circular(12.0))),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 150.0),
                  child: Divider(
                    thickness: 4.0,
                    color: constantColors.whiteColor,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 5.0),
                  child: Container(
                    decoration: BoxDecoration(
                        border: Border.all(color: constantColors.blueColor),
                        borderRadius: BorderRadius.circular(12.0)),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        'Members',
                        style: TextStyle(
                            color: constantColors.whiteColor,
                            fontSize: 16.0,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ),
                Container(
                  height: MediaQuery.of(context).size.height * 0.08,
                  width: MediaQuery.of(context).size.width,
                  child: StreamBuilder<QuerySnapshot>(
                    stream: FirebaseFirestore.instance
                        .collection('chatrooms')
                        .doc(documentSnapshot.id)
                        .collection('members')
                        .snapshots(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(
                          child: CircularProgressIndicator(),
                        );
                      } else {
                        if (snapshot.hasData && snapshot.data?.docs != null) {
                          return ListView(
                            scrollDirection: Axis.horizontal,
                            children: snapshot.data!.docs
                                .map((DocumentSnapshot documentSnapshot) {
                              var data = documentSnapshot.data()
                                  as Map<String, dynamic>?;
                              String userImageUrl = data != null &&
                                      data.containsKey('userimage')
                                  ? data['userimage'] as String
                                  : 'default_image_url';
                              String Useruid = data != null &&
                                  data.containsKey('useruid')
                                  ? data['useruid'] as String
                                  : 'no uid';
                              return GestureDetector(
                                child: Padding(
                                  padding: const EdgeInsets.only(left: 8.0),
                                  child: CircleAvatar(
                                    backgroundColor: constantColors.darkColor,
                                    backgroundImage: NetworkImage(userImageUrl),
                                  ),
                                ),
                                onTap: () {

                                  // if(Provider.of<Authentication>(context,listen: false).getUserUid != Useruid){
                                  //   Navigator.pushReplacement(context,
                                  //       PageTransition(child: AltProfile(
                                  //         userUid : Useruid
                                  //       ),
                                  //           type: type));
                                  // }
                                },
                              );
                            }).toList(),
                          );
                        } else {
                          return const Center(
                            child: Text("No data available"),
                          );
                        }
                      }
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 5.0),
                  child: Container(
                    decoration: BoxDecoration(
                        border: Border.all(color: constantColors.blueColor),
                        borderRadius: BorderRadius.circular(12.0)),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        'Admin',
                        style: TextStyle(
                            color: constantColors.whiteColor,
                            fontSize: 16.0,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ),
                Container(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CircleAvatar(
                        backgroundColor: constantColors.transparent,
                        backgroundImage: NetworkImage(userImage),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 8.0),
                        child: Text(
                          userName,
                          style: TextStyle(
                              color: constantColors.whiteColor,
                              fontSize: 16.0,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
          );
        });
  }

  showChatRoomSheet(BuildContext context) {
    return showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        builder: (context) {
          return Padding(
            padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom),
            child: Container(
              height: MediaQuery.of(context).size.height * 0.25,
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                  color: constantColors.darkColor,
                  borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(12.0),
                      topRight: Radius.circular(12.0))),
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 150.0),
                    child: Divider(
                      thickness: 4.0,
                      color: constantColors.whiteColor,
                    ),
                  ),
                  Text(
                    'Select Chatroom Avatar',
                    style: TextStyle(
                        color: constantColors.greenColor,
                        fontSize: 14.0,
                        fontWeight: FontWeight.bold),
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.1,
                    child: StreamBuilder<QuerySnapshot>(
                      stream: FirebaseFirestore.instance
                          .collection('chatroomIcons')
                          .snapshots(),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        } else {
                          return Consumer<ChatRoomHelper>(builder:
                              (BuildContext context, chatRoomHelper, child) {
                            return ListView(
                              scrollDirection: Axis.horizontal,
                              children: snapshot.data!.docs
                                  .map((DocumentSnapshot documentSnapshot) {
                                var userData = documentSnapshot.data() as Map<
                                    String, dynamic>?; // Cast with null safety
                                String userImage = userData?['url'] ??
                                    'empty-removebg-preview.png';
                                return GestureDetector(
                                  onTap: () => chatRoomHelper
                                      .selectChatroomAvatar(userImage),
                                  child: Padding(
                                    padding: const EdgeInsets.only(left: 16.0),
                                    child: Container(
                                      decoration: BoxDecoration(
                                        border: Border.all(
                                          color: chatroomAvatarUrl == userImage
                                              ? constantColors.blueColor
                                              : Colors.transparent,
                                          width: chatroomAvatarUrl == userImage
                                              ? 2
                                              : 0,
                                        ),
                                      ),
                                      height: 10.0,
                                      width: 40.0,
                                      child: Image.network(userImage,
                                          fit: BoxFit.cover),
                                    ),
                                  ),
                                );
                              }).toList(),
                            );
                          });
                        }
                      },
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Container(
                        width: MediaQuery.of(context).size.width * 0.7,
                        child: TextField(
                          textCapitalization: TextCapitalization.words,
                          controller: chatroomNameController,
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16.0,
                              color: constantColors.whiteColor),
                          decoration: InputDecoration(
                            hintText: 'Enter Chatroom ID',
                            hintStyle: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16.0,
                                color: constantColors.whiteColor),
                          ),
                        ),
                      ),
                      FloatingActionButton(
                          backgroundColor: constantColors.blueGreyColor,
                          child: Icon(
                            FontAwesomeIcons.plus,
                            color: constantColors.yellowColor,
                          ),
                          onPressed: () async {
                            Provider.of<FirebaseOperations>(context,
                                    listen: false)
                                .submitChatroomData(
                                    chatroomNameController.text, {
                              'roomavatar': getChatroomAvatarUrl,
                              'time': Timestamp.now(),
                              'roomname': chatroomNameController.text,
                              'username': Provider.of<FirebaseOperations>(
                                      context,
                                      listen: false)
                                  .initUserName,
                              'userimage': Provider.of<FirebaseOperations>(
                                      context,
                                      listen: false)
                                  .initUserImage,
                              'useremail': Provider.of<FirebaseOperations>(
                                      context,
                                      listen: false)
                                  .initUserEmail,
                              'useruid': Provider.of<Authentication>(context,
                                      listen: false)
                                  .getUserUid,
                            }).whenComplete(() {
                              Navigator.pop(context);
                            });
                          }),
                    ],
                  )
                ],
              ),
            ),
          );
        });
  }

  showChatrooms(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance.collection('chatrooms').snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child: CircularProgressIndicator(),
          );
        } else if (!snapshot.hasData || snapshot.data == null) {
          // Check for no data
          return Center(
            child: Text("No chatrooms available"),
          );
        } else {
          return ListView(
            children:
                snapshot.data!.docs.map((DocumentSnapshot documentSnapshot) {
              var data = documentSnapshot.data()
                  as Map<String, dynamic>; // Cast to Map
              String roomAvatar = data['roomavatar'] ??
                  'empty-removebg-preview.png'; // Provide a default URL
              String roomName = data['roomname'] ??
                  'empty-removebg-preview.png'; // Provide a default URL

              return ListTile(
                onTap: () {
                  Navigator.pushReplacement(
                      context,
                      PageTransition(
                          child: GroupMessage(
                            documentSnapshot: documentSnapshot,
                          ),
                          type: PageTransitionType.leftToRight));
                },
                onLongPress: () =>
                    showChatroomDetails(context, documentSnapshot),
                title: Text(
                  roomName,
                  style: TextStyle(
                      color: constantColors.whiteColor,
                      fontSize: 16.0,
                      fontWeight: FontWeight.bold),
                ),
                subtitle: Text(
                  'Last Message',
                  style: TextStyle(
                      color: constantColors.greenColor,
                      fontSize: 14.0,
                      fontWeight: FontWeight.bold),
                ),
                trailing: Text(
                  '2 hours ago',
                  style: TextStyle(
                      color: constantColors.whiteColor,
                      fontSize: 10.0,
                      fontWeight: FontWeight.bold),
                ),
                leading: CircleAvatar(
                  backgroundColor: constantColors.transparent,
                  backgroundImage: NetworkImage(roomAvatar),
                ),
                // Add other ListTile properties if needed
              );
            }).toList(),
          );
        }
      },
    );
  }
}
