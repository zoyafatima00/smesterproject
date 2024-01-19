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
import 'package:timeago/timeago.dart' as timeago;

class ChatRoomHelper with ChangeNotifier {
  final ConstantColors constantColors = ConstantColors();
  final TextEditingController chatroomNameController = TextEditingController();
  String chatroomAvatarUrl = '';
  String get getChatroomAvatarUrl => chatroomAvatarUrl;
  String chatroomId = '';
  String get getChatroomId => chatroomId;
  String latestMessageTime = '';
  String get getLatestMessageTime => latestMessageTime;


  final List<Color> tileColors = [
    Colors.indigo,
    Colors.green,
    Colors.blue,
    Colors.purple,
    // Add more colors as needed
  ];

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
          return const Center(
            child: CircularProgressIndicator(),
          );
        } else if (!snapshot.hasData || snapshot.data == null) {
          // Check for no data
          return const Center(
            child: Text("No chatrooms available"),
          );
        } else {
          return ListView(
            children:
            snapshot.data!.docs.asMap().map((index, DocumentSnapshot documentSnapshot) {
              showLatestMessageTime(documentSnapshot['time']);
              var data = documentSnapshot.data()
                  as Map<String, dynamic>; // Cast to Map
              String roomAvatar = data['roomavatar'] ??
                  'empty-removebg-preview.png'; // Provide a default URL
              String roomName = data['roomname'] ??
                  'empty-removebg-preview.png';
              Color tileColor = tileColors[index % tileColors.length];

              return MapEntry(
                index, Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: ListTile(

                    shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(25),
                            topRight: Radius.circular(25),
                            bottomRight: Radius.circular(10),
                            bottomLeft: Radius.circular(10))
                    ),
                    tileColor: tileColor,
                    textColor: Colors.white,
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
                      trailing: Container(
                        height: 45.0,
                        width: 80.0, // Adjusted the width to a non-zero value for visibility
                        child: StreamBuilder<QuerySnapshot>(
                          stream: FirebaseFirestore.instance
                              .collection('chatrooms')
                              .doc(documentSnapshot.id)
                              .collection('messages')
                              .orderBy('time', descending: true)
                              .snapshots(),
                          builder: (context, snapshot) {
                            if (snapshot.connectionState == ConnectionState.waiting) {
                              return const Center(child: CircularProgressIndicator());
                            }
                            else if (snapshot.hasError) {
                              return Text('Error: ${snapshot.error}');
                            }
                            else if (snapshot.hasData && snapshot.data!.docs.isNotEmpty) {
                              var firstDoc = snapshot.data!.docs.first.data() as Map<String, dynamic>;
                              var time = firstDoc['time']; // Assuming 'time' is in the correct format
                              showLatestMessageTime(time);
                              return Text(
                                getLatestMessageTime, // Make sure this is the formatted time string
                                style: TextStyle(
                                    color: constantColors.whiteColor,
                                    fontSize: 11.0,
                                    fontWeight: FontWeight.bold
                                ),
                              );
                            }
                            else {
                              return Text('No messages'); // Updated for clarity
                            }
                          },
                        ),
                      ),

                    title: Text(
                      roomName,
                      style: TextStyle(
                          color: constantColors.whiteColor,
                          fontSize: 16.0,
                          fontWeight: FontWeight.bold),
                    ),
                    subtitle: Padding(
                      padding: const EdgeInsets.only(bottom: 8.0),
                      child: Container(
                        height: 20,
                        child: StreamBuilder<QuerySnapshot>(
                          stream: FirebaseFirestore.instance
                              .collection('chatrooms')
                              .doc(documentSnapshot.id)
                              .collection('messages')
                              .orderBy('time', descending: true)
                              .snapshots(),
                          builder: (context, snapshot) {
                            if (snapshot.connectionState == ConnectionState.waiting) {
                              return const Center(child: CircularProgressIndicator());
                            } else if (snapshot.hasError) {
                              return Text('Error: ${snapshot.error}');
                            } else if (snapshot.hasData && snapshot.data!.docs.isNotEmpty) {
                              var firstDoc = snapshot.data!.docs.first.data() as Map<String, dynamic>;
                              if (firstDoc.containsKey('username') && firstDoc.containsKey('message')) {
                                return Text(
                                  '${firstDoc['username']} : ${firstDoc['message']}',
                                  style: TextStyle(
                                      color: constantColors.greenColor,
                                      fontSize: 14.0,
                                      fontWeight: FontWeight.bold
                                  ),
                                );
                              }
                              else {
                                return Text('No messages or incomplete data');
                              }
                            }
                            else {
                              return Text('No messages',
                                style: TextStyle(
                                    color: constantColors.greenColor,
                                    fontSize: 14.0,
                                    fontWeight: FontWeight.bold
                                ),);
                            }
                          },
                        ),
                      ),
                    ),

                    leading: CircleAvatar(
                      backgroundColor: constantColors.transparent,
                      backgroundImage: NetworkImage(roomAvatar),
                    ),
                    contentPadding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0),
                    // Add other ListTile properties if needed
                  ),
                ),
              );
            }).values.toList(),
          );
        }
      },
    );
  }

  showLatestMessageTime(dynamic timeData){
    Timestamp t = timeData;
    DateTime dateTime = t.toDate();
    latestMessageTime = timeago.format(dateTime);
    notifyListeners;

  }
}
