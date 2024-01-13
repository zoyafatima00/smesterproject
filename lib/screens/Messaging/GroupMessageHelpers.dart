import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';
import 'package:smesterproject/screens/ChatRoom/ChatRoom.dart';
import 'package:smesterproject/services/Authentications.dart';
import 'package:smesterproject/services/FirebaseOperations.dart';

import '../../constants/Constantcolors.dart';

class GroupMeassageHelper with ChangeNotifier {
  final ConstantColors constantColors = ConstantColors();
  bool hasMemberJoined = false ;
  bool get getHasMemberJoined => hasMemberJoined;

  showMessages(BuildContext context, DocumentSnapshot documentSnapshot,String adminUserUid) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('chatrooms')
          .doc(documentSnapshot.id)
          .collection('messages')
          .orderBy('time',descending: true)
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (!snapshot.hasData || snapshot.data == null) {
          // Check for no data
          return const Center(
            child: Text("No messages available"),
          );
        } else {
          return ListView(
            reverse: true,
            children: snapshot.data!.docs.map((DocumentSnapshot documentSnapshot) {
              var messageData = documentSnapshot.data() as Map<String, dynamic>?; // Cast with null safety
              String userUid = messageData?['useruid'] ?? 'Unknown id'; // Provide a default value
              String userName = messageData?['username'] ?? 'Unknown user'; // Provide a default value
              String userMessage = messageData?['message'] ?? 'no message'; // Provide a default value
              String userImage = messageData?['userImage'] ?? 'no Image'; // Provide a default value

              return Padding(
                padding: const EdgeInsets.only(top: 4.0),
                child: Container(
                  height: MediaQuery.of(context).size.height * 0.125,
                  width: MediaQuery.of(context).size.width,
                  child: Stack(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 60.0, top: 20.0),
                        child: Row(
                          children: [
                            Container(
                              constraints: BoxConstraints(
                                maxHeight: MediaQuery.of(context).size.height * 0.1,
                                maxWidth: MediaQuery.of(context).size.width * 0.8,
                              ),
                              decoration: BoxDecoration(

                                borderRadius: BorderRadius.circular(8.0),
                                color: Provider.of<Authentication>(context, listen: false).getUserUid == userUid
                                    ? constantColors.blueGreyColor.withOpacity(0.8)
                                    : constantColors.blueGreyColor,
                              ),
                              child: Padding(
                                padding: const EdgeInsets.only(left: 18.0),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                     Container(
                                       width: 150.0,
                                       child: Row(
                                         children: [
                                           Text(userName,style: TextStyle(
                                             color: constantColors.greenColor,
                                             fontWeight: FontWeight.bold,
                                             fontSize: 14.0
                                           ),),
                                           Provider.of<Authentication>(context,listen: false).getUserUid == adminUserUid ?
                                               Padding(
                                                 padding: const EdgeInsets.only(left: 8.0),
                                                 child: Icon(FontAwesomeIcons.chessKing,color: constantColors.yellowColor,size: 12.0,),
                                               ) :
                                               Container(
                                                 height: 0.0,
                                                 width: 0.0,
                                               ),
                                         ],
                                       ),
                                     ),
                                    Text(userMessage,style:
                                      TextStyle(
                                        color: constantColors.whiteColor,
                                        fontSize: 14.0
                                      ),)
                                  ],
                                ),
                              ),

                            ),
                          ],
                        ),
                      ),
                      Positioned(
                          left : 15.0 ,
                          child:
                          Provider.of<Authentication>(context, listen: false).getUserUid == userUid ? Container(
                        child: Column(
                          children: [
                            IconButton(onPressed: (){},
                                icon: Icon(Icons.edit,color: constantColors.blueColor,size: 18.0,)),
                            IconButton(onPressed: (){},
                                icon: Icon(FontAwesomeIcons.trash,color: constantColors.redColor,size: 16.0,))
                          ],
                        ),
                      ) :
                          Container(
                            height: 0.0, width: 0.0,
                          )),
                      Positioned(
                        left: 40,
                          child: Provider.of<Authentication>(context).getUserUid == userUid ?
                              Container(height: 0.0 , width: 0.0,):
                              CircleAvatar(backgroundColor: constantColors.darkColor,
                              backgroundImage: NetworkImage(userImage),
                              )
                      ),
                    ],
                  ),
                ),
              );
            }).toList(),
          );
        }
      },
    );
  }


  sendMessage(BuildContext context, DocumentSnapshot documentSnapshot,
      TextEditingController messageController) {
    return FirebaseFirestore.instance
        .collection('chatrooms')
        .doc(documentSnapshot.id)
        .collection('messages')
        .add({
      'message': messageController.text.toString(),
      'time': Timestamp.now(),
      'useruid': Provider.of<Authentication>(context, listen: false).getUserUid,
      'username':
          Provider.of<FirebaseOperations>(context, listen: false).initUserName,
      'userImage':
          Provider.of<FirebaseOperations>(context, listen: false).initUserImage,
    });
  }

  Future checkIfJoined(BuildContext context, String chatRoomName, String chatRoomAdminUid) async {
    // Get the user UID with a null check
    final userUid = Provider.of<Authentication>(context, listen: false).getUserUid;

    // Check if userUid is not null
    if (userUid != null) {
      return FirebaseFirestore.instance.collection('chatrooms').doc(chatRoomName).collection('members').doc(userUid).get().then((value) {
        hasMemberJoined = false;
        print('has Member joined => $hasMemberJoined');

        if (value.data()?['joined'] != null) {
          hasMemberJoined = value.data()?['joined'];  // Corrected the brackets here
          print('final state => $hasMemberJoined');
          notifyListeners();
        }

        if (userUid == chatRoomAdminUid) {
          hasMemberJoined = true;
          notifyListeners();
        }
      });
    } else {
      // Handle the case where userUid is null
      print("User UID is null");
      // Add any additional handling you might need here
    }
  }

  askToJoin(BuildContext context , String roomName){
    return showDialog(context: context, builder: (context){
      return AlertDialog(
        backgroundColor: constantColors.darkColor,
        title: Text('Join $roomName' , style: TextStyle(
          color: constantColors.whiteColor,
          fontSize: 16.0,
          fontWeight: FontWeight.bold
        ),),
        actions: [
          MaterialButton(onPressed: (){
            Navigator.pushReplacement(
                context,
                PageTransition(
                    child: ChatRoom(),
                    type: PageTransitionType.leftToRight));
          },
          child: Text('No',style: TextStyle(
              color: constantColors.whiteColor,
              fontSize: 14.0,
              decoration: TextDecoration.underline,
              decorationColor: constantColors.whiteColor,
              fontWeight: FontWeight.bold
          ),),),

          MaterialButton(onPressed: () async{
          FirebaseFirestore.instance.collection('chatrooms').doc(
            roomName
          ).collection('members').doc(
            Provider.of<Authentication>(context,listen: false).getUserUid
          ).set({
            'joined' : true,
            'username' : Provider.of<FirebaseOperations>(context,listen: false).initUserName,
            'userimage':  Provider.of<FirebaseOperations>(context,listen: false).initUserImage,
            'useruid':  Provider.of<Authentication>(context,listen: false).getUserUid,
            'time' : Timestamp.now()

          }).whenComplete(() {
            Navigator.pop(context);
          });
          },
            color: constantColors.blueColor,
            child: Text('Yes',style: TextStyle(
                color: constantColors.whiteColor,
                fontSize: 14.0,
                decoration: TextDecoration.underline,
                decorationColor: constantColors.whiteColor,
                fontWeight: FontWeight.bold
            ),),)
        ],
      );
    });

  }

}
